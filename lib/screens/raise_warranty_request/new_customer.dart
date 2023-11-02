import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/model/customer_model.dart';
import 'package:saur_dealer/widgets/input_field_light.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

import '../../main.dart';
import '../../model/list_model/allocated_list.dart';
import '../../model/user_model.dart';
import '../../model/warranty_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/helper_method.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field_dark.dart';
import '../../widgets/primary_button.dart';
import 'installation_address_screen.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});
  static const String routePath = '/newCustomerScreen';
  static bool agreementStatus = false;

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _serialNumberCtrl = TextEditingController();
  final TextEditingController _otpCodeCtrl = TextEditingController();
  AllocatedList? list;
  late ApiProvider _api;

  String code = '';

  Timer? _timer;
  static const int otpResendThreshold = 10;
  int _secondsRemaining = otpResendThreshold;
  bool _timerActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    await _api
        .getAllocatedWarrantyList(SharedpreferenceKey.getUserId())
        .then((value) {
      setState(() {
        list = value;
      });
    });
  }

  void startTimer() {
    _secondsRemaining = otpResendThreshold;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _timerActive = true;
        } else {
          _timer?.cancel();
          _timerActive = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Customer',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_nameCtrl.text.isEmpty ||
                  _phoneCtrl.text.isEmpty ||
                  _otpCodeCtrl.text.isEmpty ||
                  _serialNumberCtrl.text.isEmpty) {
                SnackBarService.instance
                    .showSnackBarError('All fields are mandatory');
                return;
              }

              if (!isValidPhoneNumber(_phoneCtrl.text)) {
                SnackBarService.instance
                    .showSnackBarError('Invalid phone number');
                return;
              }

              if (!isValidSerialNumber(_serialNumberCtrl.text)) {
                SnackBarService.instance
                    .showSnackBarError('Invalid Serial number');
                return;
              }

              if (_otpCodeCtrl.text != code) {
                SnackBarService.instance.showSnackBarError('Incorrect OTP');
                return;
              }

              if (!(list?.data?.map((e) => e.warrantySerialNo).toList() ?? [])
                  .contains(_serialNumberCtrl.text)) {
                SnackBarService.instance.showSnackBarError(
                    'This serial number is not allocated to you.');
                return;
              }

              WarrantyModel? warrantyModel =
                  await _api.getDeviceBySerialNo(_serialNumberCtrl.text);
              if (warrantyModel == null) {
                SnackBarService.instance
                    .showSnackBarError('Invalid serial number');
                return;
              }
              CustomerModel customerModel = CustomerModel(
                  customerName: _nameCtrl.text,
                  mobileNo: _phoneCtrl.text,
                  status: 'CREATED');
              _api.createCustomer(customerModel).then((value) async {
                if (value) {
                  CustomerModel? newUser =
                      await _api.getCustomerByPhoneNumber(_phoneCtrl.text);
                  prefs.setString(SharedpreferenceKey.newCustSerial,
                      warrantyModel.warrantySerialNo ?? '');
                  prefs.setString(
                      SharedpreferenceKey.newCustPhone, _phoneCtrl.text);
                  prefs.setInt(
                      SharedpreferenceKey.newCustId, newUser?.customerId ?? -1);
                  Navigator.pushNamed(
                      context, InstallationAddressScreen.routePath);
                }
              });
            },
            child: const Text('Next'),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        InputFieldLight(
          hint: 'Full Name',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: LineAwesomeIcons.user,
        ),
        verticalGap(defaultPadding * 1.5),
        InputFieldLight(
          hint: 'Mobile Number',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: LineAwesomeIcons.phone,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _timerActive
                ? null
                : () {
                    if (_phoneCtrl.text.length != 10 ||
                        !isNumeric(_phoneCtrl.text)) {
                      SnackBarService.instance.showSnackBarError(
                          'Enter valid 10 digit mobile number');
                      return;
                    }
                    code = getOTPCode();
                    log('OTP = $code');
                    startTimer();
                    _api.sendOtp(_phoneCtrl.text, code);
                  },
            child: Text(
                _timerActive
                    ? 'Resend in $_secondsRemaining seconds'
                    : 'Send OTP',
                style: Theme.of(context).textTheme.labelLarge),
          ),
        ),
        verticalGap(defaultPadding),
        InputFieldLight(
          hint: 'OTP',
          controller: _otpCodeCtrl,
          keyboardType: TextInputType.number,
          obscure: false,
          icon: LineAwesomeIcons.lock,
        ),
        verticalGap(defaultPadding * 1.5),
        InputFieldLight(
          hint: 'System Serial Number',
          controller: _serialNumberCtrl,
          keyboardType: TextInputType.number,
          obscure: false,
          icon: LineAwesomeIcons.plug,
          maxChar: 6,
        ),
        verticalGap(defaultPadding * 2),
        // PrimaryButton(
        //   onPressed: () async {
        //     if (_nameCtrl.text.isEmpty ||
        //         _phoneCtrl.text.isEmpty ||
        //         _otpCodeCtrl.text.isEmpty ||
        //         _serialNumberCtrl.text.isEmpty) {
        //       SnackBarService.instance
        //           .showSnackBarError('All fields are mandatory');
        //       return;
        //     }

        //     if (!isValidPhoneNumber(_phoneCtrl.text)) {
        //       SnackBarService.instance
        //           .showSnackBarError('Invalid phone number');
        //       return;
        //     }

        //     if (!isValidSerialNumber(_serialNumberCtrl.text)) {
        //       SnackBarService.instance
        //           .showSnackBarError('Invalid Serial number');
        //       return;
        //     }

        //     if (_otpCodeCtrl.text != code) {
        //       SnackBarService.instance.showSnackBarError('Incorrect OTP');
        //       return;
        //     }
        //     WarrantyModel? warrantyModel =
        //         await _api.getDeviceBySerialNo(_serialNumberCtrl.text);
        //     if (warrantyModel == null) {
        //       SnackBarService.instance
        //           .showSnackBarError('Invalid serial number');
        //       return;
        //     }
        //     CustomerModel customerModel = CustomerModel(
        //         customerName: _nameCtrl.text,
        //         mobileNo: _phoneCtrl.text,
        //         status: 'CREATED');
        //     _api.createCustomer(customerModel).then((value) async {
        //       if (value) {
        //         CustomerModel? newUser =
        //             await _api.getCustomerByPhoneNumber(_phoneCtrl.text);
        //         prefs.setString(SharedpreferenceKey.newCustSerial,
        //             warrantyModel.warrantySerialNo ?? '');
        //         prefs.setString(
        //             SharedpreferenceKey.newCustPhone, _phoneCtrl.text);
        //         prefs.setInt(
        //             SharedpreferenceKey.newCustId, newUser?.customerId ?? -1);
        //         Navigator.pushNamed(
        //             context, InstallationAddressScreen.routePath);
        //       }
        //     });
        //   },
        //   label: 'Register',
        //   isDisabled: _api.status == ApiStatus.loading,
        //   isLoading: _api.status == ApiStatus.loading,
        // ),
      ],
    );
  }
}

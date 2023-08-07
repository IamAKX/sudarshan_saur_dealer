import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/model/list_model/customer_list_model.dart';
import 'package:saur_dealer/screens/request/add_address_screen.dart';
import 'package:saur_dealer/utils/theme.dart';
import 'package:saur_dealer/widgets/gaps.dart';
import 'package:saur_dealer/widgets/input_field_light.dart';
import 'package:saur_dealer/widgets/primary_button_dark.dart';
import 'package:string_validator/string_validator.dart';

import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/preference_key.dart';
import '../../widgets/alert_popup.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});
  static const String routePath = '/newRequestScreen';

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _serialNumberCtrl = TextEditingController();
  final TextEditingController addressLine1Ctrl = TextEditingController();
  final TextEditingController addressLine2Ctrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController zipCodeCtrl = TextEditingController();

  Timer? _timer;
  static const int otpResendThreshold = 10;
  int _secondsRemaining = otpResendThreshold;
  bool _timerActive = false;
  bool _showOTPField = false;
  bool _isOtpValidated = false;

  late ApiProvider _api;
  CustomerListModel? customerList;
  String code = "";

  sendOtp() {
    code = (Random().nextInt(9000) + 1000).toString();
    ApiProvider().sendOtp(_phoneCtrl.text, code.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneCtrl.addListener(() {
      if (_phoneCtrl.text.isNotEmpty) {
        _api.getCustomerByPhone(_phoneCtrl.text).then((value) {
          customerList = value;
          _nameCtrl.text = customerList?.data?.first.customerName ?? '';
          _emailCtrl.text = customerList?.data?.first.email ?? '';

          addressLine1Ctrl.text =
              customerList?.data?.first.address?.addressLine1 ?? '';
          addressLine2Ctrl.text =
              customerList?.data?.first.address?.addressLine2 ?? '';
          stateCtrl.text = customerList?.data?.first.address?.state ?? '';
          cityCtrl.text = customerList?.data?.first.address?.city ?? '';
          zipCodeCtrl.text = customerList?.data?.first.address?.zipCode ?? '';
          _addressCtrl.text =
              '${addressLine1Ctrl.text}, ${addressLine2Ctrl.text}, ${cityCtrl.text}, ${stateCtrl.text}, ${zipCodeCtrl.text}';
        });
      }
    });
  }

  void startTimer() {
    _isOtpValidated = false;
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
  void dispose() {
    if (_timer != null) _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Request',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: getBody(context));
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        InputFieldLight(
          hint: 'Customer\'s Phone Number',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: LineAwesomeIcons.phone,
        ),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
          hint: 'Full Name',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: LineAwesomeIcons.user,
        ),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
          hint: 'Email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          icon: LineAwesomeIcons.at,
        ),
        verticalGap(defaultPadding / 2),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: backgroundDark,
                title: const Text('Address'),
                actions: [
                  TextButton(
                    onPressed: () {
                      _addressCtrl.text = '';
                      addressLine1Ctrl.text = '';
                      addressLine2Ctrl.text = '';
                      cityCtrl.text = '';
                      stateCtrl.text = '';
                      zipCodeCtrl.text = '';
                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addressCtrl.text =
                          '${addressLine1Ctrl.text}, ${addressLine2Ctrl.text}, ${cityCtrl.text}, ${stateCtrl.text}, ${zipCodeCtrl.text}';
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'),
                  ),
                ],
                content: AddAddressScreen(
                    addressLine1Ctrl: addressLine1Ctrl,
                    addressLine2Ctrl: addressLine2Ctrl,
                    cityCtrl: cityCtrl,
                    stateCtrl: stateCtrl,
                    zipCodeCtrl: zipCodeCtrl),
              ),
            );
          },
          child: InputFieldLight(
            hint: 'Address',
            controller: _addressCtrl,
            keyboardType: TextInputType.streetAddress,
            obscure: false,
            enabled: false,
            icon: LineAwesomeIcons.home,
          ),
        ),
        verticalGap(defaultPadding / 2),
        Align(
          alignment: Alignment.centerRight,
          child: _timerActive
              ? TextButton(
                  onPressed: null,
                  child: Text('Resend in $_secondsRemaining seconds'),
                )
              : TextButton(
                  onPressed: () {
                    _showOTPField = true;
                    startTimer();
                    sendOtp();
                  },
                  child: Text(
                    'Send OTP',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: primaryColor),
                  ),
                ),
        ),
        Visibility(
          visible: _showOTPField,
          child: verticalGap(defaultPadding),
        ),
        Visibility(
          visible: _showOTPField,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '   Enter the OTP',
              ),
              Icon(
                _isOtpValidated
                    ? Icons.check_circle_outline
                    : Icons.warning_amber,
                color: _isOtpValidated ? acceptedColor : pendingColor,
              )
            ],
          ),
        ),
        Visibility(
            visible: _showOTPField, child: verticalGap(defaultPadding / 2)),
        Visibility(
          visible: _showOTPField,
          child: OTPTextField(
            length: 4,
            width: MediaQuery.of(context).size.width - (defaultPadding * 3),
            fieldWidth: 40,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: textColorDark),
            otpFieldStyle: OtpFieldStyle(
              enabledBorderColor: primaryColor,
              borderColor: hintColor,
              focusBorderColor: primaryColor,
            ),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.underline,
            onCompleted: (pin) {
              _otpCtrl.text = pin;

              setState(() {
                if (pin == code) {
                  _isOtpValidated = true;
                } else {
                  _isOtpValidated = false;
                }
              });
            },
          ),
        ),
        Visibility(
          visible: _isOtpValidated,
          child: verticalGap(defaultPadding * 2),
        ),
        Visibility(
          visible: _isOtpValidated,
          child: InputFieldLight(
              hint: 'Serial Number',
              controller: _serialNumberCtrl,
              keyboardType: TextInputType.text,
              obscure: false,
              icon: LineAwesomeIcons.hashtag),
        ),
        Visibility(
          visible: _isOtpValidated,
          child: verticalGap(defaultPadding * 2),
        ),
        Visibility(
          visible: _isOtpValidated,
          child: PrimaryButtonDark(
              onPressed: () {
                if (_phoneCtrl.text.isEmpty ||
                    _nameCtrl.text.isEmpty ||
                    _emailCtrl.text.isEmpty ||
                    _serialNumberCtrl.text.isEmpty ||
                    addressLine1Ctrl.text.isEmpty ||
                    cityCtrl.text.isEmpty ||
                    stateCtrl.text.isEmpty ||
                    zipCodeCtrl.text.isEmpty) {
                  SnackBarService.instance
                      .showSnackBarError('All fields are mandatory');
                  return;
                }

                if (!isEmail(_emailCtrl.text)) {
                  SnackBarService.instance
                      .showSnackBarError('Enter valid email');
                  return;
                }
                int? dealerId = prefs.getInt(SharedpreferenceKey.userId);
                Map<String, dynamic> reqBody = {
                  "warrantySerialNo": _serialNumberCtrl.text,
                  "dealers": {"dealerId": dealerId},
                  "customer": {
                    "customerId": customerList?.data?.first.customerId ?? 0,
                    "customerName": _nameCtrl.text,
                    "mobileNo": _phoneCtrl.text,
                    "email": _emailCtrl.text,
                    "address": {
                      "addressLine1": addressLine1Ctrl.text,
                      "addressLine2": addressLine2Ctrl.text,
                      "city": cityCtrl.text,
                      "state": stateCtrl.text,
                      "country": "India",
                      "zipCode": zipCodeCtrl.text
                    },
                  },
                  "allocationStatus": "PENDING",
                  "initUserType": "DEALER",
                  "initiatedBy": "$dealerId",
                  "approvedBy": ""
                };

                _api.createNewWarrantyRequest(reqBody).then((value) {
                  if (value) {
                    _nameCtrl.text = '';
                    _phoneCtrl.text = '';
                    _emailCtrl.text = '';
                    _addressCtrl.text = '';
                    addressLine1Ctrl.text = '';
                    addressLine2Ctrl.text = '';
                    cityCtrl.text = '';
                    stateCtrl.text = '';
                    zipCodeCtrl.text = '';
                    _timerActive = false;
                    _showOTPField = false;
                    _isOtpValidated = false;
                    showPopup(context, DialogType.success, 'Done!',
                        'We have received your request. You will hear from us in 24 hours');
                  }
                });
              },
              label: 'Raise Request',
              isDisabled: _api.status == ApiStatus.loading,
              isLoading: _api.status == ApiStatus.loading),
        ),
      ],
    );
  }
}

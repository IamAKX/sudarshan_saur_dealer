import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/address_model.dart';
import '../../model/list_model/state_district_list_model.dart';
import '../../model/state_district_model.dart';
import '../../model/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/constants.dart';
import '../../utils/helper_method.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field_dark.dart';
import '../../widgets/input_field_light.dart';
import 'business_detail.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  static const String routePath = '/addressScreen';

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late ApiProvider _api;
  UserModel? user;

  final TextEditingController _houseNumberCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _street1Ctrl = TextEditingController();
  final TextEditingController _street2Ctrl = TextEditingController();
  final TextEditingController _landmarkCtrl = TextEditingController();
  final TextEditingController _talukaCtrl = TextEditingController();
  final TextEditingController _townCtrl = TextEditingController();
  final TextEditingController _zipCodeCtrl = TextEditingController();

  StateDistrictListModel? stateDistrictList;
  String? selectedState;
  String? selectedDistrict;

  @override
  void initState() {
    super.initState();
    stateDistrictList =
        StateDistrictListModel.fromMap(Constants.stateDistrictRaw);
    // selectedDistrict = stateDistrictList!.states!
    //     .firstWhere((element) => element.state == selectedState)
    //     .districts!
    //     .first;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    user = await _api.getDealerById(SharedpreferenceKey.getUserId());
    setState(() {
      _houseNumberCtrl.text = user?.address?.houseNo ?? '';
      _areaCtrl.text = user?.address?.area ?? '';
      _street1Ctrl.text = user?.address?.street1 ?? '';
      _street2Ctrl.text = user?.address?.street2 ?? '';
      _landmarkCtrl.text = user?.address?.landmark ?? '';
      _talukaCtrl.text = user?.address?.taluk ?? '';
      _townCtrl.text = user?.address?.town ?? '';
      _zipCodeCtrl.text = user?.address?.zipCode ?? '';
      selectedDistrict = user?.address?.district;
      selectedState = user?.address?.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Address',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!isValidInputs()) {
                  return;
                }
                AddressModel address = AddressModel(
                    houseNo: _houseNumberCtrl.text,
                    area: _areaCtrl.text,
                    street1: _street1Ctrl.text,
                    street2: _street2Ctrl.text,
                    landmark: _landmarkCtrl.text,
                    state: selectedState,
                    district: selectedDistrict,
                    country: 'India',
                    taluk: _talukaCtrl.text,
                    town: _townCtrl.text,
                    zipCode: _zipCodeCtrl.text);

                _api.updateUser({'address': address.toMap()},
                    user?.dealerId ?? -1).then((value) {
                  if (value) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, BusinessDetails.routePath, (route) => false);
                  }
                });
              },
              child: const Text('Next'),
            ),
          ],
        ),
        body: getBody(context));
  }

  bool isValidInputs() {
    if (_houseNumberCtrl.text.isEmpty) {
      SnackBarService.instance
          .showSnackBarError('House Number cannot be empty');
      return false;
    }
    if (_areaCtrl.text.isEmpty) {
      SnackBarService.instance.showSnackBarError('Area cannot be empty');
      return false;
    }
    if (_street1Ctrl.text.isEmpty) {
      SnackBarService.instance.showSnackBarError('Street 1 cannot be empty');
      return false;
    }
    if (_landmarkCtrl.text.isEmpty) {
      SnackBarService.instance.showSnackBarError('Landmark cannot be empty');
      return false;
    }
    if (selectedState?.trim().isEmpty ?? true) {
      SnackBarService.instance.showSnackBarError('State cannot be empty');
      return false;
    }
    if (selectedDistrict?.trim().isEmpty ?? true) {
      SnackBarService.instance.showSnackBarError('District cannot be empty');
      return false;
    }
    if (_talukaCtrl.text.isEmpty) {
      SnackBarService.instance.showSnackBarError('Taluka cannot be empty');
      return false;
    }
    if (_townCtrl.text.isEmpty) {
      SnackBarService.instance
          .showSnackBarError('Place / Town cannot be empty');
      return false;
    }
    if (!isValidZipcode(_zipCodeCtrl.text)) {
      SnackBarService.instance.showSnackBarError('Invalid pincode');
      return false;
    }
    return true;
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        InputFieldLight(
            hint: 'House Number',
            controller: _houseNumberCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Colony / Area',
            controller: _areaCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Street 1',
            controller: _street1Ctrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Street 2',
            controller: _street2Ctrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Landmark',
            controller: _landmarkCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding),
        const Text('     Select State'),
        verticalGap(defaultPadding / 2),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultPadding * 3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: selectedState,
              underline: null,
              isExpanded: true,
              hint: Text(
                'Select ',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: stateDistrictList!.states!.map((StateDistrictModel value) {
                return DropdownMenuItem<String>(
                  value: value.state,
                  child: Text(value.state!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedDistrict = null;
                  log('selectedState : $selectedState');
                  // selectedDistrict = stateDistrictList!.states!
                  //     .firstWhere((element) => element.state == selectedState)
                  //     .districts!
                  //     .first;
                });
              },
            ),
          ),
        ),
        verticalGap(defaultPadding),
        const Text('     Select District'),
        verticalGap(defaultPadding / 2),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultPadding * 3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: selectedDistrict,
              underline: null,
              isExpanded: true,
              hint: Text(
                'Select ',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: selectedState == null
                  ? []
                  : stateDistrictList?.states
                          ?.firstWhere(
                              (element) => element.state == selectedState)
                          .districts
                          ?.map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList() ??
                      [],
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                });
              },
            ),
          ),
        ),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Taluka',
            controller: _talukaCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Place / Town',
            controller: _townCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding / 2),
        InputFieldLight(
            hint: 'Pincode',
            controller: _zipCodeCtrl,
            keyboardType: TextInputType.number,
            obscure: false,
            maxChar: 6,
            icon: LineAwesomeIcons.home),
        verticalGap(defaultPadding),
      ],
    );
  }
}

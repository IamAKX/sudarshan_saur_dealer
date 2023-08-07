import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:saur_dealer/widgets/input_field_light.dart';

import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field_dark.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen(
      {super.key,
      required this.addressLine1Ctrl,
      required this.addressLine2Ctrl,
      required this.cityCtrl,
      required this.stateCtrl,
      required this.zipCodeCtrl});

  static const String routePath = '/addAddressScreen';

  final TextEditingController addressLine1Ctrl;
  final TextEditingController addressLine2Ctrl;
  final TextEditingController cityCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController zipCodeCtrl;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    return SizedBox(
      height: 400,
      width: 300,
      child: ListView(
        shrinkWrap: true,
        children: [
          InputFieldLight(
            hint: 'Address Line 1',
            controller: widget.addressLine1Ctrl,
            keyboardType: TextInputType.streetAddress,
            obscure: false,
            icon: LineAwesomeIcons.home,
          ),
          verticalGap(defaultPadding),
          InputFieldLight(
            hint: 'Address Line 2',
            controller: widget.addressLine2Ctrl,
            keyboardType: TextInputType.streetAddress,
            obscure: false,
            icon: LineAwesomeIcons.home,
          ),
          verticalGap(defaultPadding),
          InputFieldLight(
            hint: 'City',
            controller: widget.cityCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home,
          ),
          verticalGap(defaultPadding),
          InputFieldLight(
            hint: 'State',
            controller: widget.stateCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.home,
          ),
          verticalGap(defaultPadding),
          InputFieldLight(
            hint: 'Zip code',
            controller: widget.zipCodeCtrl,
            keyboardType: TextInputType.number,
            obscure: false,
            icon: LineAwesomeIcons.home,
          ),
          verticalGap(defaultPadding),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field_dark.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails(
      {super.key,
      required this.businessNameCtrl,
      required this.businessAddressCtrl,
      required this.gstNumberCtrl});
  final TextEditingController businessNameCtrl;
  final TextEditingController businessAddressCtrl;
  final TextEditingController gstNumberCtrl;

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InputFieldDark(
          hint: 'Business Name',
          controller: widget.businessNameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: LineAwesomeIcons.briefcase,
        ),
        verticalGap(defaultPadding * 1.5),
        InputFieldDark(
          hint: 'Business Address',
          controller: widget.businessAddressCtrl,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: LineAwesomeIcons.address_card,
        ),
        verticalGap(defaultPadding * 1.5),
        InputFieldDark(
          hint: 'GST Number',
          controller: widget.gstNumberCtrl,
          keyboardType: TextInputType.text,
          obscure: false,
          icon: LineAwesomeIcons.store,
        ),
      ],
    );
  }
}

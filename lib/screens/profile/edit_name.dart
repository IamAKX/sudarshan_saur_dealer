// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/alert_popup.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field_light.dart';
import '../../widgets/primary_button_dark.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _businessNameCtrl = TextEditingController();
  final TextEditingController _gstNumberCtrl = TextEditingController();

  late ApiProvider _api;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    await _api
        .getDealerById(prefs.getInt(SharedpreferenceKey.userId) ?? -1)
        .then((value) {
      setState(() {
        user = value;
        _nameCtrl.text = user?.dealerName ?? '';
        _businessNameCtrl.text = user?.businessName ?? '';
        _gstNumberCtrl.text = user?.gstNumber ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        verticalGap(defaultPadding),
        const Text(
          'Enter your name',
        ),
        verticalGap(defaultPadding),
        InputFieldLight(
            hint: 'Full Name',
            controller: _nameCtrl,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: LineAwesomeIcons.user),
        verticalGap(defaultPadding),
        const Text(
          'Enter Business name',
        ),
        verticalGap(defaultPadding),
        InputFieldLight(
            hint: 'Business Name',
            controller: _businessNameCtrl,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: LineAwesomeIcons.briefcase),
        verticalGap(defaultPadding),
        const Text(
          'Enter GST Number',
        ),
        verticalGap(defaultPadding),
        InputFieldLight(
            hint: 'GST Number',
            controller: _gstNumberCtrl,
            keyboardType: TextInputType.text,
            obscure: false,
            icon: LineAwesomeIcons.store),
        verticalGap(defaultPadding),
        PrimaryButtonDark(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty ||
                _businessNameCtrl.text.isEmpty ||
                _gstNumberCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }

            Map<String, dynamic> map = {
              "dealerName": _nameCtrl.text,
              "businessName": _businessNameCtrl.text,
              "gstNumber": _gstNumberCtrl.text
            };
            _api.updateUser(map, user?.dealerId ?? -1).then((value) async {
              if (value) {
                await reloadScreen();
                showPopup(context, DialogType.success, 'Success',
                    'Your detail is updated');
              }
            });
          },
          label: 'Validate and Update',
          isDisabled: _api.status == ApiStatus.loading,
          isLoading: _api.status == ApiStatus.loading,
        )
      ],
    );
  }
}

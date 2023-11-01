import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/input_field_light.dart';
import '../home_container/home_container.dart';
import 'login_screen.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});
  static const String routePath = '/businessDetails';
  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  late ApiProvider _api;
  UserModel? user;

  final TextEditingController _gstCtrl = TextEditingController();
  final TextEditingController _businessNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    user = await _api.getDealerById(SharedpreferenceKey.getUserId());
    setState(() {
      _gstCtrl.text = user?.gstNumber ?? '';
      _businessNameCtrl.text = user?.businessName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Business Detail',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!isValidInputs()) {
                  return;
                }
                _api.updateUser({
                  'businessName': _businessNameCtrl.text,
                  'gstNumber': _gstCtrl.text,
                }, user?.dealerId ?? -1).then((value) {
                  if (value) {
                    SnackBarService.instance.showSnackBarSuccess(
                        'Registration complete. Please login');
                    prefs.clear();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routePath, (route) => false);
                  }
                });
              },
              child: const Text('Next'),
            ),
          ],
        ),
        body: getBody(context));
  }

  getBody(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(defaultPadding), children: [
      InputFieldLight(
          hint: 'GST Number',
          controller: _gstCtrl,
          keyboardType: TextInputType.text,
          obscure: false,
          icon: LineAwesomeIcons.store),
      verticalGap(defaultPadding / 2),
      InputFieldLight(
          hint: 'Business Name',
          controller: _businessNameCtrl,
          keyboardType: TextInputType.text,
          obscure: false,
          icon: LineAwesomeIcons.store),
      verticalGap(defaultPadding / 2),
    ]);
  }

  bool isValidInputs() {
    if (_gstCtrl.text.isEmpty) {
      SnackBarService.instance.showSnackBarError('GST Number cannot be empty');
      return false;
    }
    if (_businessNameCtrl.text.isEmpty) {
      SnackBarService.instance
          .showSnackBarError('Business Name cannot be empty');
      return false;
    }
    return true;
  }
}

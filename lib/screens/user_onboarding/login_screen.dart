import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/screens/password_recovery/recover_password_screen.dart';
import 'package:saur_dealer/screens/user_onboarding/register_screen.dart';
import 'package:saur_dealer/utils/colors.dart';
import 'package:saur_dealer/utils/theme.dart';
import 'package:saur_dealer/widgets/gaps.dart';
import 'package:saur_dealer/widgets/input_field_dark.dart';
import 'package:saur_dealer/widgets/input_password_field_dark.dart';
import 'package:saur_dealer/widgets/primary_button.dart';
import 'package:string_validator/string_validator.dart';

import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/enum.dart';
import '../../utils/helper_method.dart';
import '../../utils/preference_key.dart';
import '../blocked_user/blocked_users_screen.dart';
import '../home_container/home_container.dart';
import 'change_phone.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routePath = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  late ApiProvider _api;
  String code = '';

  Timer? _timer;
  static const int otpResendThreshold = 10;
  int _secondsRemaining = otpResendThreshold;
  bool _timerActive = false;

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
  void dispose() {
    if (_timer != null) _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            blueGradientDark,
            blueGradientLight,
          ],
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding,
              ),
              children: [
                verticalGap(defaultPadding * 1.5),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                verticalGap(defaultPadding),
                Text(
                  'Welcome\nBack',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                verticalGap(defaultPadding * 1.5),
               InputFieldDark(
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
                            startTimer();
                            code = getOTPCode();
                            _api.sendOtp(_phoneCtrl.text, code);
                          },
                    child: Text(
                      _timerActive
                          ? 'Resend in $_secondsRemaining seconds'
                          : 'Send OTP',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                InputFieldDark(
                  hint: 'OTP',
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  obscure: false,
                  icon: LineAwesomeIcons.lock,
                ),
                verticalGap(defaultPadding * 2),
                PrimaryButton(
                  onPressed: () {
                    if (_otpCtrl.text == code) {
                      _api
                          .getDealerMobileNumber(_phoneCtrl.text)
                          .then((value) {
                        if (value == null || (value.data?.isEmpty ?? true)) {
                          SnackBarService.instance
                              .showSnackBarError('User not registered');
                          return;
                        }

                        prefs.setInt(SharedpreferenceKey.userId,
                            value.data?.first.dealerId ?? -1);

                        if (value.data?.first.status ==
                            UserStatus.ACTIVE.name) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeContainer.routePath,
                            (route) => false,
                          );
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            BlockedUserScreen.routePath,
                            (route) => false,
                          );
                        }
                      });
                    } else {
                      SnackBarService.instance
                          .showSnackBarError('Incorrect OTP');
                    }
                  },
                  label: 'Login',
                  isDisabled: _api.status == ApiStatus.loading,
                  isLoading: _api.status == ApiStatus.loading,
                ),
                verticalGap(defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routePath);
                      },
                      child: Text(
                        'Register',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      color: Colors.white,
                      width: 2,
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ChangePhoneNumber.routePath);
                      },
                      child: Text(
                        'Change Mobile Number',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 150,
                  ),
                  Text(
                    'Dealer',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

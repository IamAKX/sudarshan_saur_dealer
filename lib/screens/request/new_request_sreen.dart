import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:saur_dealer/utils/theme.dart';
import 'package:saur_dealer/widgets/gaps.dart';
import 'package:saur_dealer/widgets/input_field_light.dart';
import 'package:saur_dealer/widgets/primary_button_dark.dart';

import '../../utils/colors.dart';
import '../../widgets/alert_popup.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});
  static const String routePath = '/newRequestScreen';

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _serialNumberCtrl = TextEditingController();

  Timer? _timer;
  static const int otpResendThreshold = 10;
  int _secondsRemaining = otpResendThreshold;
  bool _timerActive = false;
  bool _showOTPField = false;
  bool _isOtpValidated = false;

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
                if (pin == '1234') {
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
                showPopup(context, DialogType.success, 'Done!',
                    'We have received your request. You will hear from us in 24 hours');
              },
              label: 'Raise Request',
              isDisabled: false,
              isLoading: false),
        ),
      ],
    );
  }
}

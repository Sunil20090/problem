import 'package:election/components/colored_button.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(),
            Text(
              "OTP verification",
              style: getTextTheme().headlineMedium,
            ),
            addVerticalSpace(),
            ColoredButton(
                onPressed: () => Navigator.pop(context, [{"data" : "Verified"}]),
                child: Text(
                  'Verify',
                  style: getTextTheme(color: COLOR_BASE).titleLarge,
                ))
          ],
        ),
      ),
    );
  }
}

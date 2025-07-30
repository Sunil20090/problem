import 'package:election/components/colored_button.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  void _verifyOtp() {
    String otp = _controllers.map((c) => c.text).join();

    
    checkFromApi(otp);

    if (otp.length == 6) {
      print('Entered OTP: $otp');
      // Add your OTP verification logic here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a 6-digit OTP")),
      );
    }
  }

  checkFromApi(String otp) async {
    final Map<String, dynamic> body = {
      'otp': otp,
      'user_id': USER_ID
    };
    ApiResponse response = await postService(URL_CREATE_OTP_VERIFICATION, body);

    if(response.isSuccess){
      showAlert(context, 'Success!', response.body['message'], onDismiss: () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }else {
      showAlert(context, 'Error!','Error: ');
    }
  }

  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP Resent")),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }
  
  Widget _buildOtpBox(int index) {
    return Container(
      width: 45,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Column(
          children: [
              ScreenActionBar(title: 'Otp Verification'),
            Container(
              padding: SCREEN_PADDING,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text("Enter the 6-digit code sent to your number",
                      style: TextStyle(fontSize: 16)),
                  addVerticalSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, _buildOtpBox),
                  ),
                  addVerticalSpace(30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColoredButton(
                        onPressed: (){
                          _verifyOtp();
                        },
                        child: Text("Verify", style: getTextTheme(color: COLOR_BASE).titleMedium,),),
                    ],
                  ),
                  addVerticalSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                    onPressed: _resendOtp,
                    child: Text("Resend OTP"),
                  ),
                    ],
                  ),
                  
                
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

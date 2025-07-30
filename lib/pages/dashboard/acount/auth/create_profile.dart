import 'package:election/components/colored_button.dart';
import 'package:election/components/floating_label_edit_box.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/pages/dashboard/acount/auth/otp_verification.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class CreateProfile extends StatefulWidget {
  final dynamic profile;
  CreateProfile({super.key, this.profile});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              ScreenActionBar(
                title: 'Create Profile',
                child: Row(
                  children: [
                    ColoredButton(
                      radius: 18,
                        onPressed: () {
                          postProfile();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Update',
                                style:
                                    getTextTheme(color: COLOR_BASE).titleSmall),
                                    Icon(Icons.update, color: COLOR_BASE,),
                          ],
                        )),
                  ],
                ),
              ),
              // addVerticalSpace(),
              
              addVerticalSpace(),

              Container(
                padding: SCREEN_PADDING,
                child: Column(
                  children: [
                    FloatingLabelEditBox(
                      labelText: 'Name',
                      controller: _nameController,
                    ),
                    addVerticalSpace(),
                    FloatingLabelEditBox(
                      labelText: 'Description',
                      maxLines: 4,
                      controller: _descriptionController,
                    ),
                    addVerticalSpace(),
                    FloatingLabelEditBox(
                      labelText: 'Email',
                      controller: _emailController,
                    ),
                    addVerticalSpace(),
                    FloatingLabelEditBox(
                      labelText: 'Password',
                      hideText: true,
                      controller: _emailController,
                    ),
                    addVerticalSpace(),
                    FloatingLabelEditBox(
                      labelText: 'Confirm Password',
                      controller: _emailController,
                    ),
                    addVerticalSpace(DEFAULT_LARGE_SPACE),
                    
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  formIsValid() {
    return !(_nameController.text.isEmpty &&
        _emailController.text.isEmpty &&
        _passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty &&
        _descriptionController.text.isEmpty);
  }

  postProfile() async {
    if (!formIsValid()) {
      showAlert(context, 'Alert!', "Complete the form", isError: true);
      return;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showAlert(context, 'Alert!', "Password do not matched!", isError: true);
      return;
    }

    var payload = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "mail_id": _emailController.text,
      "password": _passwordController.text,
    };

    ApiResponse response = await postService(URL_CREATE_DATA_PROFILE, payload);

    if (response.isSuccess) {
      //showAlert(context, 'Success!', response.body['message']);
      openOTPScreen();
    } else {
      showAlert(context, 'Failed!', "The response is failed!");
    }
  }

  openOTPScreen(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>OtpVerification()));
  }
}

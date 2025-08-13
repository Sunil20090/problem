import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/account_screen.dart';
import 'package:Problem/pages/dashboard/acount/auth/otp_verification.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
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

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
        title: 'Create Profile',
        child: Row(
          children: [
            !isLoading
                ? ColoredButton(
                    radius: 18,
                    onPressed: () {
                      postProfile();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Create',
                            style: getTextTheme(color: COLOR_BASE).titleSmall),
                        Icon(
                          Icons.update_disabled_outlined,
                          color: COLOR_BASE,
                        ),
                      ],
                    ))
                : ColoredButton(
                    child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(color: COLOR_BASE,))),
          ],
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(),
          Column(
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
                controller: _passwordController,
              ),
              addVerticalSpace(),
              FloatingLabelEditBox(
                labelText: 'Confirm Password',
                controller: _confirmPasswordController,
              ),
              addVerticalSpace(DEFAULT_LARGE_SPACE),
            ],
          )
        ],
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
    } else if (_emailController.text.contains(' ')) {
      showAlert(context, 'Alert!', "Email should not contain spaces",
          isError: true);
      return false;
    }

    int user_id = await getUserId();

    var payload = {
      "user_id": user_id,
      "name": _nameController.text,
      "description": _descriptionController.text,
      "mail_id": _emailController.text.toLowerCase(),
      "password": _passwordController.text
    };

    setState(() {
      isLoading = true;
    });

    ApiResponse response = await postService(URL_CREATE_DATA_PROFILE, payload);

    setState(() {
      isLoading = false;
    });
    if (response.isSuccess) {
      showAlert(context, response.body['heading'], response.body['message'],
          onDismiss: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        int user_id = await getUserId();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => AccountScreen(user_id: user_id,)));
      });
    } else {
      showAlert(context, 'Failed!', "The response is failed!");
    }
  }

  openOTPScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => OtpVerification()));
  }
}

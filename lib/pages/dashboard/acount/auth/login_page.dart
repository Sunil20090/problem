import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/auth/create_profile.dart';
import 'package:Problem/pages/dashboard/dashboard_screen.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:Problem/utils/storage_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Login'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addVerticalSpace(DEFAULT_LARGE_SPACE),
          FloatingLabelEditBox(
            labelText: 'username',
            controller: _usernameController,
          ),
          addVerticalSpace(),
          FloatingLabelEditBox(
            labelText: 'password',
            hideText: true,
            controller: _passwordController,
          ),
          addVerticalSpace(36),
          ColoredButton(
              onPressed: !isLoading
                  ? () {
                      login();
                    }
                  : null,
              child: !isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: getTextTheme(color: COLOR_BASE).titleMedium,
                        ),
                        addHorizontalSpace(),
                        Icon(
                          Icons.login,
                          color: COLOR_BASE,
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            color: COLOR_BASE,
                          ),
                        )
                      ],
                    ))
        ],
      ),
    );
  }

  void moveToCreateFormPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => CreateProfile()));
  }

  void login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showAlert(context, 'Empty!', 'Please enter both username and pasword');
      return;
    }

    var body = {
      "username": _usernameController.text.toLowerCase().trim(),
      "password": _passwordController.text
    };

    setState(() {
      isLoading = true;
    });

    ApiResponse response = await postService(URL_USER_LOGIN, body);

    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      if (response.body['status'] == 'OK') {
        await saveUserToLocal(response.body);
        moveToDashBoardPage();
      } else {
        showAlert(context, response.body['heading'], response.body['message']);
      }
    }
  }

  void moveToDashBoardPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => DashboardScreen()));
  }

  saveUserToLocal(body) async {
    await saveUser(body);
  }
}

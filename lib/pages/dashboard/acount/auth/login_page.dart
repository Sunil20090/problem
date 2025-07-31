import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/enter_text_box.dart';
import 'package:Problem/components/screen_template.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/pages/form_create_page.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Login!',
      description: 'Login here with your email id or create password!',
      child: Column(
        children: [
          addVerticalSpace(UI_PADDING * 3),
          SizedBox(width: 80, height: 80, child: Icon(Icons.person_2_outlined)),
          EnterTextBox(
            hintText: 'mail id',
            type: TextInputType.emailAddress,
          ),
          addVerticalSpace(UI_PADDING),
          EnterTextBox(
            hintText: 'password',
            obscureText: true,
          ),
          addVerticalSpace(UI_PADDING),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {},
                  child: Text('Forget password?',
                      style: TextStyle(color: Colors.white)))
            ],
          ),
          addVerticalSpace(UI_PADDING * 2),
          ColoredButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                moveToCreateFormPage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login'),
                  addHorizontalSpace(UI_SPACE),
                  Icon(Icons.login)
                ],
              ))
        ],
      ),
    );
  }

  void moveToCreateFormPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => FormCreatePage()));
  }
}

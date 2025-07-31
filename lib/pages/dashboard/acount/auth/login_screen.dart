import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        // padding: SCREEN_PADDING,
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  padding: SCREEN_PADDING,
                  child: Row(
                    children: [
                      Text(
                        'Login!',
                        style: TextStyle(
                            fontSize: 38,
                            color: COLOR_BASE,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: COLOR_PRIMARY,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                )),
            Expanded(
                flex: 7,
                child: Container(
                  padding: SCREEN_PADDING,
                  child: Column(
                    children: [
                      addVerticalSpace(50),
                      FloatingLabelEditBox(labelText: 'username'),
                      addVerticalSpace(20),
                      FloatingLabelEditBox(
                        labelText: 'password',
                        hideText: true,
                      ),
                      addVerticalSpace(50),
                      ColoredButton(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                color: COLOR_BASE,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.login,
                            color: COLOR_BASE,
                          )
                        ],
                      )),
                      addVerticalSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              'By singing up you will agree our terms of service?'),
                          addHorizontalSpace(6),
                          Text(
                            'Sign Up',
                            style: TextStyle(color: COLOR_PRIMARY),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(113, 168, 75, 255),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(100))),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}

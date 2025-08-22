import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class ScreenFrame extends StatelessWidget {
  Widget titleBar;
  Widget? body;
  ScreenFrame({super.key, required this.titleBar, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: SCREEN_PADDING,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleBar,
                  addVerticalSpace(2),
                  (body != null)
                      ? Expanded(child: SingleChildScrollView(child: body!))
                      : Container()
                ])));
  }
}

import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class ScreenFrame extends StatelessWidget {
  Widget titleBar;
  Widget? body;
  bool backButton;
  ScreenFrame({super.key, required this.titleBar, this.body, this.backButton = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: SCREEN_PADDING,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       (backButton) ? Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back, color: COLOR_PRIMARY,)),
                          addHorizontalSpace(4),
                          Expanded(child: titleBar),
                        ],
                      ) : titleBar,
                      addVerticalSpace(2),
                      (body != null)
                          ? Expanded(child: SingleChildScrollView(child: body!))
                          : Container()
                    ]))));
  }
}

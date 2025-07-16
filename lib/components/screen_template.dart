import 'package:election/components/page_heading.dart';
import 'package:election/constants/local_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class ScreenTemplate extends StatelessWidget {

  Widget? child;
  String title, description;
  ScreenTemplate({super.key, this.child, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: SCREEN_PADDING,
        decoration: getAppDecoration(),
        child: Column(
          children: [
            addVerticalSpace(UI_PADDING),
            PageHeading(title: title, description: description),
            addVerticalSpace(UI_PADDING),
            if(child != null) child!
          ],
        ),
      ),
    );
  }
}
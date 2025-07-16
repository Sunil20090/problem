import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class ScreenActionBar extends StatelessWidget {
  String title;
  ScreenActionBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            addHorizontalSpace(),
            Text(
              title,
              style: TextStyle(
                  fontSize: CUSTOM_TEXT_THEME.headlineLarge?.fontSize,
                  color: COLOR_PRIMARY),
            ),
          ],
        ),
        Divider(
          height:  1,
        )
      ],
    );
  }
}

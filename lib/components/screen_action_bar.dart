import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';


class ScreenActionBar extends StatelessWidget {
  String title;
  Widget? child;
  ScreenActionBar({super.key, required this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addHorizontalSpace(),
            Text(
              title,
              style: TextStyle(
                  fontSize: CUSTOM_TEXT_THEME.headlineMedium?.fontSize,
                  color: COLOR_PRIMARY),
            ),
            if(child != null) child!
          ],
        ),
        Divider(
          height:  1,
        )
      ],
    );
  }
}

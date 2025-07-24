import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class ScreenActionBar extends StatelessWidget {
  String title;
  Widget? child;
  ScreenActionBar({super.key, required this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: CONTENT_PADDING_VALUE, right: CONTENT_PADDING_VALUE, top: CONTENT_PADDING_VALUE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: getTextTheme().headlineMedium,
                ),
                Spacer(),
                Container(
                  child: child,
                )
              ],
            ),
            addVerticalSpace(),
            Divider(
              height: 1,
            )
          ],  
        ),
      ),
    );
  }
}

import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {


  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: SCREEN_PADDING,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenActionBar(title: 'Profile:'),
                 addVerticalSpace(40),
                Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 222,
                        height: 222,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: COLOR_BASE, width: 4),
                          image: DecorationImage(
                            image: NetworkImage(USER_AVATAR_URL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      addVerticalSpace(),
                Text(
                  USER_ID,
                  style: CUSTOM_TEXT_THEME.headlineMedium,
                ),
                    ],
                  ),
                ),
                
              ],
            )));
  }
}

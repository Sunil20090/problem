import 'package:election/api/data/sample_data.dart';
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
  var _accountDetails;
  var _skills = [];

  @override
  void initState() {
    super.initState();
    initAccountDetails();
    initSkills();
  }

  initSkills() {
    _skills = DATA_PROBLEM_REQUIREMENT;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: SCREEN_PADDING,
            child: _accountDetails != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenActionBar(title: 'Profile:'),
                      addVerticalSpace(10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
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
                          addHorizontalSpace(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _accountDetails['name'],
                                style: CUSTOM_TEXT_THEME.headlineMedium,
                              ),
                              addVerticalSpace(),
                              Text(_accountDetails['description'])
                            ],
                          ),
                        ],
                      ),
                      addVerticalSpace(),
                      Text(
                        'Skills:',
                        style: CUSTOM_TEXT_THEME.headlineSmall,
                      ),
                      Column(
                        children: _skills
                            .map((element) => Text(element['name']))
                            .toList(),
                      )
                    ],
                  )
                : Text('data')));
  }

  void initAccountDetails() {
    _accountDetails = DATA_ACCOUNT_DETAILS;
  }
}

import 'dart:io';

import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/constants/image_constant.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  var _accountDetails;
  var _skills = [
    {"name": "JAVA", "value": 9},
    {"name": "Android", "value": 9}
  ];
  var _achievements = [];

  @override
  void initState() {
    super.initState();

    initAccountDetails();

    initSkills();

    initHistory();
  }

  initAccountDetails() async {
    var response =
        await postService(URL_GET_PROFILE, {"user_id": 9});
    print(response.body);
    if (response.isSuccess) {
      setState(() {
        _accountDetails = response.body;
      });
    }
  }

  initSkills() {}

  initHistory() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (_accountDetails != null)
            ? Container(
                padding: SCREEN_PADDING,
                child: Column(
                  children: [
                    ScreenActionBar(title: 'Account'),
                    addVerticalSpace(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileThumbnail(
                          width: 80,
                          height: 80,
                          radius: 40,
                          thumnail_url: _accountDetails['thumbnail_url'],
                          imageUrl: _accountDetails['image_url'],
                        ),
                        addHorizontalSpace(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _accountDetails['name'],
                              style: getTextTheme().titleMedium,
                            ),
                            addVerticalSpace(8),
                            Text(
                              '${_accountDetails['username']}',
                              style: getTextTheme(color: COLOR_GREY).titleSmall,
                            ),
                            addVerticalSpace(8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lightbulb_circle_outlined,
                                  color: COLOR_PRIMARY,
                                ),
                                Text(
                                  formatNumber(
                                      _accountDetails['solution_posted']),
                                  style: getTextTheme(color: COLOR_BLACK)
                                      .titleSmall,
                                ),
                                addHorizontalSpace(16),
                                Icon(
                                  Icons.check_circle_outline,
                                  color: COLOR_PRIMARY,
                                ),
                                Text(
                                  formatNumber(43),
                                  style: getTextTheme(color: COLOR_BLACK)
                                      .titleSmall,
                                ),
                                addHorizontalSpace(16),
                                Icon(
                                  Icons.extension,
                                  color: COLOR_PRIMARY,
                                ),
                                Text(
                                  formatNumber(34),
                                  style: getTextTheme(color: COLOR_BLACK)
                                      .titleSmall,
                                ),
                                addHorizontalSpace(16)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    addVerticalSpace(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description:',
                                style: getTextTheme().titleSmall,
                              ),
                              Container(
                                child: Text(
                                  _accountDetails['description'],
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              addVerticalSpace(),
                              Text(
                                'Skills:',
                                style: getTextTheme().titleSmall,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _skills.map((skill) {
                                  return Text('${skill['name']}');
                                }).toList(),
                              ),
                              addVerticalSpace(),
                              Text(
                                'Posts:',
                                style: getTextTheme().titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ))
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Please create your profile', style: getTextTheme().headlineMedium,),
                    TextButton(onPressed: () {}, child: Text('Update'))
                  ],
                ),
              ));
  }
}

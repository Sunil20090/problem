import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/auth/create_profile.dart';
import 'package:Problem/pages/dashboard/acount/auth/edit_profile_screen.dart';
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

  bool isLoading = false;
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
    int user_id = await getUserId();

    setState(() {
      isLoading = true;
    });
    var response = await postService(URL_GET_PROFILE, {"user_id": user_id});

    setState(() {
      isLoading = false;
    });
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
    return ScreenFrame(
        titleBar: ScreenActionBar(
          title: 'Account',
          child: (_accountDetails != null) ? InkWell(
              onTap: () {
                openEditingProfileScreen(_accountDetails);
              },
              child: Icon(
                Icons.edit,
                size: getTextTheme().titleMedium?.fontSize,
                color: COLOR_PRIMARY,
              )) : Container(),
        ),
        body: isLoading
            ? Container(
                padding: SCREEN_PADDING,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator()),
                  ],
                ),
              )
            : (_accountDetails != null)
                ? Container(
                    padding: SCREEN_PADDING,
                    child: Column(
                      children: [
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
                                  style: getTextTheme(color: COLOR_GREY)
                                      .titleSmall,
                                ),
                                addVerticalSpace(8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_circle_outlined,
                                      color: COLOR_PRIMARY,
                                    ),
                                    addHorizontalSpace(4),
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
                        addVerticalSpace(32),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Expanded(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          ),
                        )
                      ],
                    ))
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please create your profile',
                              style: getTextTheme().headlineMedium,
                            ),
                          ],
                        ),
                        addVerticalSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  moveToAccountForm();
                                },
                                child: Text('Update'))
                          ],
                        ),
                      ],
                    ),
                  ));
  }

  void moveToAccountForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => CreateProfile()));
  }
  
  void openEditingProfileScreen(accountDetails) {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => EditProfileScreen(accountDetails: accountDetails,)));
  }
}

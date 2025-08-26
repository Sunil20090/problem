import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/components/rounded_rect_image.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/common_pages/image_view_screen.dart';
import 'package:Problem/pages/dashboard/acount/auth/create_profile.dart';
import 'package:Problem/pages/dashboard/acount/auth/edit_profile_screen.dart';
import 'package:Problem/pages/dashboard/acount/auth/login_page.dart';
import 'package:Problem/pages/dashboard/problem/edit_problem_screen.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  int user_id;

  final VoidCallback onChanged;
  AccountScreen({super.key, this.user_id = 0, required this.onChanged});

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

  var _posts = [];

  bool _isSelfId = false;

  @override
  void initState() {
    super.initState();

    initAccountDetails();

    initSkills();

    initHistory();

    insertScreen(USER_ID, "account", _isSelfId ? 1 : 0);
  }

  initAccountDetails() async {
    if (widget.user_id == 0) {
      widget.user_id = USER_ID;
    }

    _isSelfId = USER_ID == widget.user_id;

    setState(() {
      isLoading = true;
    });
    var response =
        await postService(URL_GET_PROFILE, {"user_id": widget.user_id});

    setState(() {
      isLoading = false;
    });
    if (response.isSuccess) {
      setState(() {
        _accountDetails = response.body['profile'];
        _posts = response.body['posts'];
      });
    }
  }

  initSkills() {}

  initHistory() async {}

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
        titleBar: ScreenActionBar(
          title: 'Account',
          child: (_accountDetails != null)
              ? InkWell(
                  onTap: _isSelfId
                      ? () {
                          openEditingProfileScreen(_accountDetails);
                        }
                      : null,
                  child: Row(
                    children: [
                      if (_isSelfId)
                        Icon(
                          Icons.edit,
                          size: getTextTheme().headlineMedium?.fontSize,
                          color: COLOR_PRIMARY,
                        ),
                      addHorizontalSpace()
                    ],
                  ))
              : Container(),
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
                              tag: _accountDetails['name'],
                              onClicked: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ImageViewScreen(
                                            tag: _accountDetails['name'],
                                            title: _accountDetails['name'],
                                            imageProvider: NetworkImage(
                                              _accountDetails['image_url'],
                                            ))));
                              },
                              width: 140,
                              height: 140,
                              radius: 70,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      Icons.error_outline,
                                      color: COLOR_PRIMARY,
                                    ),
                                    Text(
                                      formatNumber(_accountDetails[
                                          'problem_posted_count']),
                                      style: getTextTheme(color: COLOR_BLACK)
                                          .titleSmall,
                                    ),
                                    addHorizontalSpace(16),
                                    Icon(
                                      Icons.account_tree,
                                      color: COLOR_PRIMARY,
                                    ),
                                    Text(
                                      formatNumber(_accountDetails[
                                          'tracking_count']),
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
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              addVerticalSpace(),
                              
                              
                              Text(
                                'My Problems:',
                                style: getTextTheme().titleSmall,
                              ),
                              addVerticalSpace(4),
                              
                              Column(
                                  children: _posts.map((post) {
                                return InkWell(
                                  onTap: () {
                                    openProblemEditing(post['id']);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        RoundedRectImage(
                                          image_url: post['image_url'],
                                          thumbnail_url: post['thumbnail_url'],
                                        ),
                                        addHorizontalSpace(8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post['title'],
                                                style:
                                                    getTextTheme().titleSmall,
                                              ),
                                              Text(
                                                post['description'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()),

                              addVerticalSpace(),
                              InkWell(
                                onTap: () {
                                  logoutUser();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  color: COLOR_BASE,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Logout',
                                        style: getTextTheme(color: COLOR_RED)
                                            .titleMedium,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
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
                              'No Profile',
                              style: getTextTheme().headlineMedium,
                            ),
                          ],
                        ),
                        addVerticalSpace(),
                        Icon(
                          Icons.no_accounts,
                          size: 54,
                          color: COLOR_PRIMARY,
                        ),
                        addVerticalSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  moveToAccountForm();
                                },
                                child: Text('Create Profile'))
                          ],
                        ),
                        addVerticalSpace(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  moveToLoginPage();
                                },
                                child: Text('Login'))
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
        context,
        MaterialPageRoute(
            builder: (builder) => EditProfileScreen(
                  onChange: widget.onChanged,
                  accountDetails: accountDetails,
                )));
  }

  void moveToLoginPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => LoginPage()));
  }

  void logoutUser() async {
    await deleteUser();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => LoginPage()));
  }

  void openImageView(provider, post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => ImageViewScreen(
                tag: post['image_url'],
                title: post['title'],
                imageProvider: provider)));
  }

  void openProblemEditing(int problem_id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => EditProblemScreen(problem_id:  problem_id)));
  }
}

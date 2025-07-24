import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>  with WidgetsBindingObserver{
  var _accountDetails;
  var _skills = [];
  var _achievements = [];


  @override
  void initState() {
    super.initState();
    initAccountDetails();
    // initSkills();
    // _accountDetails = ACCOUNT_DETAILS;
    print('skills');
    
  }

  initAccountDetails() async {
    postService(URL_GET_PROFILE, {"user_id": USER_ID}).then((response) {
      print(response.body);
      if (response.isSuccess && response.body['description'] != null) {
        setState(() {
          ACCOUNT_DETAILS = response.body;

          USER_AVATAR_URL = response.body['thumbnail'];

          _accountDetails = response.body;
          // USER_AVATAR_URL = response.body['avatar'];
        });
      }
    });
  }


  // initSkills() {
  //   _skills = DATA_ACCOUNT_DETAILS;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: SCREEN_PADDING,
            child: _accountDetails != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScreenActionBar(title: 'Profile'),
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
                                  image: NetworkImage(
                                      _accountDetails['thumbnail']),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            addHorizontalSpace(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _accountDetails['username'],
                                    style: CUSTOM_TEXT_THEME.headlineSmall,
                                  ),
                                  addVerticalSpace(2),
                                  Text(
                                    softWrap: true,
                                    maxLines: 5,
                                    _accountDetails['description'],
                                    style: CUSTOM_TEXT_THEME.bodySmall,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(30),
                        Text(
                          'Skills:',
                          style: CUSTOM_TEXT_THEME.bodySmall,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _skills
                                .map((element) => Container(
                                      margin: EdgeInsets.all(1),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      color: COLOR_BASE_DARKER,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            element['skill'],
                                            style: CUSTOM_TEXT_THEME.titleSmall,
                                          ),
                                          SizedBox(
                                            height: 10,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  color: COLOR_WHITE,
                                                ),
                                                Container(
                                                  width: (element[
                                                              'competency_level']
                                                          as double) *
                                                      100,
                                                  color: COLOR_PRIMARY,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        addVerticalSpace(),
                        Text('Achievements:'),
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: _achievements.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: Image.network(
                                              _achievements[index]['image_url'],
                                              fit: BoxFit.contain,
                                            )),
                                      ),
                                    ),
                                    Text(
                                      _achievements[index]['title'],
                                      style: CUSTOM_TEXT_THEME.headlineSmall,
                                    ),
                                  ],
                                ),
                              );
                            },
                            controller: PageController(viewportFraction: 0.85),
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      ],
                    ),
                  )
                : Text('No profile found')));
  }

  
}

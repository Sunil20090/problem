import 'package:election/components/image_with_title.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/storage_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/pages/dashboard/acount/profile_screen.dart';
import 'package:election/pages/dashboard/problem/post_problem_screen.dart';
import 'package:election/pages/dashboard/problem/problem_detail_screen.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:election/utils/storage_service.dart';
import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  const ProblemScreen({super.key});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  List<dynamic> _problemList = [];

  @override
  void initState() {
    super.initState();

    getList();
  }

  getList() async {
    await initUser();


    ApiResponse response = await getService(URL_PROBLEM_LIST);

    if (response.isSuccess) {
      setState(() {
        _problemList = response.body;
      });
    }
  }

  
    // _accountDetails = DATA_ACCOUNT_DETAILS;
    // _skills = _accountDetails['skills'];
    // _achievements = _accountDetails['achievements'];
  

  initUser() async {
    // await deleteJson(STORAGE_KEY_USER);
    var obj = await loadJson(STORAGE_KEY_USER);

    print('localstorage $obj');

    if (obj == null) {
      ApiResponse response = await getService(URL_GUEST_USER);
      if (response.isSuccess) {
        print(response.body);
        await saveJson(STORAGE_KEY_USER, {
          'username': response.body['username'],
          'user_id': response.body['user_id'],
          'type': response.body['type']
        });

        USER_ID = response.body['user_id'];
        USER_NAME = response.body['username'];
        USER_TYPE = response.body['type'];

        print(USER_NAME);
      }
    } else {
      USER_ID = obj['user_id'];
      USER_NAME = obj['username'];
      USER_TYPE = obj['type'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: SCREEN_PADDING,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ScreenActionBar(title: 'Problems'),
                    Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: CUSTOM_TEXT_THEME.headlineLarge?.fontSize,
                          color: COLOR_PRIMARY,
                        ),
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.notifications_outlined,
                                size: CUSTOM_TEXT_THEME.headlineLarge?.fontSize,
                                color: COLOR_PRIMARY,
                              ),
                            ),
                            Positioned(
                              top: -1,
                              right: -1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Center(
                                  child: Container(
                                    color: Colors.red,
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '67',
                                      style: TextStyle(
                                          fontSize: 8, color: COLOR_BASE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        addHorizontalSpace(6),
                        InkWell(
                          onTap: () {
                            getList();
                          },
                          child: Icon(
                            Icons.mail_outline,
                            size: CUSTOM_TEXT_THEME.headlineLarge?.fontSize,
                            color: COLOR_PRIMARY,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _problemList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ImageWithTitle(
                          onImagePressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ProblemDetailScreen(
                                          problem: _problemList[index],
                                        )));
                          },
                          container: Hero(
                            tag:
                                'problem-title-image${_problemList[index]['id']}',
                            child: FadeInImage(
                              image: Image.network(
                                _problemList[index]['image_url'],
                              ).image,
                              placeholder: Image.network(
                                _problemList[index]['thumbnail_url'],
                              ).image,
                              fadeInDuration: Duration(milliseconds: 20),
                              fit: BoxFit.contain,
                            ),
                          ),
                          avatarUrl: _problemList[index]
                              ['user_avatar_thumbnail'],
                          title: _problemList[index]['title'],
                          description: _problemList[index]['description'],
                          onInfoPressed: () => showAlert(
                              context, "Info", _problemList[index].toString()),
                          onAvatarPressed: () => showProfile(),
                        ),
                        addVerticalSpace(60)
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: COLOR_PRIMARY,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => PostProblemScreen()));
          },
          child: Icon(
            Icons.add,
            color: COLOR_BASE,
          ),
        ),
      ),
    );
  }

  showProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => ProfileScreen()));
  }
}

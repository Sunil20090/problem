import 'package:Problem/components/image_with_title.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/profile_screen.dart';
import 'package:Problem/pages/dashboard/Problem/post_problem_screen.dart';
import 'package:Problem/pages/dashboard/Problem/problem_detail_screen.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  const ProblemScreen({super.key});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  List<dynamic> _problemList = [];
  var _notificationCount = 0;

  @override
  void initState() {
    super.initState();

    getList();

    getNotificationCount();
  }

  getNotificationCount() async {
    ApiResponse response =
        await postService(URL_NOTIFICATION_COUNT, {"user_id": USER_ID});

    if (response.isSuccess) {
      setState(() {
        _notificationCount = response.body;
      });
    }
  }

  getList() async {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ScreenActionBar(
                title: 'Problem',
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: getTextTheme().headlineLarge?.fontSize,
                      color: COLOR_PRIMARY,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.notifications_outlined,
                            size: getTextTheme().headlineLarge?.fontSize,
                            color: COLOR_PRIMARY,
                          ),
                        ),
                        Positioned(
                          top: -1,
                          right: -1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: (_notificationCount != 0) ? Container(
                              height: 22,
                              width: 22,
                              alignment: Alignment.center,
                              color: Colors.red,
                              child: Text(
                                '$_notificationCount',
                                style: TextStyle(color: COLOR_BASE),
                              ),
                            ) : Container(),
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
                        size: getTextTheme().headlineLarge?.fontSize,
                        color: COLOR_PRIMARY,
                      ),
                    ),
                  ],
                ),
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
                              fit: BoxFit.cover,
                            ),
                          ),
                          avatarUrl: _problemList[index]['user_url'],
                          avatarThumnailUrl: _problemList[index]
                              ['user_thumbnail_url'],
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

import 'package:Problem/components/image_with_title.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/profile_screen.dart';
import 'package:Problem/pages/dashboard/Problem/post_problem_screen.dart';
import 'package:Problem/pages/dashboard/Problem/problem_detail_screen.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:Problem/utils/storage_service.dart';
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
    var userId = await getUserId();
    ApiResponse response = await postService(URL_NOTIFICATION_COUNT, {"user_id" : userId});

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
                            child: (_notificationCount != 0 || true)
                                ? Container(
                                    height: 22,
                                    width: 22,
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: Text(
                                      '${formatNumber(_notificationCount)}',
                                      style: TextStyle(color: COLOR_BASE),
                                    ),
                                  )
                                : Container(),
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
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                FadeInImage(
                                  image: Image.network(
                                    _problemList[index]['image_url'],
                                  ).image,
                                  placeholder: Image.network(
                                    _problemList[index]['thumbnail_url'],
                                  ).image,
                                  fadeInDuration: Duration(milliseconds: 20),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      padding: CONTENT_PADDING,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              UI_BORDER_RADIUS),
                                          color: COLOR_GREY),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: COLOR_RED,
                                            size: getTextTheme()
                                                .titleSmall
                                                ?.fontSize,
                                          ),
                                          addHorizontalSpace(2),
                                          Text(
                                            "${formatNumber(0)}",
                                            style:
                                                getTextTheme(color: COLOR_WHITE)
                                                    .titleSmall,
                                          ),
                                          addHorizontalSpace(),
                                          Icon(
                                            Icons.comment,
                                            color: COLOR_WHITE,
                                            size: getTextTheme()
                                                .titleSmall
                                                ?.fontSize,
                                          ),
                                          addHorizontalSpace(2),
                                          Text(
                                            "${formatNumber(_problemList[index]['solution_count'])}",
                                            style:
                                                getTextTheme(color: COLOR_WHITE)
                                                    .titleSmall,
                                          )
                                        ],
                                      ),
                                    )),
                              ],
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
                        addVerticalSpace(10)
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

import 'package:Problem/components/image_with_title.dart';
import 'package:Problem/components/progress_circular.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/common_pages/notification/notification_screen.dart';
import 'package:Problem/pages/dashboard/Problem/post_problem_screen.dart';
import 'package:Problem/pages/dashboard/Problem/problem_detail_screen.dart';
import 'package:Problem/pages/dashboard/acount/other_account_screen.dart';
import 'package:Problem/pages/search_screen.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  ProblemScreen({super.key});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  List<dynamic> _problemList = [];
  var _notificationCount = 0;
  bool _fetchingList = false;

  String? _result;

  int _offset = 0;

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getList();

    getNotificationCount();

    insertScreen(USER_ID, "problem_list", 0);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_fetchingList) {
        getList();
        print('end of the list');
      }
    });
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
    var body = {"user_id": USER_ID, "search_by": _result, "offset": _offset};
    setState(() {
      _fetchingList = true;
    });
    ApiResponse response = await postService(URL_PROBLEM_LIST, body);

    setState(() {
      _fetchingList = false;
    });

    if (response.isSuccess) {
      setState(() {
        _problemList.addAll(response.body);
        if (response.body.length > 0) {
          _offset += 1;
        }
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
              if (_result == null)
                ScreenActionBar(
                  title: 'Problem',
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          openSearchScreen();
                        },
                        child: Icon(
                          Icons.search,
                          size: getTextTheme().headlineLarge?.fontSize,
                          color: COLOR_PRIMARY,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          openNotificationScreen();
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              size: getTextTheme().headlineLarge?.fontSize,
                              color: COLOR_PRIMARY,
                            ),
                            Positioned(
                              top: -1,
                              right: -1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: (_notificationCount != 0)
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
                                    : null,
                              ),
                            ),
                          ],
                        ),
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
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        _result!,
                        style: getTextTheme().titleSmall,
                      ),
                      addHorizontalSpace(),
                      InkWell(
                          onTap: () {
                            setState(() {
                              _result = null;
                              _problemList = [];
                              getList();
                            });
                          },
                          child: Icon(
                            Icons.close,
                            size: getTextTheme().titleMedium?.fontSize,
                          )),
                      addHorizontalSpace()
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _problemList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ImageWithTitle(
                          onImagePressed: () async {
                           await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProblemDetailScreen(
                                          problem: _problemList[index],
                                        )));
                                        setState(() {
                                          
                                        });
                          },
                          container: Stack(
                            fit: StackFit.expand,
                            children: [
                              FadeInImage(
                                image: Image.network(
                                  _problemList[index]['image_url'],
                                ).image,
                                placeholder: Image.network(
                                  _problemList[index]['thumbnail_url'],
                                ).image,
                                fadeInDuration: Duration(milliseconds: 2),
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
                                          "${formatNumber(_problemList[index]['like_count'])}",
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
                                        ),
                                        addHorizontalSpace(),
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: COLOR_WHITE,
                                          size: getTextTheme()
                                              .titleSmall
                                              ?.fontSize,
                                        ),
                                        addHorizontalSpace(2),
                                        Text(
                                          "${formatNumber(_problemList[index]['views'])}",
                                          style:
                                              getTextTheme(color: COLOR_WHITE)
                                                  .titleSmall,
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          timeStamp:
                              '@${timeAgo(_problemList[index]['created_on'], timezoneOffset: Duration(hours: 5, minutes: 30))}',
                          avatarUrl: _problemList[index]['user_thumbnail_url'],
                          avatarThumbnailUrl: _problemList[index]
                              ['user_thumbnail_url'],
                          title: _problemList[index]['title'],
                          description: _problemList[index]['description'],
                          onInfoPressed: () => showAlert(
                              context, "Info", _problemList[index].toString()),
                          onAvatarPressed: () =>
                              showProfile(_problemList[index]['posted_by']),
                        ),
                        addVerticalSpace(10)
                      ],
                    );
                  },
                ),
              ),
              if (_fetchingList)
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressCircular(
                        color: COLOR_BLACK,
                      ),
                    ],
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

  showProfile(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => OtherAccountScreen(
                  profile_id: id,
                )));
  }

  void openNotificationScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => NotificationScreen()));
  }

  void openSearchScreen() async {
    _result = await Navigator.push(
        context, MaterialPageRoute(builder: (builder) => SearchScreen()));

    print('got the result $_result');
    if (_result != null) {
      _result = _result!.toLowerCase();
      _problemList = [];
      _offset = 0;
      getList();
    }
  }
}

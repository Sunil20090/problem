import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/auth/create_profile.dart';
import 'package:Problem/pages/dashboard/idea_screen.dart';
import 'package:Problem/pages/dashboard/plan_screen.dart';
import 'package:Problem/pages/dashboard/Problem/problem_screen.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/storage_service.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();

    initUser();
  }

  initUser() async {
    // await deleteJson(STORAGE_KEY_USER);
    var obj = await loadJson(STORAGE_KEY_USER);

    // print('localstorage $obj');

    if (obj == null) {
      ApiResponse response = await getService(URL_GUEST_USER);
      print(response.body);
      if (response.isSuccess) {
        await saveJson(STORAGE_KEY_USER, {
          'username': response.body['username'],
          'user_id': response.body['user_id'],
          'type': response.body['type'],
          'is_signed_in': response.body['is_signed_in']
        });
        obj = response.body;
      }
    }

    USER_ID = obj['user_id'];
    USER_NAME = obj['username'];
    USER_TYPE = obj['type'];
    USER_SIGNED_IN = obj['is_signed_in'];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      ProblemScreen(),
      IdeaScreen(),
      PlanScreen(),
      CreateProfile(
        profile: {"id": USER_ID},
      )
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('User: ${USER_ID}, USER TYPE $USER_TYPE'),
        ),
        body: IndexedStack(index: _pageIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: COLOR_PRIMARY,
          unselectedItemColor: COLOR_BASE_DARKER,
          currentIndex: _pageIndex,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                label: 'Problems', icon: Icon(Icons.work_outline_rounded)),
            BottomNavigationBarItem(label: 'Ideas', icon: Icon(Icons.light)),
            BottomNavigationBarItem(
                label: 'Plans', icon: Icon(Icons.meeting_room)),
            BottomNavigationBarItem(
                label: 'Me',
                icon: ProfileThumbnail(
                  imageUrl: USER_AVATAR_URL,
                  width: 42,
                  height: 42,
                )),
          ],
        ),
      ),
    );
  }
}

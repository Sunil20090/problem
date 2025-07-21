import 'package:election/constants/storage_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/pages/dashboard/acount/account_screen.dart';
import 'package:election/pages/dashboard/idea_screen.dart';
import 'package:election/pages/dashboard/plan_screen.dart';
import 'package:election/pages/dashboard/problem/problem_screen.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/storage_service.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int _pageIndex = 0;

  final List<Widget> _pages = [ProblemScreen(), IdeaScreen(), PlanScreen(), AccountScreen()];

  @override
  void initState() {
    super.initState();

    initUser();

  }


  initUser() async {
    // await deleteJson(STORAGE_KEY_USER);
    var obj = await loadJson(STORAGE_KEY_USER);

    print('localstorage $obj');

    if(obj == null){
      ApiResponse response = await getService(URL_GUEST_USER);

      if(response.isSuccess){
        saveJson(STORAGE_KEY_USER, 
          {
            'username': response.body['username'],
            'user_id' : response.body['user_id'],
            'type' : response.body['type']
          }           
        );
      } 
    }else {
      USER_ID = obj['user_id'];
      USER_NAME = obj['username'];
      USER_TYPE = obj['type'];
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _pageIndex,
          children: _pages
          ),
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
              label: 'Problems',
              icon: Icon(Icons.work_outline_rounded)
            ),
            BottomNavigationBarItem(
               label: 'Ideas',
              icon: Icon(Icons.light)
            ),
            BottomNavigationBarItem(
               label: 'Plans',
              icon: Icon(Icons.meeting_room)
            ),
            BottomNavigationBarItem(
               label: 'Me',
              icon: Icon(Icons.person)
            ),
          ],
        ),
      ),
    );
  }
}
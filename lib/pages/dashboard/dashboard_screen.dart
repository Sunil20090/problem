import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/pages/dashboard/acount/account_screen.dart';
import 'package:Problem/pages/dashboard/idea_screen.dart';
import 'package:Problem/pages/dashboard/plan_screen.dart';
import 'package:Problem/pages/dashboard/Problem/problem_screen.dart';

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _pageIndex = 0;
  
  final List<Widget> _pages = [
    ProblemScreen(),
    IdeaScreen(),
    PlanScreen(),
    AccountScreen(
      
    )
  ];

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: _pages[_pageIndex],
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
                  width: 32,
                  height: 32,
                )),
          ],
        ),
      ),
    );
  }
}

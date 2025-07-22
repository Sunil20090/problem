import 'package:election/components/profile_thumbnail.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/pages/dashboard/acount/account_screen.dart';
import 'package:election/pages/dashboard/idea_screen.dart';
import 'package:election/pages/dashboard/plan_screen.dart';
import 'package:election/pages/dashboard/problem/problem_screen.dart';
import 'package:election/user/user_data.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [ProblemScreen(), IdeaScreen(), PlanScreen(), AccountScreen()];
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
              icon: InkWell(
                onTap: (){
                  setState(() {
                    _pageIndex = 3;
                    
                  });
                },
                child: ProfileThumbnail(
                  imageUrl: USER_AVATAR_URL,
                  width: 45, height: 45,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
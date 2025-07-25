import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? profile_user_id;
  ProfileScreen({super.key, this.profile_user_id});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: SCREEN_PADDING,
          child: Column(
            children: [
              ScreenActionBar(title: 'Profile')
            ],
          ),
        ),
      ),
    );
  }
}
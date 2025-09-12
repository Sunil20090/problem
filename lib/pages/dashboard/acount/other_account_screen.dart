import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:flutter/material.dart';

class OtherAccountScreen extends StatefulWidget {
  final int profile_id;
  const OtherAccountScreen({super.key, required this.profile_id});

  @override
  State<OtherAccountScreen> createState() => _OtherAccountScreenState();
}

class _OtherAccountScreenState extends State<OtherAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenFrame(titleBar: ScreenActionBar(title: 'Account',));
  }
}
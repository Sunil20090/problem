import 'package:Problem/components/notification_item.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> _notificationList = [];

  @override
  void initState() {
    super.initState();
    initNotificaitonList();
    insertScreen(USER_ID, 'notification', 0);
  }

  initNotificaitonList() async {
    var body = {"user_id": USER_ID};

    ApiResponse response = await postService(URL_USER_NOTIFICATION_LIST, body);

    if (response.isSuccess) {
      setState(() {
        _notificationList = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: SCREEN_PADDING,
        child: Column(
          children: [
            ScreenActionBar(
              title: 'Notificaton',
              backButtonEnabled: true,
            ),
            addVerticalSpace(),
            Expanded(
              child: ListView.builder(
                itemCount: _notificationList.length,
                itemBuilder: (context, index) {
                  return NotificationItem(
                      notification: _notificationList[index]);
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}

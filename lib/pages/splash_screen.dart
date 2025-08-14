import 'package:Problem/constants/image_constant.dart';
import 'package:Problem/constants/storage_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/dashboard_screen.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/storage_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initUser().then((value) {
      print('user id available $value');
      moveToDashBoard();
    });
  }

  initUser() async {
    var obj = await loadJson(STORAGE_KEY_USER);

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
    return USER_ID;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,height: 50,
            child: Image.asset(IMAGE_PALM_TREE)),
        ],
      )],
    ));
  }

  moveToDashBoard() {
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => DashboardScreen()));
  }
}

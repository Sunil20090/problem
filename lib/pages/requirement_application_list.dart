import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/components/progress_circular.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/acount/account_screen.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class RequirementApplicationList extends StatefulWidget {
  final int requirement_id;
  final String skill_name;
  RequirementApplicationList(
      {super.key, required this.requirement_id, required this.skill_name});

  @override
  State<RequirementApplicationList> createState() =>
      _RequirementApplicationListState();
}

class _RequirementApplicationListState
    extends State<RequirementApplicationList> {
  bool _fetchingUsers = false;

  List<dynamic> _appliedUsers = [];
  @override
  void initState() {
    super.initState();

    initUserList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
        title: 'Applicatons',
        backButtonEnabled: true,
      ),
      body: (!_fetchingUsers)
          ? Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'For: ${widget.skill_name}',
                      style: getTextTheme(color: COLOR_PRIMARY).titleMedium,
                    ),
                    ..._appliedUsers.map((user) {
                      return ListTile(
                          onTap: () {
                            openAccountScreen(user['user_id']);
                          },
                          title: Row(
                            children: [
                              ProfileThumbnail(
                                thumnail_url: user['thumbnail'],
                              ),
                              addHorizontalSpace(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${user['username']}'),
                                  Text('${user['remark']}')
                                ],
                              )
                            ],
                          ));
                    }).toList(),
                  ]),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressCircular(
                  color: COLOR_BLACK,
                )
              ],
            ),
    );
  }

  void initUserList() async {
    var body = {"requirement_id": widget.requirement_id};

    setState(() {
      _fetchingUsers = true;
    });

    ApiResponse response =
        await postService(URL_APPLED_USERS_FOR_REQUIREMENT, body);

    setState(() {
      _fetchingUsers = false;
    });

    if (response.isSuccess) {
      setState(() {
        _appliedUsers = response.body;
      });
    }
  }
  
  void openAccountScreen(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => AccountScreen(
                  user_id: id,
                  onChanged: () {
                    setState(() {});
                  },
                )));
  }
}

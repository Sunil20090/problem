import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/counter.dart';
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
  final dynamic requirement;
  RequirementApplicationList({super.key, required this.requirement});

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
                    Row(
                      children: [
                        Text(
                          'For: ${widget.requirement['skill']}',
                          style: getTextTheme(color: COLOR_PRIMARY).titleMedium,
                        ),
                        Spacer(),
                        Counter(
                          counter: widget.requirement['max_limit'],
                          onChange: (value) {
                            setState(() {
                              widget.requirement['max_limit'] = value;
                              updateCounter(value);
                            });
                          },
                        ),
                        addHorizontalSpace(),
                      ],
                    ),
                    addVerticalSpace(DEFAULT_LARGE_SPACE),
                    ..._appliedUsers.map((user) {
                      return ListTile(
                          onTap: () {
                            openAccountScreen(user['user_id']);
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ProfileThumbnail(
                                    thumnail_url: user['thumbnail'],
                                  ),
                                  addHorizontalSpace(),
                                  Text(
                                    '${user['username']}',
                                    softWrap: true,
                                    style: getTextTheme(color: COLOR_PRIMARY)
                                        .titleSmall,
                                  ),
                                  Spacer(),
                                  ColoredButton(
                                      onPressed: user['isApproved'] == 0
                                          ? () {
                                              approveUserForJob(user);
                                            }
                                          : null,
                                      backgroundColor: user['isApproved'] == 0
                                          ? COLOR_BASE_SUCCESS
                                          : COLOR_GREY,
                                      child: user['isApproved'] == 0
                                          ? Text(
                                              'Approve',
                                              style: getTextTheme(
                                                      color: COLOR_BASE)
                                                  .titleSmall,
                                            )
                                          : Text(
                                              'Approved',
                                              style: getTextTheme(
                                                      color: COLOR_BASE)
                                                  .titleSmall,
                                            ))
                                ],
                              ),
                              addVerticalSpace(),
                              Text(
                                '${user['remark']}',
                                softWrap: true,
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
    var body = {"requirement_id": widget.requirement['id']};

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

  void updateCounter(int value) async {
    var body = {"requirement_id": widget.requirement['id'], "limit": value};

    ApiResponse response = await postService(URL_SET_REQUIREMENT_LIMIT, body);
  }

  approveUserForJob(dynamic user) async {
    var body = {
      "user_id": user['user_id'],
      "requirement_id": widget.requirement['id'],
      "problem_id": widget.requirement['problem_id']
    };

    ApiResponse response = await postService(URL_APPROVE_FOR_REQUIREMENT, body);

    if (response.isSuccess) {
      setState(() {
        user['isApproved'] = 1;
      });
    }
  }
}

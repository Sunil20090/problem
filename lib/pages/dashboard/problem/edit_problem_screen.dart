import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/progress_circular.dart';
import 'package:Problem/components/rounded_rect_image.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/dashboard/problem/add_requirement_screen.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class EditProblemScreen extends StatefulWidget {
  final int problem_id;
  const EditProblemScreen({super.key, required this.problem_id});

  @override
  State<EditProblemScreen> createState() => _EditProblemScreenState();
}

class _EditProblemScreenState extends State<EditProblemScreen> {
  dynamic _problem;

  List<dynamic> _skillRequirements = [];
  bool _deleteLoading = false;

  @override
  void initState() {
    super.initState();
    getProblem();
    initSkills();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
        title: 'Editing problem',
        backButtonEnabled: true,
      ),
      body: _problem != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _problem['title'],
                  style: getTextTheme().titleMedium,
                ),
                addVerticalSpace(),
                RoundedRectImage(
                    width: double.infinity,
                    height: 200,
                    image_url: _problem['image_url'],
                    thumbnail_url: _problem['thumbnail_url']),
                addVerticalSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Requirements:'),
                    ColoredButton(
                        onPressed: () {
                          setState(() {
                            openRequirementScreen();
                          });
                        },
                        child: Icon(
                          Icons.add,
                          color: COLOR_BASE,
                        ))
                  ],
                ),
                ..._skillRequirements.map((requirement) {
                  return ListTile(
                    onTap: () {
                      moveToApplicationList(requirement);
                    },
                    title: Row(
                      children: [
                        Icon(Icons.school),
                        addHorizontalSpace(),
                        Text(requirement['skill']),
                        addHorizontalSpace(),
                        Spacer(),
                        !_deleteLoading
                            ? (requirement['application_count'] == 0)
                                ? InkWell(
                                    onTap: () {
                                      deleteRequirement(
                                          requirement['id'], widget.problem_id);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: const Color.fromARGB(
                                          255, 235, 129, 121),
                                    ),
                                  )
                                : Container()
                            : ProgressCircular(),
                        Container(
                            padding: EdgeInsets.all(4),
                            color: COLOR_BASE_SUCCESS,
                            child: Text(
                              '${formatNumber(requirement['application_count'])}',
                              style: getTextTheme(color: COLOR_BASE).titleSmall,
                            )),
                        addHorizontalSpace()
                      ],
                    ),
                  );
                }).toList()
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressCircular(
                    color: COLOR_BLACK,
                  ),
                ),
              ],
            ),
    );
  }

  getProblem() async {
    var body = {"id": widget.problem_id};
    ApiResponse response = await postService(URL_GET_PROBLEM, body);

    if (response.isSuccess) {
      setState(() {
        _problem = response.body[0];
        print('getProblem screen $_problem');
      });
    }
  }

  openRequirementScreen() async {
    var skill_id = await Navigator.push(context,
        MaterialPageRoute(builder: (builder) => AddRequirementScreen()));

    if (skill_id != null) {
      setState(() {
        addRequirement(skill_id);
      });
    }
  }

  deleteRequirement(skill_id, problem_id) async {
    var body = {"skill_id": skill_id, "problem_id": problem_id};

    ApiResponse response =
        await postService(URL_REMOVE_SKILL_FROM_PROBLEM, body);

    if (response.isSuccess) {}
  }

  addRequirement(int skill_id) async {
    // initRequirements();

    var body = {"skill_id": skill_id, "problem_id": widget.problem_id};
    ApiResponse response = await postService(URL_ADD_SKILL_TO_PROBLEM, body);

    if (response.isSuccess) {
      if(response.body['status'] == 'OK'){
          initSkills();
      }else if(response.body['status'] == 'NOT OK'){
        showAlert(context, response.body['heading'], response.body['message']);
      }
    }
  }

  initSkills() async {
    var body = {"problem_id": widget.problem_id};
    ApiResponse response = await postService(URL_GET_SKILL_DETAILS, body);

    if (response.isSuccess) {
      setState(() {
        _skillRequirements = response.body;
      });
    }
  }

  void moveToApplicationList(skill) {
    print('working......................');
  }
}

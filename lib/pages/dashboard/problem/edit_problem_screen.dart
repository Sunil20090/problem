import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/components/progress_circular.dart';
import 'package:Problem/components/rounded_rect_image.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
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
  List<TextEditingController> _controllers = [];

  dynamic _problem;

  @override
  void initState() {
    super.initState();

    getProblem();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(title: 'Editing problem'),
      body: _problem != null
          ? Column(
              children: [
                Text(_problem['title']),
                addVerticalSpace(),
                RoundedRectImage(
                    width: double.infinity,
                    height: 200,
                    image_url: _problem['image_url'],
                    thumbnail_url: _problem['thumbnail_url']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Requirements:'),
                    ColoredButton(
                        onPressed: () {
                          setState(() {
                          _controllers.add(TextEditingController());
                          });
                        },
                        child: Icon(
                          Icons.add,
                          color: COLOR_BASE,
                        ))
                  ],
                ),
                ..._controllers.map(
                  (e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingLabelEditBox(labelText: 'Enter', controller: e,),
                    );
                  },
                ).toList(),
              ],
            )
          : ProgressCircular(),
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
}

import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/enter_text_box.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class PostIdeaScreen extends StatefulWidget {
  dynamic problem;
  PostIdeaScreen({super.key, required this.problem});

  @override
  State<PostIdeaScreen> createState() => _PostIdeaScreenState();
}

class _PostIdeaScreenState extends State<PostIdeaScreen> {
  final TextEditingController _solutionRemarkController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: SCREEN_PADDING,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problem: ${widget.problem['title']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                addVerticalSpace(),
                Text(
                  'Solution Remark',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                addVerticalSpace(),
                Text(
                  'Write your solution here',
                  style: TextStyle(fontSize: 16),
                ),
                addVerticalSpace(),
                EnterTextBox(
                  maxLines: 6,
                  hintText: 'Enter text',
                  controller: _solutionRemarkController,
                ),
                addVerticalSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ColoredButton(
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: COLOR_BASE,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}

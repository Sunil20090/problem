import 'package:election/api/data/sample_data.dart';
import 'package:election/components/colored_button.dart';
import 'package:election/components/comment_item.dart';
import 'package:election/components/enter_text_box.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class ProblemDetailScreen extends StatefulWidget {
  final dynamic problem;
  const ProblemDetailScreen({super.key, this.problem});

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  var _commentList = [];
  bool _showSolutionRemark = false;
  bool _isCommentSubmitting = false;
  var _requirement_list = [];

  final _controllerComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCommentList(widget.problem['id']);
    initRequirementList(widget.problem['id']);
    print('problemList :${widget.problem}');
  }

  initRequirementList(int id) {
    // _requirement_list = DATA_PROBLEM_REQUIREMENT;

  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              ScreenActionBar(
                title: widget.problem['title'],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                            height: UI_IMAGE_HEIGHT,
                            child: Hero(
                              tag: 'problem-title-image${widget.problem['id']}',
                              child: Text('${widget.problem['title']}',)
                              ),
                            )),
                      
                      Container(
                        padding: SCREEN_PADDING,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              softWrap: true,
                              'Details:',
                              style: CUSTOM_TEXT_THEME.titleSmall,
                            ),
                            Text(
                              softWrap: true,
                              widget.problem['description'],
                              style: CUSTOM_TEXT_THEME.bodySmall,
                            ),
                            addVerticalSpace(10),
                            if(_requirement_list.length > 0) Text(
                              'Requirements:',
                              style: CUSTOM_TEXT_THEME.titleSmall,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _requirement_list.map((skill) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(skill['name']),
                                        Spacer(),
                                        Container(
                                          margin: EdgeInsets.all(1),
                                          padding: EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.green),
                                          child: Text(
                                            skill['status'],
                                            style: TextStyle(color: COLOR_BASE),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                );
                              }).toList(),
                            ),
                            addHorizontalSpace(50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Solutions:',
                                  style: CUSTOM_TEXT_THEME.headlineMedium,
                                ),
                                ColoredButton(
                                  onPressed: () {
                                    setState(() {
                                      _showSolutionRemark =
                                          !_showSolutionRemark;
                                    });
                                  },
                                  child: _showSolutionRemark
                                      ? Icon(
                                          Icons.remove,
                                          color: COLOR_BASE,
                                          size: CUSTOM_TEXT_THEME
                                              .headlineMedium?.fontSize,
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              'Post Solution',
                                              style: TextStyle(
                                                  color: COLOR_BASE,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: COLOR_BASE,
                                              size: CUSTOM_TEXT_THEME
                                                  .headlineMedium?.fontSize,
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                            addVerticalSpace(),
                            if (_showSolutionRemark)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  EnterTextBox(
                                    controller: _controllerComment,
                                    hintText: 'write a comment...',
                                    maxLines: 2,
                                  ),
                                  addVerticalSpace(),
                                  ColoredButton(
                                    onPressed: () async {
                                      await submitComment();
                                    },
                                    child: !_isCommentSubmitting
                                        ? Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: COLOR_BASE,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : CircularProgressIndicator(
                                            color: COLOR_BASE),
                                  )
                                ],
                              ),
                            addVerticalSpace(20),
                            Column(
                              children: _commentList.map((comment) {
                                return Column(
                                  children: [
                                    CommentItem(comment: comment),
                                    addVerticalSpace(15),
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initCommentList(id) async {
    ApiResponse response =
        await getService(URL_GET_COMMENT_LIST + '?problem_id=${id}');

    if (response.isSuccess) {
      setState(() {
        _commentList = response.body;
      });
    }
  }

  submitComment() async {
    if (_controllerComment.text.isEmpty) {
      showAlert(context, 'Alert!', "Please enter a comment!  ");
      return;
    }

    setState(() {
      _isCommentSubmitting = true;
    });
    var body = {
      'user_name': USER_ID,
      'content': _controllerComment.text,
      'problem_id': widget.problem['id'],
      'user_url': USER_AVATAR_URL,
    };

    ApiResponse response = await postService(URL_POST_COMMENT, body);
    if (response.isSuccess) {
      print(response.body);
      setState(() {
        _controllerComment.text = "";
        _isCommentSubmitting = false;
        initCommentList(widget.problem['id']);
      });
    }
  }

  void applyOn(skill) {}
}

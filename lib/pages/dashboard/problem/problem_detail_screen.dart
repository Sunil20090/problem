import 'package:Problem/api/data/sample_data.dart';
import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/comment_item.dart';
import 'package:Problem/components/enter_text_box.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/components/scrollable_page_view.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/common_pages/image_view_screen.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
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

  List<dynamic> _images = [];

  final _controllerComment = TextEditingController();
  final _pageController = PageController(
    viewportFraction: 0.9,
  );

  @override
  void initState() {
    super.initState();
    _images.add(widget.problem);
    initCommentList(widget.problem['id']);
    initRequirementList(widget.problem['id']);
    initImageList(widget.problem['id']);
  }

  initRequirementList(int id) {
    _requirement_list = DATA_PROBLEM_REQUIREMENT;
  }

  initImageList(int id) async {
    var body = {"problem_id": id};
    ApiResponse response = await postService(URL_IMAGES_OF_PROBLEM, body);

    if (response.isSuccess) {
      setState(() {
        _images = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
              title: widget.problem['title'],
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: UI_IMAGE_HEIGHT,
            child: ScrollablePageView(
              images: _images,
            ),
          ),
          Container(
            padding: SCREEN_PADDING,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  softWrap: true,
                  'Details:',
                  style: getTextTheme().titleSmall,
                ),
                Text(
                  softWrap: true,
                  widget.problem['description'],
                  style: getTextTheme().bodySmall,
                ),
                addVerticalSpace(10),
                if (_requirement_list.length > 0)
                  Text(
                    'Requirements:',
                    style: getTextTheme().titleSmall,
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
                              // margin: EdgeInsets.all(1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(4),
                                  color: Colors.green),
                              child: Text(
                                skill['status'],
                                style:
                                    TextStyle(color: COLOR_BASE),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(4),
      
                        // Divider(),
                      ],
                    );
                  }).toList(),
                ),
                addVerticalSpace(30),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Solutions:',
                      style: getTextTheme().headlineMedium,
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
                              size: getTextTheme()
                                  .headlineMedium
                                  ?.fontSize,
                            )
                          : Row(
                              children: [
                                Text(
                                  'Post Solution',
                                  style: TextStyle(
                                      color: COLOR_BASE,
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: COLOR_BASE,
                                  size: getTextTheme()
                                      .headlineMedium
                                      ?.fontSize,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: COLOR_BASE),
                              ),
                      )
                    ],
                  ),
                addVerticalSpace(20),
                Column(
                  children: _commentList.map((comment) {
                    return Column(
                      children: [
                        CommentItem(
                          comment: comment,
                          onLikedClicked: () {
                            updateLike(comment);
                          },
                        ),
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
    );
  }

  void initCommentList(id) {
    postService(URL_GET_COMMENT_LIST, {"problem_id": id, "user_id": USER_ID})
        .then((response) {
      if (response.isSuccess) {
        setState(() {
          _commentList = response.body;
        });
      }
    });
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
      'user_id': USER_ID,
      'content': _controllerComment.text,
      'problem_id': widget.problem['id'],
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

  void updateLike(comment) {
    var body = {
      "comment_id": comment['id'],
      "liked_by": USER_ID,
      "problem_id": widget.problem['id']
    };

    postService(URL_LIKE_A_COMMENT, body).then((response) {
      if (response.isSuccess) {
        setState(() {
          initCommentList(widget.problem['id']);
        });
      }
    });

    // showAboutDialog(context: context);R
  }

  void openImageView(title, provider) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) =>
                ImageViewScreen(title: title, imageProvider: provider)));
  }
}

import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/comment_item.dart';
import 'package:Problem/components/enter_text_box.dart';
import 'package:Problem/components/progress_circular.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/components/scrollable_page_view.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/common_pages/image_view_screen.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class ProblemDetailScreen extends StatefulWidget {
  final dynamic problem;
  ProblemDetailScreen({
    super.key,
    this.problem,
  });

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  var _commentList = [];
  bool _isCommentSubmitting = false;
  var _requirement_list = [];

  List<dynamic> _images = [];

  final _controllerComment = TextEditingController();


  bool isTrackLoading = false;

  @override
  void initState() {
    super.initState();
    _images.add(widget.problem);
    initCommentList(widget.problem['id']);
    initRequirementList();
    initImageList(widget.problem['id']);
    insertScreen(USER_ID, "problem_detail", widget.problem['id']);
  }

  initRequirementList() async {
    // _requirement_list = DATA_PROBLEM_REQUIREMENT;
    var body = {"problem_id": widget.problem['id'], "user_id": USER_ID};
    ApiResponse response = await postService(URL_GET_SKILL_OF_PROBLEM, body);

    if (response.isSuccess) {
      setState(() {
        _requirement_list = response.body;
      });
    }
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
      titleBar: Container(),
      //  ScreenActionBar(
      //   backButtonEnabled: true,
      //   title: widget.problem['title'],
      //   child: (widget.problem['posted_by'] != USER_ID)
      //       ? Row(
      //           children: [
      //             ColoredButton(
      //                 onPressed: !isTrackLoading
      //                     ? () {
      //                         setState(() {
      //                           trackProblem();
      //                           // widget.problem['tracking'] = !widget.problem['tracking'];
      //                           print(widget.problem['tracking']);
      //                         });
      //                       }
      //                     : null,
      //                 backgroundColor: widget.problem['tracking'] == 1
      //                     ? COLOR_BLACK
      //                     : COLOR_PRIMARY,
      //                 child: !isTrackLoading
      //                     ? Text(
      //                         widget.problem['tracking'] == 1
      //                             ? 'Tracked'
      //                             : 'Track',
      //                         style:
      //                             getTextTheme(color: COLOR_BASE).titleMedium,
      //                       )
      //                     : ProgressCircular())
      //           ],
      //         )
      //       : null,
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: UI_IMAGE_HEIGHT,
            child: Stack(
              children: [
                ScrollablePageView(
                  images: _images,
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Row(
                      children: [
                        ColoredButton(
                            onPressed: !isTrackLoading
                                ? () {
                                    setState(() {
                                      trackProblem();
                                      // widget.problem['tracking'] = !widget.problem['tracking'];
                                      print(widget.problem['tracking']);
                                    });
                                  }
                                : null,
                            backgroundColor: widget.problem['tracking'] == 1
                                ? COLOR_BLACK
                                : COLOR_PRIMARY,
                            child: !isTrackLoading
                                ? Text(
                                    widget.problem['tracking'] == 1
                                        ? 'Tracked'
                                        : 'Track',
                                    style: getTextTheme(color: COLOR_BASE)
                                        .titleMedium,
                                  )
                                : ProgressCircular())
                      ],
                    )
                  )
              ],
            ),
          ),
          Container(
            padding: SCREEN_PADDING,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.problem['title'], style: getTextTheme().titleMedium,),
               

                Text(
                  softWrap: true,
                  widget.problem['description'],
                  style: getTextTheme().bodySmall,
                ),
                addVerticalSpace(DEFAULT_LARGE_SPACE),
                if (_requirement_list.length > 0)
                  Text(
                    'Requirements:',
                    style: getTextTheme().titleSmall,
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _requirement_list.map((requirement) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(requirement['name']),
                            Spacer(),
                            ColoredButton(
                                backgroundColor: requirement['isApplied'] == 0
                                ? COLOR_PRIMARY
                                : COLOR_BLACK,
                                onPressed: () {
                                  applyForRequirement(requirement);
                                },
                                child: requirement['isApplied'] == 0
                                    ? Text(
                                        'Apply',
                                        style: getTextTheme(color: COLOR_BASE)
                                            .titleSmall,
                                      )
                                    : Text(
                                        'Applied',
                                        style: getTextTheme(color: COLOR_BASE)
                                            .titleSmall,
                                      )),
                            addHorizontalSpace(),
                            Container(
                              // margin: EdgeInsets.all(1),
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.green),
                              child: Text(
                                requirement['status'],
                                style: TextStyle(color: COLOR_BASE),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Solutions:',
                      style: getTextTheme().headlineMedium,
                    ),
                    Spacer(),
                    ColoredButton(
                      onPressed: () async {
                        await submitComment();
                      },
                      child: !_isCommentSubmitting
                          ? Text(
                              'Post',
                              style: TextStyle(
                                  color: COLOR_BASE,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          : SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(color: COLOR_BASE),
                            ),
                    ),
                    addHorizontalSpace(),
                  ],
                ),
                addVerticalSpace(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    EnterTextBox(
                      controller: _controllerComment,
                      hintText: 'write a solution...',
                      maxLines: 2,
                    ),
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

  void trackProblem() async {
    var body = {"problem_id": widget.problem['id'], "user_id": USER_ID};

    setState(() {
      isTrackLoading = true;
    });

    ApiResponse response = await postService(URL_TRACK_PROBLEM, body);

    setState(() {
      isTrackLoading = false;
    });

    if (response.isSuccess) {
      if (response.body['status'] == "OK") {
        setState(() {
          widget.problem['tracking'] = response.body['tracking'];
        });
      }
    }
  }

  void applyForRequirement(requirement) async {
    var body = {"requirement_id": requirement['id'], "user_id": USER_ID};

    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressCircular(
                  color: COLOR_BLACK,
                ),
              ],
            ),
          );
        });

    ApiResponse response = await postService(URL_APPLY_FOR_REQUIREMENT, body);

    if (response.isSuccess) {
      Navigator.pop(context);
      initRequirementList();
    }
  }
}

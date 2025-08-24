import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostProblemScreen extends StatefulWidget {
  const PostProblemScreen({super.key});

  @override
  State<PostProblemScreen> createState() => _PostProblemScreenState();
}

class _PostProblemScreenState extends State<PostProblemScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  List<File?> _imageList = [null, null];
  final picker = ImagePicker();

  bool _loading = false;

  int _uploadCount = 0;
  int _uploadTotal = 1;

  int _IMAGE_LIMIT = 10;

  Future<void> _getImage(ImageSource source, int index) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageList[index] = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    insertScreen(USER_ID, "post_problem", 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: SCREEN_PADDING,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post problem',
                style: getTextTheme().headlineMedium,
              ),
              addVerticalSpace(30),
              FloatingLabelEditBox(
                labelText: 'Title',
                controller: _titleController,
              ),
              addVerticalSpace(32),
              FloatingLabelEditBox(
                labelText: 'Descriptions',
                maxLines: 4,
                controller: _descriptionController,
              ),
              addVerticalSpace(56),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attach images',
                    style: getTextTheme(color: COLOR_PRIMARY).titleMedium,
                  ),
                  ColoredButton(
                      onPressed: () {
                        setState(() {
                          if (_imageList.length < _IMAGE_LIMIT) {
                            _imageList.add(null);
                          } else {
                            showAlert(
                                context, 'Exceeded!', 'Image limit exceeded');
                          }
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: COLOR_BASE,
                      ))
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: _imageList.asMap().entries.map((entry) {
                      int index = entry.key;
                      return getCaptureImage(index);
                    }).toList(),
                  ),
                ),
              ),
              addVerticalSpace(20),
              ColoredButton(
                  onPressed: !_loading
                      ? () {
                          postData();
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Post',
                          style: getTextTheme(color: COLOR_BASE).titleMedium),
                    ],
                  ))
            ],
          ),
        ),
      ),
    ));
  }

  Widget getCaptureImage(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              print('Choose Image');
              _getImage(ImageSource.gallery, index);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 160,
                width: 160,
                color: COLOR_BASE_DARKER,
                child: _imageList[index] != null
                    ? Image.file(
                        _imageList[index]!,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.visible,
                            'Choose Image',
                            style: getTextTheme().bodySmall,
                          ),
                          Icon(
                            Icons.edit_rounded,
                            size: getTextTheme().bodyLarge?.fontSize,
                          )
                        ],
                      )),
              ),
            ),
          ),
        ),
        Positioned(
          top: -3,
          right: -3,
          child: InkWell(
            onTap: () {
              setState(() {
                if (_imageList.length > 1) {
                  _imageList.removeAt(index);
                }
              });
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close,
                  color: COLOR_WHITE,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.red),
            ),
          ),
        )
      ],
    );
  }

  bool error() {
    return (_titleController.text.isEmpty &&
            _descriptionController.text.isEmpty)
        // _imageList.any((el) => el != null
        ;
  }

  postData() async {
    if (error()) {
      showAlert(context, 'Error!', 'Complete the form to post the problem.',
          isError: true);
      return;
    }
    var image_base_64_list = [];
    for (var image_item in _imageList) {
      final Uint8List? imageBytes = await image_item?.readAsBytes();
      if (imageBytes != null) {
        image_base_64_list.add(base64Encode(imageBytes));
      }
    }

    var payload = {
      "title": _titleController.text,
      "description": _descriptionController.text,
      "image_base_64_list": image_base_64_list,
      "user_id": USER_ID,
    };

    print(payload);
    setState(() {
      _loading = true;
    });

    late StateSetter dialogSetState;

    // final ApiResponse response = await postService(URL_POST_PROBLEM, payload);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return StatefulBuilder(builder: (builder, setState) {
            dialogSetState = setState;
            return AlertDialog(
                title: Text('Uploading...'),
                content: Container(
                  height: 60,
                  child: Center(
                      child: _uploadCount / _uploadTotal < 0.98
                          ? Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 320,
                                    height: 20,
                                    color: COLOR_BASE,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: _uploadCount / _uploadTotal * 320,
                                    height: 20,
                                    color: COLOR_PRIMARY,
                                  ),
                                )
                              ],
                            )
                          : CircularProgressIndicator()),
                ));
          });
        });

    await postWithProgress(
        url: URL_POST_PROBLEM,
        body: payload,
        progressCallback: (count, total) {
          dialogSetState(() {
            _uploadTotal = total;
            _uploadCount = count;
            // print('PRogress: $uploadCount/$uploadTotal');
          });
        },
        onComplete: (reponse) {
          Navigator.pop(context);
          showAlert(
              context, 'Success!', 'Problem has been posted successfully.',
              isError: false, onDismiss: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
          emptyAllField();
        });

    setState(() {
      _loading = false;
    });
  }

  emptyAllField() {
    _titleController.clear();
    _descriptionController.clear();

    _imageList = [];
    setState(() {});
  }
}

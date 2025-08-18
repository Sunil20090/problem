import 'dart:convert';
import 'dart:io';

import 'package:Problem/components/colored_button.dart';
import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/pages/common_pages/image_view_screen.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  dynamic accountDetails;
  EditProfileScreen({super.key, required this.accountDetails});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;

  File? _localImageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.accountDetails['name'];
    _descriptionController.text = widget.accountDetails['description'];
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
        titleBar: ScreenActionBar(
          title: 'Edit Profile',
          child: Row(
            children: [
              !isLoading
                  ? ColoredButton(
                      radius: 18,
                      onPressed: () {
                        editProfile();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Update',
                              style:
                                  getTextTheme(color: COLOR_BASE).titleSmall),
                          Icon(
                            Icons.update,
                            color: COLOR_BASE,
                          ),
                        ],
                      ))
                  : ColoredButton(
                      child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: COLOR_BASE,
                          ))),
            ],
          ),
        ),
        body: Column(children: [
          addVerticalSpace(),
          Column(
            children: [
              Stack(
                children: [
                  ProfileThumbnail(
                    tag: widget.accountDetails['name'],
                    onClicked: widget.accountDetails['thumbnail_url'] != null ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ImageViewScreen(
                                tag: widget.accountDetails['name'],
                                  title: widget.accountDetails['name'],
                                  imageProvider: 
                                  widget.accountDetails['image_url'] != null 
                                  ? NetworkImage(widget.accountDetails['image_url'],) 
                                  : FileImage(_localImageFile!)
                                  )
                                  
                                  )
                                  );
                    } : null,
                    width: 160,
                    height: 160,
                    radius: 80,
                    file: _localImageFile,
                    thumnail_url: widget.accountDetails['thumbnail_url'],
                    imageUrl: widget.accountDetails['image_url'],
                  ),
                  Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () {
                          editImage();
                        },
                        child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(UI_BORDER_RADIUS),
                                color: COLOR_BASE),
                            child: Icon(
                              Icons.edit,
                              color: COLOR_PRIMARY,
                              size: getTextTheme().headlineLarge?.fontSize,
                            )),
                      ))
                ],
              ),
              addVerticalSpace(),
              Text(
                widget.accountDetails['username'],
                style: getTextTheme(color: COLOR_GREY).titleMedium,
              ),
              addVerticalSpace(30),
              FloatingLabelEditBox(
                labelText: 'Name',
                controller: _nameController,
              ),
              addVerticalSpace(),
              FloatingLabelEditBox(
                labelText: 'Description',
                maxLines: 4,
                controller: _descriptionController,
              ),
              addVerticalSpace(),
              addVerticalSpace(DEFAULT_LARGE_SPACE),
            ],
          ),
        ]));
  }

  void editProfile() async {
    if (_nameController.text.trim().length <= 2) {
      showAlert(context, 'Invailid!', "Enter a valid name");
      return;
    }

    if (_descriptionController.text.trim().length <= 0) {
      showAlert(context, 'Invailid!', "Enter the description");
      return;
    }

    String? base64;
    if (_localImageFile != null) {
      base64 = await fileToBase64(_localImageFile!);
    }

    var body = {
      "user_id": USER_ID,
      "base64": base64,
      "name": _nameController.text,
      "description": _descriptionController.text
    };

    setState(() {
      isLoading = true;
    });

    ApiResponse response = await postService(URL_EDIT_PROFILE, body);
    setState(() {
      isLoading = false;
    });
    if (response.isSuccess) {
      if (response.body['status'] == 'OK') {
        // showAlert(context, response.body['heading'], response.body['message']);
        setState(() {
          if (_localImageFile != null) {
            widget.accountDetails['thumbnail_url'] =
                response.body['thumbnail_url'];
            widget.accountDetails['image_url'] = response.body['image_url'];
          }
        });
      }
    }
  }

  void editImage() async {
    _localImageFile = await getLocalImage(ImageSource.gallery);

    if (_localImageFile != null) {
      setState(() {
        widget.accountDetails['thumbnail_url'] = null;
        widget.accountDetails['image_url'] = null;
      });
    }
  }
}

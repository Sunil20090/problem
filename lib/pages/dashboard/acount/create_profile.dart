import 'dart:io';
import 'package:election/components/colored_button.dart';
import 'package:election/components/floating_label_edit_box.dart';
import 'package:election/components/profile_thumbnail.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  dynamic profile;
  CreateProfile({super.key, this.profile});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File? _image;

  String? _image_url;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              ScreenActionBar(
                title: 'Create Profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: COLOR_PRIMARY,
                      size: UI_ICON_SIZE_MEDIUM,
                    ),
                  ],
                ),
              ),
              // addVerticalSpace(),
              Stack(
                children: [
                  ProfileThumbnail(
                      width: 300,
                      height: 300,
                      radius: 80,
                      file: _image,
                      imageUrl: _image_url),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () async {
                          getLocalImage(ImageSource.gallery).then((file) async {
                            if (USER_TYPE == 'GUEST') {
                              setState(() {
                                _image = file;
                              });
                            } else {
                              publishProfile(await fileToBase64(file!));
                            }
                          });
                        },
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: COLOR_BASE,
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              color: COLOR_PRIMARY,
                              size: UI_ICON_SIZE_MEDIUM,
                            )),
                      ))
                ],
              ),
              addVerticalSpace(),

              Container(
                padding: SCREEN_PADDING,
                child: Column(
                  children: [
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
                    FloatingLabelEditBox(
                      labelText: 'Email',
                      controller: _emailController,
                    ),
                    addVerticalSpace(),
                    FloatingLabelEditBox(
                      labelText: 'Password',
                      hideText: true,
                      controller: _emailController,
                    ),
                    addVerticalSpace(),
                    FloatingLabelEditBox(
                      labelText: 'Confirm Password',
                      controller: _emailController,
                    ),
                    addVerticalSpace(DEFAULT_LARGE_SPACE),
                    ColoredButton(
                        onPressed: () {
                          postToProfile();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Update',
                                style:
                                    getTextTheme(color: COLOR_BASE).titleLarge),
                          ],
                        )),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  formIsValid() {
    return !(_nameController.text.isEmpty &&
        _emailController.text.isEmpty &&
        _passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty &&
        _descriptionController.text.isEmpty);
  }

  publishProfile(String base64Data) {
    var body = {"user_id": USER_ID, "image_base_64": base64Data};

    postService(URL_CREATE_IMAGE_PROFILE, body).then((response) {
      if (response.isSuccess) {
        setState(() {
          _image_url = response.body['thumnail_url'];
        });
      }
    });
  }

  postToProfile() async {
    if (!formIsValid()) {
      showAlert(context, 'Alert!', "Complete the form", isError: true);
      return;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showAlert(context, 'Alert!', "Password do not matched!", isError: true);
      return;
    }

    var payload = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "mail_id": _emailController.text,
      "password": _passwordController.text,
      "image_base_64": _image == null ? null : await fileToBase64(_image!)
    };

    ApiResponse response = await postService(URL_CREATE_DATA_PROFILE, payload);

    if (response.isSuccess) {
      showAlert(context, 'Success!', response.body['message']);
      openOTPScreen();
    } else {
      showAlert(context, 'Failed!', "the response is failed!");
    }
  }

  openOTPScreen(){
    
  }
}

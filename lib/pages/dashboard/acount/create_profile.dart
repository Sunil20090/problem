import 'dart:io';

import 'package:election/components/floating_label_edit_box.dart';
import 'package:election/components/profile_thumbnail.dart';
import 'package:election/components/screen_action_bar.dart';
import 'package:election/constants/theme_constant.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: SCREEN_PADDING,
          child: Column(
            children: [
              ScreenActionBar(title: 'Create Profile'),
              addVerticalSpace(),

              Stack(
                children: [
                  ProfileThumbnail(
                    width: 300,
                    height: 300,
                    radius: 80,
                    imageUrl: (widget.profile != null && widget.profile['image'] != null) ? widget.profile['image'] : null,
                  ),

                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () async {
                        _image = await getLocalImage(ImageSource.gallery);
                        if(_image!= null)
                          print('Image: ${await fileToBase64(_image!)}');
                      },
                      child: Container(
                        width: 50,height: 50,
                        
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: COLOR_BASE,
                        ),
                        child: Icon(Icons.edit_outlined, color: COLOR_PRIMARY, size: 32,)),
                    )
                  
                  )
                ],
              ),
              addVerticalSpace(),

              FloatingLabelEditBox(labelText: 'Name'),
              addVerticalSpace(),
              FloatingLabelEditBox(labelText: 'Email'),
              addVerticalSpace(),

              FloatingLabelEditBox(labelText: 'Password'),
              addVerticalSpace(),

              FloatingLabelEditBox(labelText: 'Confirm Password'),
            ],
          )
        ),
      ),
    );
  }
  
  void chooseImage() {
    print('Image picker called');
  }
}



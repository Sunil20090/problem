import 'dart:convert';
import 'dart:io';

import 'package:election/components/colored_button.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const double DEFAULT_SPACE = 12;

SizedBox addHorizontalSpace([double width = DEFAULT_SPACE]) {
  return SizedBox(width: width);
}

SizedBox addVerticalSpace([double height = DEFAULT_SPACE]) {
  return SizedBox(height: height);
}

showAlert(BuildContext context, String title, String message,
    {bool isError = false, bool isDismissible = true, VoidCallback? onDismiss}) {
  showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (builder) {
        var color = isError ? COLOR_BASE_ERROR : COLOR_BASE_SUCCESS;
        VoidCallback myFunc;
        if(onDismiss != null){
            myFunc = onDismiss;
        }else {
          myFunc = () => Navigator.pop(context);
        }
        
        return AlertDialog(
          title: Text(title, style: TextStyle(color: color)),
          content: Text(message, style: TextStyle(color: color)),
          actions: <Widget>[
            ColoredButton(
                onPressed: myFunc,
                child: Text('OK', style: TextStyle(color: COLOR_BASE))),
          ],
        );
      });
}


  Future<File?> getLocalImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    return pickedFile != null? File(pickedFile.path) : null;
  }  



  Future<String> fileToBase64(File file) async {
    String base64 = await file.readAsBytes().then((bytes) => base64Encode(bytes));
    return base64;
  }




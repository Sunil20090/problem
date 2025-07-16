import 'package:election/components/colored_button.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:flutter/material.dart';

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



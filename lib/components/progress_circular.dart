import 'package:Problem/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class ProgressCircular extends StatelessWidget {
  final double width, height;
  final Color color;
  ProgressCircular({super.key, this.width = 25, this.height = 25, this.color = COLOR_BASE});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CircularProgressIndicator(color: color,),
    );
  }
}

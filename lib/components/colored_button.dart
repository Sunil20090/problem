import 'package:election/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class ColoredButton extends StatefulWidget {
  VoidCallback? onPressed;
  Widget child;
  Color backgroundColor;
  double radius;
  ColoredButton({super.key, this.onPressed, required this.child, this.backgroundColor = COLOR_PRIMARY, this.radius = 10});

  @override
  State<ColoredButton> createState() => _ColoredButtonState();
}

class _ColoredButtonState extends State<ColoredButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
          padding: CONTENT_PADDING,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.radius)
          ),
          child: widget.child
          
          ),
    );
  }
}

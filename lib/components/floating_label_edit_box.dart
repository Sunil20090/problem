import 'package:flutter/material.dart';

class FloatingLabelEditBox extends StatefulWidget {
  TextEditingController? controller;
  final String labelText;
  final int maxLines;
  final bool hideText;
  FloatingLabelEditBox(
      {super.key, this.controller, required this.labelText, this.maxLines = 1, this.hideText = false});

  @override
  State<FloatingLabelEditBox> createState() => _FloatingLabelEditBoxState();
}

class _FloatingLabelEditBoxState extends State<FloatingLabelEditBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      obscureText: widget.hideText,
      decoration: InputDecoration(
          label: Text(widget.labelText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}

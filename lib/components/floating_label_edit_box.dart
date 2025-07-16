import 'package:flutter/material.dart';

class FloatingLabelEditBox extends StatefulWidget {

  TextEditingController? controller;
  final String labelText;
  final int maxLines;
  FloatingLabelEditBox({super.key, this.controller, required this.labelText, this.maxLines = 1});

  @override
  State<FloatingLabelEditBox> createState() => _FloatingLabelEditBoxState();
}

class _FloatingLabelEditBoxState extends State<FloatingLabelEditBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
                controller: widget.controller,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  label: Text(widget.labelText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              );
  }
}
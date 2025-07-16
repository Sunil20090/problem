import 'package:election/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {

  final String title, description;
  const PageHeading({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CUSTOM_TEXT_THEME.headlineLarge,
          ),
          Text(
            description,
            style: CUSTOM_TEXT_THEME.bodyLarge,
          )
        ],
      ),
    );
  }
}

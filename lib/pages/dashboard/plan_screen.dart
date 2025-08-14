import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/user/user_data.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Text('User: $USER_ID', style: getTextTheme().headlineLarge,),
          addVerticalSpace(),
          Text(
            'Plans screen',
            style: getTextTheme().headlineLarge,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().headlineMedium,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().headlineSmall,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().titleLarge,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().titleMedium,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().titleSmall,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().bodyLarge,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().bodyMedium,
          ),
          Text(
            'Plans screen',
            style: getTextTheme().bodySmall,
          ),
        ],
      ),
    );
  }
}

import 'package:Problem/components/enter_text_box.dart';
import 'package:Problem/components/page_heading.dart';
import 'package:Problem/constants/local_constant.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class NominationApplyPage extends StatefulWidget {
  final String form_id;
  const NominationApplyPage({super.key, required this.form_id});

  @override
  State<NominationApplyPage> createState() => _NominationApplyPageState();
}

class _NominationApplyPageState extends State<NominationApplyPage> {
  final double padding = 20;
  final List<String> positions = ["CR", "Vice-CR"];
  String selectedOption = "CR";

  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: SCREEN_PADDING,
        decoration: getAppDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(40),
            const PageHeading(
                title: 'Apply Nomination',
                description:
                    'You can apply for nomination for yourself to stand out as a perticular position'),
            addVerticalSpace(20),
            EnterTextBox(
              hintText: 'Full Name',
              controller: _fullNameController,
            ),
            addVerticalSpace(UI_PADDING),
            EnterTextBox(
              hintText: 'Roll number  ',
              controller: _rollNumberController,
            ),
            addVerticalSpace(40),
            Text(
              "Nominate for: ",
              style: getTextTheme().headlineSmall,
            ),
            SizedBox(
              height: 160,
              child: ListView(
                children: positions
                    .map((toElement) => RadioListTile(
                        title: Text(toElement),
                        value: toElement,
                        groupValue: selectedOption,
                        onChanged: (selectedValue) {
                          setState(() {
                            selectedOption = selectedValue!;
                          });
                        }))
                    .toList(),
              ),
            ),
            TextButton(
                onPressed: () {
                  applyForNomination();
                },
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    backgroundColor: WidgetStateProperty.all(Colors.blue)),
                child: Text('Nominate'))
          ],
        ),
      ),
    );
  }

  bool isValid() {
    if (_rollNumberController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void applyForNomination() async {
    if (!isValid()) {
      informDialog(context, 'Error!', "Please enter the valid roll number");
      return;
    }

    var body = {
      "rollNumber": _rollNumberController.text.toUpperCase(),
      "fullName": _fullNameController.text.toUpperCase(),
      "position": selectedOption,
      "formId": widget.form_id
    };
    final ApiResponse response = await postService(URL_APPLY_NOMINATION, body);

    if (response.isSuccess) {
      // Navigator.pop(context);
      informDialog(context, 'Success', response.body['message']);
    }
  }
}

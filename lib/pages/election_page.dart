import 'package:election/components/enter_text_box.dart';
import 'package:election/components/page_heading.dart';
import 'package:election/constants/local_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';


class ElectionPage extends StatefulWidget {

  final String form_id;
  ElectionPage({super.key, required this.form_id});

  @override
  State<ElectionPage> createState() => _ElectionPageState();

}

class _ElectionPageState extends State<ElectionPage> {

  // var _nominationList = [];

  final TextEditingController _rollNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getNominationList();
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: SCREEN_PADDING,
        decoration: getAppDecoration(),
        child: Column(
          children: [
              addVerticalSpace(40),
              PageHeading(title: 'Election', description: 'Here you can vote to your candidate to elect them for some responsibility!'),
              addVerticalSpace(UI_PADDING),
              EnterTextBox(hintText: 'Roll Number', controller: _rollNumberController,),
              addVerticalSpace(UI_PADDING),

              Expanded(child: listOfNominee()),

              addVerticalSpace(20),
       
          ],
        ),
      ),
    );
  }

  listOfNominee(){
    var list = ["Sunil", "Manoj", "Pankaj"];
    String selectedValue = list[0];
    return ListView(

      children: list.map((toElement) => RadioListTile(
        value: toElement, 
        groupValue: selectedValue, 
        onChanged: (choosenValue){
          setState(() {
            selectedValue = choosenValue!;
          });
        })).toList(),);
  }
  
  void getNominationList() async {
    var request_body = {
      "rollNumber" : _rollNumberController.text,
      "formId" : widget.form_id,
    };

    ApiResponse response = await postService(URL_APPPLY_VOTE, request_body);

    if(response.isSuccess){
      informDialog(context, 'Success', response.body['message']);
    }
  }
}
import 'package:election/components/page_heading.dart';
import 'package:election/constants/local_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/pages/form_list_page.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCreatePage extends StatefulWidget {
  const FormCreatePage({super.key});

  @override
  State<FormCreatePage> createState() => _FormCreatePageState();
}

class _FormCreatePageState extends State<FormCreatePage> {
  DateTime? _dateTime;
  double verticlSpacing = 25;

  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _semesterContrller = TextEditingController();
  final TextEditingController _formTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: getAppDecoration(),
        padding: SCREEN_PADDING,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(40),
            Row(
              children: [
                
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => FormListPage()));
                    },
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(Icons.list)),
                  )
              ],
            ),
           addVerticalSpace(20),
           PageHeading(title: 'Create Election!', description: 'Enter your college name,  branch name and year of admission''Enter your college name,  branch name and year of admission'),
            addVerticalSpace(verticlSpacing),
            TextField(
              controller: _formTitleController,
              decoration: InputDecoration(
                  hintText: 'Title',
                  filled: true,
                  fillColor: Colors.white,
                  border: getInputBorder()),
            ),
            addVerticalSpace(verticlSpacing),
            TextField(
              controller: _collegeNameController,
              decoration: InputDecoration(
                  hintText: 'College Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: getInputBorder()),
            ),
            addVerticalSpace(verticlSpacing),
            TextField(
              controller: _branchNameController,
              decoration: InputDecoration(
                  hintText: 'Branch Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: getInputBorder()),
            ),
            
            addVerticalSpace(verticlSpacing),
            TextField(
              controller: _semesterContrller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  hintText: 'Semester [eg: 3]',
                  filled: true,
                  
                  fillColor: Colors.white,
                  border: getInputBorder()),
            ),
            addVerticalSpace(verticlSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  
                  children: [
                    const Text('Year of admission:', style: TextStyle(fontSize: 18)),
                    addHorizontalSpace(5),

                    _dateTime == null
                    ? Text('Not Choosen', style: const TextStyle(fontSize:  20, fontWeight: FontWeight.bold))
                    : Text('${formatDateTime("yyyy", _dateTime!)}', style: const TextStyle(fontSize:  20, fontWeight: FontWeight.bold))
                  
                    
                  ],
                ),
                 
                TextButton(

                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 231, 115, 106)),
                        foregroundColor: WidgetStateProperty.all(Colors.white)),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              initialDatePickerMode: DatePickerMode.year)
                          .then((onValue) {
                        _dateTime = onValue!;
                        setState(() {});
                      });
                    },
                    child: const Text('Choose Year')),
              ],
            ),
            addVerticalSpace(40),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.blue)),
                onPressed: (){
                  submitForm();
                }, child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Create', style: TextStyle(fontSize: 22),),
                      addHorizontalSpace(10),
                      
                    ],
                  )
                ))),
            )
          ],
        ),
      ),
    );
  }

  isValid(){

    if(_formTitleController.text.trim().isEmpty){
      informDialog(context, "Error!", "Enter the title");
      return false;
    }
    if(_collegeNameController.text.trim().isEmpty){
      informDialog(context, "Error!", "Enter the college name");
      return false;
    }
    if(_branchNameController.text.trim().isEmpty){
      informDialog(context, "Error!", "Enter the branch name");
      return false;
    }
    if(_semesterContrller.text.trim().isEmpty){
      informDialog(context, "Error!", "Enter the semester");
      return false;
    }

    if(_dateTime == null){
      informDialog(context, "Error!", "Choose year of admission");
      return false;
    }
    return true;
  }

  submitForm() async {
    
    
    if(!isValid()){
      return;
    }

    showDialog(context: context, barrierDismissible: false, builder: (builder){
      
      return Dialog(
        
        child: SizedBox(
          width: 60,
          height: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              
            ],
          ),
        ),
      );
    });

    var request_body = {
      "username" : "simple@gmail.com",
      "title" : _formTitleController.text,
      "collegeName" : _collegeNameController.text,
      "branch" : _branchNameController.text,
      "yearOfAdmission" : formatDateTime("yyyy", _dateTime!),
      "semester" : _semesterContrller.text
    };


    ApiResponse res = await postService(URL_CREATE_ELECTION_FORM, request_body);
    Navigator.pop(context);

    print(res.body);
    if(res.isSuccess){
      if(res.body['status'] == "OK"){
        setState(() {
          emptyField();
          
          informDialog(context, "Success", res.body['message']);
        });
      }
    }


  }


  emptyField(){
    _branchNameController.text = "";
    _collegeNameController.text = "";
    _semesterContrller.text = "";
    _formTitleController.text = "";
    _dateTime = null;
  }

  getDateTime(){
    return _dateTime == null ? "No Choosen" : _dateTime!;
  }
}




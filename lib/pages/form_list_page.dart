import 'package:election/components/page_heading.dart';
import 'package:election/components/property_view.dart';
import 'package:election/constants/local_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/constants/url_constant.dart';
import 'package:election/pages/election_page.dart';
import 'package:election/pages/form_create_page.dart';
import 'package:election/pages/nomination_apply_page.dart';
import 'package:election/utils/api_service.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class FormListPage extends StatefulWidget {
  const FormListPage({super.key});

  @override
  State<FormListPage> createState() => _FormListPageState();
}

class _FormListPageState extends State<FormListPage> {
  dynamic _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getAppDecoration(),
        padding: SCREEN_PADDING,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            InkWell(
              onTap: (){
                openCreatePage();
              },
              child: SizedBox(
                width: 60,
                height: 60,
                child: Icon(Icons.forest),
              ),
            ),
            addVerticalSpace(40),
            PageHeading(
                title: "Available Elections",
                description:
                    "Here are the list of election you can vote/nominate if not already!"),
            addVerticalSpace(30),
            Expanded(
                child: ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: SCREEN_PADDING,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onTap: (){
                                if(_list[index]['mode'] == 'nomination'){
                                  openNominationScreen(_list[index]['form_id']);
                                }else if(_list[index]['mode'] == 'election'){
                                  openElectionScreen(_list[index]['form_id']);
                                }
                              },
                              child: Card(
                                color: Color.fromARGB(255, 186, 255, 217),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                            TextButton(
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                                              child:   Text(_list[index]['mode'], style: TextStyle(color: Colors.white)),
                                              onPressed: (){
                                          
                                            }, )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _list[index]['form_title'],
                                            style:
                                                CUSTOM_TEXT_THEME.headlineMedium,
                                          )
                                        ],
                                      ),                                    
                                      
                                      PropertyView(property: 'College:', value:  _list[index]['college_name']),
                                      PropertyView(property: 'Year of admission:', value:  _list[index]['year_of_admission']),
                                      PropertyView(property: 'Branch:', value:  _list[index]['branch']),
                                      PropertyView(property: 'Semester:', value:  _list[index]['semester']),
                                      if (_list[index]['count'] != null) PropertyView(property: 'Current Nomination:', value:  '${_list[index]['count']}')
                                          
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -15,
                              left: -15,
                              child: CircleAvatar(
                                child: Icon(Icons.file_open_rounded),
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void initList() async {

    ApiResponse response = await getService(URL_GET_ELECTION_LIST);
    print(response.body);

    if(response.isSuccess){
      setState(() {
      _list = response.body;
      });
    }
 
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  void openNominationScreen(String form_id) {
      Navigator.push(context, MaterialPageRoute(builder: (builder) => NominationApplyPage(form_id: form_id,)));
  }

  openCreatePage(){
    Navigator.push(context, MaterialPageRoute(builder: (builder) => FormCreatePage()));
  }
  
  void openElectionScreen(String form_id) {
      Navigator.push(context, MaterialPageRoute(builder: (builder) => ElectionPage(form_id: form_id,)));
  }

}


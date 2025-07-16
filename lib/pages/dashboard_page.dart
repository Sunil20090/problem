import 'package:election/constants/image_constant.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: SCREEN_PADDING,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                // color: const Color.fromARGB(100, 122, 181, 88),
                child: Stack(
                  
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Image.asset(IMAGE_PALM_TREE)),
                    Positioned(
      
                      child: Container(
                      color: const Color.fromARGB(160, 122, 181, 88),
                    )),
                    Positioned(
                      left: 10,
                      top: 30,
                      child: Row(
                        children: [
                          Container(
                            // color: Colors.white,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                          
                            ),
                            width: 80,
                            height: 80,
                            child: SizedBox(
                              child: CircleAvatar(
                                backgroundImage: Image.asset(IMAGE_PALM_TREE, fit: BoxFit.contain,).image,),
                            )
                          ),
                          addHorizontalSpace(20),
                          Container(
                            width: MediaQuery.of(context).size.width-200,
                            child: Text("Are you hungary today! What are you doing",
                             softWrap: true, 
                             style: TextStyle(fontSize: 22, color: COLOR_WHITE, fontWeight: FontWeight.w800),
                            ),
                          )
                        ],
                      )
                      )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 6,
              child: const Placeholder())
          ],
        ),
      ),
    );
  }
}
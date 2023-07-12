import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/Module/LeaderBoardDetials.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import 'ModuleController.dart';
import 'QuizAttempt.dart';
import 'package:http/http.dart' as http;

import 'Quiz_Details.dart';

class LeaderBoardList extends StatefulWidget {
  const LeaderBoardList({Key? key}) : super(key: key);

  @override
  State<LeaderBoardList> createState() => _LeaderBoardListState();
}

class _LeaderBoardListState extends State<LeaderBoardList> {
  final controller = Get.put(ModuleController());
  Future? ExamDetails;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(AppUrl.CourseExamList + controller.Courseid.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['examList'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ExamDetails = allExperience();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              automaticallyImplyLeading: false, // Don't show the leading button

              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: Row(
                children: [
                  Image.asset("assets/images/podium.png",height: 30,width: 30,),SizedBox(width: 10,),

                  Text(
                    "Leader Board",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              )),
          body: FutureBuilder(
            future: ExamDetails,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    SizedBox(
                      height: size.height / 3,
                    ),
                    SpinKitCircle(
                      color: AppColors.primaryGreen,
                      size: 30,
                    ),
                    Center(
                      child: Text(
                        " Please wait while Loading..",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [


                      ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Image.network(
                                                'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
                                                height: 20,
                                                width: 20,
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.greybg,
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Quiz ",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        controller.QuizList[index]['name'],
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.examid.value = snapshot
                                              .data[index]['id']
                                              .toString();
                                          Get.to(()=>LeaderBoardDetails(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 500));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Show Leaeder Board",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text("No Data Found"),
                    ),
                    // Center(child: TextButton(
                    //   // onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectNewAddress())),
                    //   child: Text("Try anotother location"),
                    // ),)
                  ],
                );
              }
            },
          ),
        ));
  }
}

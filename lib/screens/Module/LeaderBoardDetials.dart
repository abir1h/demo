import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import 'ModuleController.dart';
import 'QuizAttempt.dart';
import 'package:http/http.dart' as http;

import 'Quiz_Details.dart';

class LeaderBoardDetails extends StatefulWidget {
  const LeaderBoardDetails({Key? key}) : super(key: key);

  @override
  State<LeaderBoardDetails> createState() => _LeaderBoardDetailsState();
}

class _LeaderBoardDetailsState extends State<LeaderBoardDetails> {
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
        Uri.parse(AppUrl.LeaderBoard + controller.examid.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['leaderBoardData'];
      print(userData1);
      setState(() {
        mypos=jsonDecode(response.body)['myPosition'];
        myMarks=jsonDecode(response.body)['myMarks'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var mypos,myMarks;
  getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }
  var name='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ExamDetails = allExperience();
    getdata();
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
              title:Row(
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
                  child: Column(                        crossAxisAlignment: CrossAxisAlignment.start,

                    children: [


                      ListView.builder(
                          itemCount: snapshot.data.length>3?3:snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 0,

                                color: index==0?AppColors.lgreen_light:index==1?AppColors.lblue_light:AppColors.lorange_light,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                            Text(index==0?"1st":index==1?"2nd":"3rd",style: TextStyle(color:index==0?AppColors.lgreen:index==1?AppColors.lblue:
                                          AppColors.lorange,fontWeight: FontWeight.w700,fontSize: 20),),
                                            Expanded(
                                              child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: AppColors.golden2,
                                              child: Image.asset('assets/images/luser.png',height: 25,width: 25,),
                                          ),
                                            ),
                                          Expanded(
                                            child: Text(snapshot.data[index]['user_name'],style: TextStyle(
                                              color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16
                                            ),),
                                          ),
                                          Expanded(
                                            child:   Column(
                                              children: [
                                                Text(snapshot.data[index]['marks'].toString(),style: TextStyle(
                                                    color:index==0?AppColors.lgreen:index==1?AppColors.lblue:
                                                    AppColors.lorange,fontWeight: FontWeight.w700,fontSize: 16
                                                ),),  Text("Marks",style: TextStyle(
                                                    color:index==0?AppColors.lgreen:index==1?AppColors.lblue:
                                                    AppColors.lorange,fontWeight: FontWeight.w400,fontSize: 16
                                                ),),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      Divider(thickness: 1,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          foregroundDecoration: RotatedCornerDecoration.withColor(
                            badgeShadow: BadgeShadow(
                              elevation: 5,
                              color: Colors.grey.withOpacity(.5)
                            ),
                            color: AppColors.golden_badge,
                            spanBaselineShift: 2,
                            badgeSize: Size(40, 40),
                            badgeCornerRadius: Radius.circular(8),
                            badgePosition: BadgePosition.topStart,
                            textSpan: TextSpan(
                              text: 'You',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                letterSpacing: 1,
                                fontWeight: FontWeight.normal,
                                shadows: [
                                  BoxShadow(color:AppColors.golden_badge, blurRadius: 8),
                                ],
                              ),
                            ),
                          ),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: AppColors.golden
                         ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(mypos.toString()+'th',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w700,fontSize: 14),),
                                    Expanded(
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.golden2,
                                        child: Image.asset('assets/images/luser.png',height: 25,width: 25,),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(name,style: TextStyle(
                                          color: Colors.black,fontWeight: FontWeight.w700,fontSize: 14
                                      ),),
                                    ),
                                    Expanded(
                                      child:   Column(
                                        children: [
                                          Text(myMarks.toString(),style: TextStyle(
                                              color:Colors.black,fontWeight: FontWeight.normal,fontSize: 14
                                          ),),  Text("Marks",style: TextStyle(
                                              color:Colors.black,fontWeight: FontWeight.normal,fontSize: 14
                                          ),),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Others",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 16),)
                          ],
                      ),
                          ), Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(thickness: 1,),
                          ),
                      ListView.builder(
                          itemCount: snapshot.data.length>3?3:snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.golden
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text((index+1).toString()+' th',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w700,fontSize: 14),),
                                          Expanded(
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: AppColors.golden2,
                                              child: Image.asset('assets/images/luser.png',height: 25,width: 25,),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,fontWeight: FontWeight.w700,fontSize: 14
                                            ),),
                                          ),
                                          Expanded(
                                            child:   Column(
                                              children: [
                                                Text(myMarks.toString(),style: TextStyle(
                                                    color:Colors.black,fontWeight: FontWeight.normal,fontSize: 14
                                                ),),  Text("Marks",style: TextStyle(
                                                    color:Colors.black,fontWeight: FontWeight.normal,fontSize: 14
                                                ),),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),


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

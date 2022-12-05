import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
class bookingStatus extends StatefulWidget {
  final String bookingdate,bookingTime,person,occasion,specialreq,status,reservationid,name,bookingId;
  const bookingStatus({Key? key,required this.bookingId, required this.bookingdate, required this.bookingTime, required this.person, required this.occasion, required this.specialreq, required this.status, required this.reservationid, required this.name}) : super(key: key);

  @override
  State<bookingStatus> createState() => _bookingStatusState();
}

class _bookingStatusState extends State<bookingStatus> {
  bool expanded=false;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.cancelReservation + widget.bookingId),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Reservation Canceled",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        cancelDone=false;
      });
      Get.to(()=>Main_home());
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
/*
      name= userData1['basicInfo']['name'];
*/
      print(userData1);
      return userData1;
    } else {
      setState(() {
        cancelDone=false;
      });
      print("post have no Data${response.body}");
    }
  }
  bool cancelDone=false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: ()async{
        Get.to(()=>Main_home());
        return true;
      },
      child: SafeArea(child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Get.to(()=>Main_home());

            },
          ),
          centerTitle: true,
          title: Row(
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    cancelDone=false;
                  });
                },
                child: const Text('Reservation ID : ',style: TextStyle(
                  color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                ),),
              ),  Text('  #'+widget.reservationid,style: TextStyle(
                color:AppColors.orange,fontSize: 14,fontWeight: FontWeight.w400
              ),),

            ],
          ),

        ),
        body: SingleChildScrollView(
          child: cancelDone==false?Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height:size.height ,
                  width: size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),

                        spreadRadius: 2,

                        blurRadius: 4,

                        offset: const Offset(
                            0, 0), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          AppColors.ge,
                          Colors.white
                        ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Your Reservation has been sent ',style: TextStyle(
                  color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                  )),
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Successfully',style: TextStyle(
                  color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                  )),
                        ),
                      ) ,
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('Please wait for restaurant Manager’s reply',style: TextStyle(
                                  color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                              )),
                            ),Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('It may take maximum 10 minutes',style: TextStyle(
                                  color:Colors.grey,fontSize: 12,fontWeight: FontWeight.w400
                              )),
                            )
                          ],
                        ),
                      ),
                      Center(child: Lottie.asset('assets/images/progress.json',height: size.height/8,)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Reservation in progress',style: TextStyle(
                              color:Colors.black,fontSize: 14,fontWeight: FontWeight.w700
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: (){
                            setState(() {

                              expanded==true?expanded=false:expanded=true;

                            });
                          },
                          child: Row(
                            children: [
                              Text("Reservation Details    ",style: TextStyle(
                                  color:Colors.black,fontSize: 13,fontWeight: FontWeight.w500
                              )),Icon(expanded==true?Icons.arrow_drop_up:Icons.arrow_drop_down_sharp,color: Colors.black,)
                            ],
                          ),
                        ),
                      ),
                      if (expanded==true) Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name,style: TextStyle(
                                  color:Colors.black,fontSize: 12,fontWeight: FontWeight.w800
                              )),
                              Container(
                                width: size.width/2,

                                child: Row(

                                  children: [
                                    Text('Number of Guest',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(': '+widget.person,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ),  /* Container(
                                width: size.width/2,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Offer',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(':  '+widget.,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ),*/ Container(
                                width: size.width/2,

                                child: Row(
                                  children: [
                                    Text('Occassion',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(':  '+widget.occasion,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ), Container(
                                width: size.width/2,

                                child: Row(
                                  children: [
                                    Text('Special Req',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(':   '+widget.specialreq,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ),Container(
                                width: size.width/2,

                                child: Row(
                                  children: [
                                    Text('Reservation ID',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(':  #'+widget.reservationid,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ),Container(
                                width: size.width/1.6,

                                child: Row(
                                  children: [
                                    Text('Date',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(':  '+widget.bookingdate,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ),Container(
                                width: size.width/1.65,

                                child: Row(
                                  children: [
                                    Text('Time ',style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),Text(':  '+widget.bookingTime,style: TextStyle(
                                        color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                    )),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ) else Container(),
                      SizedBox(height: 20,),
                      Center(child: InkWell(
                        onTap: (){
                          setState(() {
                            cancelDone=true;
                          });
                          getpost();

                        },
                        child: Text(
                            'Cancel Reservation',style: TextStyle(
                          decoration: TextDecoration.underline,
                            color:AppColors.orange,fontSize: 16,fontWeight: FontWeight.w600
                        )
                        ),
                      ),),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Call Gosy for help :15451',style: TextStyle(
                            color:Colors.grey.withOpacity(.5),fontSize: 12,fontWeight: FontWeight.w400
                        )
                        ),
                      ),)


                    ],
                  ),
                ),
              )

            ],
          ):Column(
            children: [
              SizedBox(height: size.height/2.5,),
              Center(child: SpinKitCircle(color: AppColors.orange,size: 25,)),
              Center(child: Text("Please wait while cancelling reservation",style: TextStyle(color: AppColors.orange,fontWeight: FontWeight.bold),))
            ],
          ),
        ),

      )),
    );
  }
}

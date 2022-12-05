import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../../utils/Appurl.dart';
import 'bookingStatus.dart';
class bookingDetails extends StatefulWidget {
  final String bookingdate,bookingTime,person,occasion,specialreq,status,reservationid,name,phone,bookingid,gesttime1,gusttime2,restTime1,restTime2,resturent_id;
  const bookingDetails({Key? key,required this.resturent_id,required this.gesttime1,required this.gusttime2,required this.restTime1,required this.restTime2,required this.bookingid,required this.phone, required this.bookingdate, required this.bookingTime, required this.person, required this.occasion, required this.specialreq, required this.status, required this.reservationid, required this.name}) : super(key: key);

  @override
  State<bookingDetails> createState() => _bookingDetailsState();
}

class _bookingDetailsState extends State<bookingDetails> {
  bool expanded=true;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.cancelReservation + widget.bookingid),
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

    return SafeArea(child: Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Get.back();
          },
        ),
        centerTitle: true,
        title: Row(
          children: [
            const Text('Reservation ID : ',style: TextStyle(
                color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400
            ),),  Text('  #'+widget.reservationid,style: const TextStyle(
                color:AppColors.orange,fontSize: 14,fontWeight: FontWeight.w400
            ),),

          ],
        ),

      ),
      body: SingleChildScrollView(
        child: cancelDone==false?Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15,),
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
                    const SizedBox(height: 15,),
                    widget.status=="Accepted"?Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Your Reservation has been  ',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ), const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Accepted',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ) ,
                    ],): widget.status=="Canceled"?
                    Column(children: [
                     const Padding(
                       padding: EdgeInsets.all(8.0),
                       child: Center(
                         child: Text('Your Reservation has been Canceled ',style: TextStyle(
                             color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                         )),
                       ),
                     ),
                   ],):
                    widget.status=="Rearranged"? Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Your Rearranged Reservation ',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ),  const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(' has been sent  ',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ), const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Succesfully',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ) ,
                    ],):
                    Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Your Reservation has been sent ',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ), const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Successfully',style: TextStyle(
                              color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                          )),
                        ),
                      ) ,
                    ],),
                    const SizedBox(height: 10,),
                    widget.status=="Accepted"? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Text(widget.name,style: const TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold
                                )),  const Text(' Expects to welcome you  at',style: TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                                )),
                              ],
                            ),
                          ),Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(' '+ widget.bookingTime+' on '+widget.bookingdate,style: const TextStyle(
                                color:Colors.grey,fontSize: 12,fontWeight: FontWeight.w400
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                const Text("Call ",style: TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                                )),
                                Text(widget.name+' ',style: const TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold
                                )),  const Text(' For any Further Details',style: TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.phone,style: const TextStyle(
                                color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                            )),
                          ),
                        ],
                      ),
                    ): widget.status=="Canceled"?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                  const Text('Hopefully we will serve you next time.',style: TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold
                                )),
                              ],
                            ),
                          ),const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                const Text("Call ",style: TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                                )),
                                Text(widget.name+' ',style: const TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold
                                )),  const Text(' For any Further Details',style: TextStyle(
                                    color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.phone,style: const TextStyle(
                                color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                            )),
                          ),
                        ],
                      ),
                    ):
                    widget.status=="Rearranged"?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('Please wait for restaurant Manager’s reply',style: TextStyle(
                                color:Colors.black,fontSize: 14,fontWeight: FontWeight.w400
                            )),
                          ),const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('It may take maximum 10 minutes',style: TextStyle(
                                color:Colors.grey,fontSize: 12,fontWeight: FontWeight.w400
                            )),
                          )
                        ],
                      ),
                    ):
                  widget.status=="Accepted"?Center(child: Lottie.asset('assets/images/congrats.json',height: size.height/8,))
                  :widget.status=="Canceled"?Center(child: Lottie.asset('assets/images/canceled.json',height: size.height/8,))
                      :  Center(child: Lottie.asset('assets/images/progress.json',height: size.height/8,)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(  widget.status=="Accepted"?"Reservation Accepted":widget.status=="Canceled"?"Reservation is canceled":'Reservation in progress',style: const TextStyle(
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
                            const Text("Reservation Details    ",style: TextStyle(
                                color:Colors.black,fontSize: 13,fontWeight: FontWeight.w500
                            )),Icon(expanded==true?Icons.arrow_drop_up:Icons.arrow_drop_down_sharp,color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    if (expanded==true) Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:    widget.status=="Rearranged"?Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,style: const TextStyle(
                                color:Colors.black,fontSize: 12,fontWeight: FontWeight.w800
                            )),
                            Container(
                              width: size.width/2,

                              child: Row(

                                children: [
                                  const Text('Number of Guest',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(': '+widget.person,style: const TextStyle(
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
                                  const Text('Occassion',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.occasion,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ), Container(
                              width: size.width/2,

                              child: Row(
                                children: [
                                  const Text('Special Req',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':   '+widget.specialreq,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),Container(
                              width: size.width/2,

                              child: Row(
                                children: [
                                  const Text('Reservation ID',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  #'+widget.reservationid,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),Container(
                              width: size.width/1.6,

                              child: Row(
                                children: [
                                  const Text('Date',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.bookingdate,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),Container(
                              width: size.width/1.65,

                              child: Row(
                                children: [
                                  const Text('Time ',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.bookingTime,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),
                            widget.gesttime1=='t'?Container():SizedBox(
                              width: size.width/1.65,

                              child: Row(
                                children: [
                                  const Text('Guest Propose Time 1  ',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.gesttime1,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),    widget.gusttime2=='t'?Container():SizedBox(
                              width: size.width/1.65,

                              child: Row(
                                children: [
                                  const Text('Guest Propose Time 2  ',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.gusttime2,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),  widget.restTime1=='t'?Container():SizedBox(
                              width: size.width/1.65,

                              child: Row(
                                children: [
                                  const Text('Restaurant Propose Time 1  ',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.restTime1,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),widget.restTime2=='t'?Container():SizedBox(


                              child: Row(
                                children: [
                                  const Text('Restaurant Propose Time 2  ',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.restTime2,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ):Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,style: const TextStyle(
                                color:Colors.black,fontSize: 12,fontWeight: FontWeight.w800
                            )),
                            Container(
                              width: size.width/2,

                              child: Row(

                                children: [
                                  const Text('Number of Guest',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(': '+widget.person,style: const TextStyle(
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
                                  const Text('Occassion',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.occasion,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ), Container(
                              width: size.width/2,

                              child: Row(
                                children: [
                                  const Text('Special Req',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':   '+widget.specialreq,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),Container(
                              width: size.width/2,

                              child: Row(
                                children: [
                                  const Text('Reservation ID',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  #'+widget.reservationid,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),Container(
                              width: size.width/1.6,

                              child: Row(
                                children: [
                                  const Text('Date',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.bookingdate,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),Container(
                              width: size.width/1.65,

                              child: Row(
                                children: [
                                  const Text('Time ',style: TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),Text(':  '+widget.bookingTime,style: const TextStyle(
                                      color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                  )),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ) else Container(),
                    const SizedBox(height: 20,),
                    widget.status=="Canceled"?Container(): Column(
                     children: [
                       InkWell(
                         onTap: (){
                           showDialog(
                             context: context,
                             builder: (context) => CustomDialog(
                               id: widget.bookingid,
                                 height: size.height, width: size.width),
                           );

                         },
                         child: Container(
                           height: size.height/20,
                           width: size.width/2,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             border: Border.all(color: AppColors.orange)
                           ),
                           child: const Center(
                             child: Text("Re-arranged",style: TextStyle(color: AppColors.orange),),
                           ),
                         ),
                       ),
                       const Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text("Or",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18),),
                       )
                       ,                      Center(child: InkWell(
                         onTap: (){
                           setState(() {
                             cancelDone=true;
                           });
                           getpost();

                         },
                         child: const Text(
                             'Cancel Reservation',style: TextStyle(
                             decoration: TextDecoration.underline,
                             color:AppColors.orange,fontSize: 16,fontWeight: FontWeight.w600
                         )
                         ),
                       ),),

                       Center(child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                             'Call GOSY for help :15451',style: TextStyle(
                             color:Colors.grey.withOpacity(.5),fontSize: 12,fontWeight: FontWeight.w400
                         )
                         ),
                       ),)
                     ],
                   )


                  ],
                ),
              ),
            )

          ],
        ):Column(
          children: [
            SizedBox(height: size.height/2.5,),
            const Center(child: SpinKitCircle(color: AppColors.orange,size: 25,)),
            const Center(child: Text("Please wait while cancelling reservation",style: TextStyle(color: AppColors.orange,fontWeight: FontWeight.bold),))
          ],
        ),
      ),

    ));
  }
}
class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.height,
    required this.width,
    required this.id
  }) : super(key: key);

  final double height;
  final double width;
  final String id;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool reminderOn = false;
  List<bool> days = [false, false, false, false, false, false, false];
  List selected = [];
  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();
  String time = DateFormat.jm().format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  DateTime? picdate;

   _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        picdate = picked;
      });
  }
  TextEditingController _timeC = TextEditingController();
  late Future<TimeOfDay?> selectedTimeRTL;
  static DateTime _eventdDate = DateTime.now();

  static var now =
  TimeOfDay.fromDateTime(DateTime.parse(_eventdDate.toString()));
  TimeOfDay timeOfDay = TimeOfDay.now();

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        _timeC.text = "${time.hour}:${time.minute}";

        pickedtime= _timeC.text;

      });
    }
  }
  var day,pickedtime;
  bool submit=false;
  Future rearrange(String day, String time,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.bookingRearange+widget.id),
    );
    request.fields.addAll({
      'date': day,
      'time': time,

    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            submit = false;
          });
          var userData1 = jsonDecode(response.body)['data'];
          Fluttertoast.showToast(
              msg: "Booking Request Submitted Succesfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Get.to(()=>Main_home());
/*
          Get.to(() => bookingStatus(

            bookingId:userData1['restaurant_id'].toString() ,
            bookingdate: userData1['booking_date'],bookingTime: userData1['booking_time'],person: userData1['person'],
            occasion: userData1['party_type'],status:userData1['status'] ,name:userData1['restaurant_info']['name'],
            reservationid:userData1['code'] ,specialreq:userData1['special_request'] ?? '',));
*/
        } else {
          setState(() {
            submit = false;
          });
          var data = jsonDecode(response.body);

          Fluttertoast.showToast(
              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: widget.height * 0.6,
        width: widget.width * 0.98,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(
                height: 100,


              ),
              const Text("Re-arranged Date ",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
             const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  _selectDate(context);
                },
                child: Container(
                  height: widget.height/25,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),borderRadius: BorderRadius.circular(10)
                  ),
                  child: picdate==null?const Center(child: Text("Pick Re-arranged Date"),):Center(
                    child:Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                ),
              ),
              const SizedBox(height: 20,),


              const Text("Re-arranged Time ",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
             const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  displayTimePicker(context);
                },
                child: Container(
                  height: widget.height/25,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),borderRadius: BorderRadius.circular(10)
                  ),
                  child: _timeC.text.isEmpty?const Center(child: Text("Pick Re-arranged Time"),):Center(
                    child:Text("${pickedtime}"),
                  ),
                ),
              ),
              const SizedBox(height: 35,),

              submit==false?InkWell(
                onTap: (){
                  if(pickedtime==null){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please select Time',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else if(picdate==null){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please select Date',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else{
                    setState(() {
                      submit=true;
                    });
                    rearrange("${selectedDate.toLocal()}".split(' ')[0], pickedtime.toString());

                  }
/*
                  displayTimePicker(context);
*/
                },
                child: Container(
                  height: widget.height/25,
                  width: widget.width,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child:Text("Re-arranged",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 18),),
                  ),
                ),
              ):const SpinKitCircle(color: AppColors.orange,size: 25,),
            ],
          ),
        ),
      ),
    );
  }
}
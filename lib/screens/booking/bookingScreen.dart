import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import 'package:http/http.dart' as http;

import 'bookingStatus.dart';

class bookingScreen extends StatefulWidget {
  final String restuName,id;
  const bookingScreen({Key? key,required this.restuName,required this.id}) : super(key: key);

  @override
  State<bookingScreen> createState() => _bookingScreenState();
}

class _bookingScreenState extends State<bookingScreen> {
  Future? viewall_experience;

  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.bookingInfo), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      presenttime=userData1['present_time'];
      onehour=userData1['one_hour_time'];
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  bool today=false;
  bool tomorrow=false;
  bool next=false;
  bool rightNow=false;
  bool one=false;
  bool pick=false;
  bool picked=false;
  var occasion;
  var pickedtime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewall_experience = allExperience();
  }
 var sendTime,date;
  var time;
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
        rightNow=false;
        one=false;
        pick=true;
        pickedtime= _timeC.text;

      });
    }
  }
  var day,timeof;
 TextEditingController specialReq=TextEditingController();
  var count = 1;
  List selectedOccasion = [];
  var presenttime,onehour;
  bool submit = false;
  Future boking_submit(String day, String time, String people, String ocasion, String req ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.bookingSend),
    );
    request.fields.addAll({
      'booking_date': day,
      'booking_time': time,
      'person': people,
      'party_type':ocasion,
      'restaurant_id': widget.id,
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
          Get.to(() => bookingStatus(
            bookingId:userData1['restaurant_id'].toString() ,
            bookingdate: userData1['booking_date'],bookingTime: userData1['booking_time'],person: userData1['person'],
            occasion: userData1['party_type'],status:userData1['status'] ,name:userData1['restaurant_info']['name'],
            reservationid:userData1['code'] ,specialreq:userData1['special_request'] ?? '',));
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
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.orange,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              radius: 5,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        title:  Text(
          widget.restuName,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'What Day?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            FutureBuilder(
              future: viewall_experience,
              builder: (_, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      SizedBox(height: size.height/3,),
                      Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                      Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                    ],
                  );                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.height / 10,
                      width: size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap:(){
                                setState(() {
                                  today=true;
                                  tomorrow=false;
                                  next=false;
                                  sendTime=snapshot.data['presentDate'];
                                  print(sendTime);
                                });
                              },
                              child: Container(
                                height: size.height / 10,
                                width: size.width / 4,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),

                                      spreadRadius: 2,

                                      blurRadius: 4,

                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  border: Border.all(color: today==true?Colors.blue:Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Colors.lightBlueAccent,
                                        Colors.white
                                      ]),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Today",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      snapshot.data['presentDay'],
                                      style: const TextStyle(
                                          color: AppColors.bluee,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      snapshot.data['presentDate'],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap:(){
                                setState(() {
                                  today=false;
                                  tomorrow=true;
                                  next=false;
                                  sendTime=snapshot.data['towmorrowDate'];
                                  print(sendTime);
                                });
                              },
                              child: Container(
                                height: size.height / 10,
                                width: size.width / 4,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),

                                      spreadRadius: 2,

                                      blurRadius: 4,

                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  border: Border.all(color: tomorrow==true?Colors.blue:Colors.white),

                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        AppColors.gstart,
                                        Colors.white
                                      ]),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Tomorrow",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      snapshot.data['towmorrowDay'],
                                      style: const TextStyle(
                                          color: AppColors.or,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      snapshot.data['towmorrowDate'],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap:(){
                                setState(() {
                                  today=false;
                                  tomorrow=false;
                                  next=true;
                                  sendTime=snapshot.data['dayAfterTowmorrowDate'];
                                  print(sendTime);
                                });
                              },
                              child: Container(
                                height: size.height / 10,
                                width: size.width / 4,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),

                                      spreadRadius: 2,

                                      blurRadius: 4,

                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  border: Border.all(color: next==true?Colors.blue:Colors.white),

                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        AppColors.g2,
                                        Colors.white
                                      ]),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      snapshot.data['dayAfterTowmorrowDay'],
                                      style: const TextStyle(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      snapshot.data['dayAfterTowmorrowDate'],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text("No Restaurant Found"),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'What Time?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height / 20,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap:(){
                          setState(() {

                            rightNow=true;
                            one=false;
                            pick=false;
                            pickedtime=presenttime;

                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          width: size.width / 4,
                          decoration: BoxDecoration(
                              color: rightNow==true?AppColors.orange:Colors.grey.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10)),
                          child:  Center(
                              child: Text(
                            "Right Now",
                            style: TextStyle(
                                color: rightNow==true?Colors.white:Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          )),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 25,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: InkWell(
                          onTap: (){
                            setState(() {

                              rightNow=false;
                              one=true;
                              pick=false;
                              pickedtime=onehour;


                            });
                          },
                          child: Container(
                            height: size.height / 20,
                            decoration: BoxDecoration(
                                color: one==true?AppColors.orange:Colors.grey.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10)),
                            child:  Center(
                                child: Text(
                              "In 1 Hour",
                              style: TextStyle(
                                  color: one==true?Colors.white:Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            )),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 25,),
                    _timeC.text.isNotEmpty
                        ? Expanded(
                            child: InkWell(
                              onTap: (){
                                setState(() {

                                  rightNow=false;
                                  one=false;
                                  pick=true;

                                });
                                displayTimePicker(context);

                              },
                              child: Container(
                                height: size.height / 20,
                                width: size.width / 4,
                                decoration: BoxDecoration(
                                    color: pick==true?AppColors.orange:Colors.grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  _timeC.text.toString(),
                                  style:  TextStyle(
                                      color: pick==true?Colors.white:Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                )),
                              ),
                            ),
                          )
                        : Expanded(
                          child: InkWell(
                              onTap: () => displayTimePicker(context),
                              child: Container(
                                height: size.height / 20,
                                width: size.width / 4,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Text(
                                  "Pick Time",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                )),
                              ),
                            ),
                        )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: size.width,
                child: Row(
                  children: [
                    Text(
                      'How Many People?',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  count++;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 15,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.orange),
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                              ),
                              child: Center(
                                child: Text(
                                  count.toString(),
                                  style: const TextStyle(
                                      color: AppColors.orange, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                count > 1
                                    ? setState(() {
                                        count--;
                                      })
                                    : null;
                              },
                              child: const CircleAvatar(
                                radius: 15,

                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'What Is the Occasion ?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height / 20,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();
                          setState(() {
                            selectedOccasion.add("Birthday");
                            occasion="Birthday";
                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          decoration: BoxDecoration(
                              color: selectedOccasion.contains("Birthday")
                                  ? AppColors.orange
                                  : Colors.grey.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Birthday",
                            style: TextStyle(
                                color: selectedOccasion.contains("Birthday")
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();

                          setState(() {
                            selectedOccasion.add("Meeting");
                            occasion="Meeting";

                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Container(
                            height: size.height / 20,
                            decoration: BoxDecoration(
                                color: selectedOccasion.contains("Meeting")
                                    ? AppColors.orange
                                    : Colors.grey.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Meeting",
                              style: TextStyle(
                                  color: selectedOccasion.contains("Meeting")
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();

                          setState(() {
                            selectedOccasion.add("Anniversary");
                            occasion="Anniversary";

                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          decoration: BoxDecoration(
                              color: selectedOccasion.contains("Anniversary")
                                  ? AppColors.orange
                                  : Colors.grey.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Anniversary",
                            style: TextStyle(
                                color: selectedOccasion.contains("Anniversary")
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          )),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 25,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height / 20,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();

                          setState(() {
                            selectedOccasion.add("Party");
                            occasion="Party";

                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          decoration: BoxDecoration(
                              color: selectedOccasion.contains("Party")
                                  ? AppColors.orange
                                  : Colors.grey.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Party",
                            style: TextStyle(
                                color: selectedOccasion.contains("Party")
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();

                          setState(() {
                            selectedOccasion.add("New Year");
                            occasion="New Year";

                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Container(
                            height: size.height / 20,
                            decoration: BoxDecoration(
                                color: selectedOccasion.contains("New Year")
                                    ? AppColors.orange
                                    : Colors.grey.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "New Year",
                              style: TextStyle(
                                  color: selectedOccasion.contains("New Year")
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();

                          setState(() {
                            selectedOccasion.add("Marriage");
                            occasion="Marriage";

                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: size.height / 20,
                            decoration: BoxDecoration(
                                color: selectedOccasion.contains("Marriage")
                                    ? AppColors.orange
                                    : Colors.grey.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Marriage",
                              style: TextStyle(
                                  color: selectedOccasion.contains("Marriage")
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOccasion.clear();

                          setState(() {
                            selectedOccasion.add("Celebration");
                            occasion="Celebration";

                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          decoration: BoxDecoration(
                              color: selectedOccasion.contains("Celebration")
                                  ? AppColors.orange
                                  : Colors.grey.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Celebration",
                            style: TextStyle(
                                color: selectedOccasion.contains("Celebration")
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          )),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 25,),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Any Special Request ?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height/6,
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
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        AppColors.ge,
                        Colors.white
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: specialReq,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write here",
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(.5)),
                      border:InputBorder.none
                    ),
                  ),
                ),
              ),
            ),
            Center(child: Text('Privacy Policy , T@C',style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,fontSize: 12,),),),
            submit==false?Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  if(sendTime==null){
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
                  }else if(pickedtime==null){
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
                  }else if(occasion==null){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please select Occasion',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else{
                    setState(() {
                      submit=true;
                    });
                    boking_submit(sendTime, pickedtime, count.toString(), occasion, specialReq.text.isEmpty?'':specialReq.text);
                  }
                  /*setState(() {
                    submit=true;
                  });
                  boking_submit(sendTime, pickedtime, count.toString(), occasion, specialReq.text.isEmpty?'':specialReq.text);*/
                },
                child: Container(
                  height: size.height/20,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.orange,

                  ),child: Center(
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                ),
                ),
              ),
            ):SpinKitCircle(color: AppColors.orange,size: 25,)
          ],
        ),
      ),
    ));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:learning_school_bd/screens/briwse_byfood/view_all_browse_by_food.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/Appurl.dart';
import '../MainHome/resturent_details.dart';
class costFor_single extends StatefulWidget {
  final String id;

  const costFor_single({Key? key,required this.id}) : super(key: key);

  @override
  State<costFor_single> createState() => _costFor_singleState();
}

class _costFor_singleState extends State<costFor_single> {
  Future? resturentViewall;
  Future getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');
    resturentViewall=allExperience(widget.id,locaitonid!,subid!);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Future allExperience(String id,String locationid,String SublocationID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.singlecostFor+id+ "/" + locationid + '/' + SublocationID), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collecteddd' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      setState(() {
        image=AppUrl.pic_url1+userData1[0]['image'];
        result=userData1[0]['restaurant_list'].length;
      });

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  List rest=[];
  var result;
  bool hass=false;
  var image;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: result!=null?result>0?Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [


                Container(
                  height: size.height/4,
                  width: size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              image!=null?image:''
                          ),fit: BoxFit.cover
                      )
                  ),
                ),
                Positioned(
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),),),

              ],
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.height/18,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(height: size.height,width: size.width,);
                            },
                          ).then((value){
                            setState(() {
                              getData();
                            });
                          });
                        },
                        child: Container(
                          height: size.height/18,


                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.orange
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined,color: Colors.white,),
                              Text("Location",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                            ],
                          ),
                        ),
                      ),
                    ),/*SizedBox(width: 4,),
                    Container(
                      height: size.height/18,
                      width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(.2),

                        ),child: Center(
                      child: SvgPicture.asset('assets/images/Filter.svg'),
                    ),
                    )*/
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Resturent Near You",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
            ),
            FutureBuilder(
              future:resturentViewall,
              builder: (_, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      SizedBox(height: size.height/3,),
                      Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                      Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                    ],
                  );                } else if (snapshot.hasData) {
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(


                        itemBuilder: (_,index){
                          return snapshot.data[0]['restaurant_list'][index]['restaurant_info']!=null?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => resturent_details(
                                  id: snapshot.data[0]['restaurant_list'][index]['restaurant_info']['id'].toString(),
                                ));
                              },
                              child: Container(
                                width: size.width ,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),

                                        spreadRadius: 2,

                                        blurRadius: 4,

                                        offset: const Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: size.height / 5,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(AppUrl.pic_url1+snapshot.data[0]['restaurant_list'][index]['extra_info']['profile_image']),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          /* Positioned(
                        top: 10,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(18),
                              color: Colors.white),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Text('4.5'),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellowAccent,
                                ),
                                Text(
                                  '( 100+)',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Positioned(
                        top: 0,
                        right: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white),
                              child: const Icon(
                                Icons.bookmark_border,
                                color: Colors.black,
                              )),
                        )),*/
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                          children: [
                                            Text(
                                              snapshot.data[0]['restaurant_list'][index]['restaurant_info']['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),

                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          snapshot.data[0]['restaurant_list'][index]['extra_info']['address']??'',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ) ,

                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data[0]['restaurant_list'][index]['restaurant_info']['restaurant_type'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Open Now',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                              color: Colors.green),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ):Container();
                        },

                        itemCount: snapshot.data[0]['restaurant_list'].length,
                        shrinkWrap: true,
                      )
                    ],
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
            )

          ],
        ):Column(
          children: [
            SizedBox(height: size.height/2.8,),

            Center(child: Lottie.asset('assets/images/notfound.json',height: 200)),
            Center(child: Text(" No Resturent Found",style: TextStyle(fontSize: 16),),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  height: size.height/18,
                  width: size.width/1.8,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(10),color: AppColors.orange
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Go Back",style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              ),
            )
          ],
        ):Column(
          children: [
            SizedBox(height: size.height/2.8,),
            Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
            Center(child: Text(" Please wait while Loading",style: TextStyle(fontSize: 16),),)
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
  }) : super(key: key);

  final double height;
  final double width;

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

        pickedtime = _timeC.text;
      });
    }
  }

  var day, pickedtime;
  bool submit = false;
  Future? getlocation, sublocation;
  Future location() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.location), headers: requestHeaders);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //     msg: "Bookmarked succesfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black54,
      //     textColor: Colors.white,
      //     fontSize: 16.0);

      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      /*
              name= userData1['basicInfo']['name'];
        */
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Future subLocation(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.sub_location + id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //     msg: "Bookmarked succesfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black54,
      //     textColor: Colors.white,
      //     fontSize: 16.0);

      print('Get post collected sub' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      /*
              name= userData1['basicInfo']['name'];
        */
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  var loc, locid, subloc, sublocid;
  Future? myFuture, group_;
  var val;
  String? _mySelection, group_selection, selection;
  List shots = [];
  var _myJson;
  var section_name;
  var Section_id;
  var groupa_id;
  var group_name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation = location();
  }

/*
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
*/
/*
          Get.to(() => bookingStatus(

            bookingId:userData1['restaurant_id'].toString() ,
            bookingdate: userData1['booking_date'],bookingTime: userData1['booking_time'],person: userData1['person'],
            occasion: userData1['party_type'],status:userData1['status'] ,name:userData1['restaurant_info']['name'],
            reservationid:userData1['code'] ,specialreq:userData1['special_request'] ?? '',));
*/ /*

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
*/
  setlocation(String location,String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locaiton", location);
    prefs.setString("locaitonid", id);
  }

  setSublocation(String location,String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sub_locaiton", location);
    prefs.setString("sub_locaitonid", id);
  }

  var select_locaiton;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: widget.height * 0.7,
        width: widget.width * 0.98,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Lottie.asset("assets/images/location.json"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: widget.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all()),
                    child: Center(
                      child: FutureBuilder(
                          future: getlocation!,
                          builder: (context, snapshot) {
                            print(snapshot.data.toString());
                            shots = (snapshot.data ?? []) as List;
                            if (snapshot.hasData) {
                              return shots != null
                                  ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange
                                ),

                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(10),
                                  isExpanded: true,
                                  dropdownColor: Colors.orange,
                                  hint: _mySelection == null
                                      ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on,color: Colors.white,),
                                        Text("Select Location",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on,color: Colors.white,),


                                        Text(loc!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  items: shots
                                      .map<DropdownMenuItem<String>>(
                                          (value) =>
                                          DropdownMenuItem<String>(
                                            value: value["id"]
                                                .toString() +
                                                "_" +
                                                value['name'],
                                            child: Text(
                                              value['name'],
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _mySelection = value;
                                      val = _mySelection!.split('_');
                                      print(val[0] + " NEw value");
                                      print(val[1] + " class value");
                                      loc = val[1];
                                      locid = val[0];
                                      setlocation(loc,locid);
                                    });
                                    print(_mySelection);
                                    sublocation =
                                        subLocation(locid.toString());


                                    /* get_s = get_sectioon(
                                        class_id
                                            .toString());*/
                                  },
                                  underline: DropdownButtonHideUnderline(
                                      child: Container()),
                                ),
                              )
                                  : SpinKitThreeInOut(
                                color: Colors.white,
                                size: 10,
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ),
                ),
                _mySelection != null
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: widget.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all()),
                    child: Center(
                      child: FutureBuilder(
                          future: sublocation!,
                          builder: (context, snapshot) {
                            print(snapshot.data.toString());
                            shots = (snapshot.data ?? []) as List;
                            if (snapshot.hasData) {
                              return shots != null
                                  ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange
                                ),
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(10),
                                  isExpanded: true,
                                  dropdownColor: Colors.orange,
                                  hint: selection == null
                                      ? Row(
                                    children: [
                                      Icon(Icons.location_on,color: Colors.white,),

                                      Text("Select Area",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      Icon(Icons.location_on,color: Colors.white,),

                                      Text(subloc!,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  items: shots
                                      .map<
                                      DropdownMenuItem<
                                          String>>((value) =>
                                      DropdownMenuItem<String>(
                                        value: value["id"]
                                            .toString() +
                                            "_" +
                                            value['name'],
                                        child: Text(
                                          value['name'],
                                        ),
                                      ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selection = value;
                                      val = selection!.split('_');
                                      print(val[0] + " NEw value");
                                      print(
                                          val[1] + " class value");
                                      subloc = val[1];

                                      sublocid = val[0];
                                      setSublocation(subloc,sublocid);
                                      Get.back();


                                    });
                                    /* get_s = get_sectioon(
                                        class_id
                                            .toString());*/
                                  },
                                  underline:
                                  DropdownButtonHideUnderline(
                                      child: Container()),
                                ),
                              )
                                  : SpinKitThreeInOut(
                                color: Colors.white,
                                size: 10,
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ),
                )
                    : Container(),
                /* // InkWell(
                //   onTap: () {
                //     Get.to(() => Main_home());
                //   },
                //   child: Container(
                //     height: widget.height / 25,
                //     width: widget.width,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: AppColors.orange),
                //   ),
                // )*/
              ],
            )),
      ),
    );
  }
}
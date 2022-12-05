import 'dart:async';
import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../screens/MainHome/Main-Home.dart';
import '../screens/MainHome/resturent_details.dart';
import 'Appurl.dart';
import 'colors.dart';

class set_locaiton extends StatefulWidget {
  const set_locaiton({Key? key}) : super(key: key);

  @override
  State<set_locaiton> createState() => _set_locaitonState();
}

class _set_locaitonState extends State<set_locaiton> {
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
  Future? myfuture;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.searchlocation+'0'), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  TextEditingController _controller = TextEditingController();

  StreamController? _streamController;
  Stream? _stream;

  Timer? _debounce;

  _search() async {
    if (_controller.text.isEmpty) {
      _streamController!.add(null);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {'authorization': "Bearer $token"};

    String controller = _controller.text.trim();
    _streamController!.add("waiting");
    Response response =
    await get(Uri.parse(AppUrl.searchlocation + controller), headers: requestHeaders);
    _streamController!.add(json.decode(response.body)['data']);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=getpost();


    _streamController = StreamController();
    _stream = _streamController!.stream;
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
  setlocation(String location, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locaiton", location);
    prefs.setString("locaitonid", id);
  }

  setSublocation(String location, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sub_locaiton", location);
    prefs.setString("sub_locaitonid", id);
  }

  var select_locaiton;
  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("assets/images/location.json"),

            SizedBox(
              height: 25,
            ),
            Center(
                child: Text(
                  "Set your location to start ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 22),
                )),
            Center(
                child: Text(
                  "exploring restaurants near you",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                )),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: (){
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    elevation: 10,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(

                          builder: (context, setState) {
                            myfuture=getpost();


                            _streamController = StreamController();
                            _stream = _streamController!.stream;
                            return SingleChildScrollView(
                              child:                     Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: size.height/1.3,
                                  width: size.width,
                                  child: Container(
                                    decoration: BoxDecoration(

                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 30,),                                        Padding(
                                          padding: const EdgeInsets.only(left:28.0,right: 28),
                                          child: TextFormField(
                                            controller: _controller,
                                            onChanged: (String text) {
                                              if (_debounce?.isActive ?? false) _debounce!.cancel();
                                              _debounce = Timer(const Duration(milliseconds: 1000), () {
                                                _search();
                                              });
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                              hintText: "Search by restaurants name",


                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8.0),
                                            child: StreamBuilder(
                                              stream: _stream,
                                              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                                                if (snapshot.data == null) {
                                                  return  Container(
                                                      constraints: BoxConstraints(),
                                                      child: FutureBuilder(
                                                          future: myfuture,
                                                          builder: (_, AsyncSnapshot snapshot) {
                                                            print(snapshot.data);
                                                            switch (snapshot.connectionState) {
                                                              case ConnectionState.waiting:
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(height: size.height/3,),
                                                                    Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                                                                    Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                                                                  ],
                                                                );
                                                              default:
                                                                if (snapshot.hasError) {
                                                                  Text('Error: ${snapshot.error}');
                                                                } else {
                                                                  return snapshot.hasData
                                                                      ?                                    Padding(
                                                                    padding: const EdgeInsets.all(10.0),
                                                                    child:             Container(
                                                                      height: size.height/3,
                                                                      child: ListView.builder(

                                                                          shrinkWrap: true,
                                                                          itemCount: snapshot.data.length,
                                                                          itemBuilder: (_,index){

                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: ExpandablePanel(
                                                                                header: Row(
                                                                                  children: [
                                                                                    Icon(Icons.location_on),
                                                                                    Text(snapshot.data[index]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                                                                  ],
                                                                                ),
                                                                                collapsed: Padding(
                                                                                  padding: const EdgeInsets.only(left: 18.0),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text("Click to select area under ", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                                                      Text(snapshot.data[index]['name'], softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                expanded: Padding(
                                                                                  padding: const EdgeInsets.only(left: 18.0),
                                                                                  child: Container(

                                                                                    width: size.width,
                                                                                    child: ListView.builder(

                                                                                        itemCount: snapshot.data[index]['sub_location'].length,
                                                                                        shrinkWrap: true,
                                                                                        itemBuilder: (_,index2){


                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: InkWell(
                                                                                          onTap: (){
                                                                                            print(snapshot.data[index]['sub_location'][index2]['name']);
                                                                                            print(snapshot.data[index]['sub_location'][index2]['id']);
                                                                                            print(snapshot.data[index]['sub_location'][index2]['location_id']);
                                                                                            setlocation(snapshot.data[index]['name'],snapshot.data[index]['sub_location'][index2]['location_id'].toString());
                                                                                            setSublocation(snapshot.data[index]['sub_location'][index2]['name'],snapshot.data[index]['sub_location'][index2]['id'].toString());
                                                                                            Get.to(()=>Main_home());

                                                                                          },
                                                                                          child: Container(
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Icon(Icons.location_on_outlined),
                                                                                                Text(snapshot.data[index]['sub_location'][index2]['name']),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }),
                                                                                  ),
                                                                                )

                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),

                                                                  )



                                                                      : Text('No data');
                                                                }
                                                            }
                                                            return CircularProgressIndicator();
                                                          }));
                                                }

                                                if (snapshot.data == "waiting") {
                                                  return Column(
                                                    children: [
                                                      SizedBox(height: size.height/3,),
                                                      Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                                                      Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                                                    ],
                                                  );                     }

                                                return      Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child:             Container(
                                                    height: size.height/3,
                                                    child: ListView.builder(

                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data.length,
                                                        itemBuilder: (_,index){

                                                          return Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: ExpandablePanel(
                                                                header: Row(
                                                                  children: [
                                                                    Icon(Icons.location_on),
                                                                    Text(snapshot.data[index]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                                                  ],
                                                                ),
                                                                collapsed: Padding(
                                                                  padding: const EdgeInsets.only(left: 18.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text("Click to select area under ", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                                      Text(snapshot.data[index]['name'], softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),

                                                                    ],
                                                                  ),
                                                                ),
                                                                expanded: Padding(
                                                                  padding: const EdgeInsets.only(left: 18.0),
                                                                  child: Container(

                                                                    width: size.width,
                                                                    child: ListView.builder(

                                                                        itemCount: snapshot.data[index]['sub_location'].length,
                                                                        shrinkWrap: true,
                                                                        itemBuilder: (_,index2){


                                                                          return Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: InkWell(
                                                                              onTap: (){
                                                                                print(snapshot.data[index]['sub_location'][index2]['name']);
                                                                                print(snapshot.data[index]['sub_location'][index2]['id']);
                                                                                print(snapshot.data[index]['sub_location'][index2]['location_id']);
                                                                                setlocation(snapshot.data[index]['name'],snapshot.data[index]['sub_location'][index2]['location_id'].toString());
                                                                                setSublocation(snapshot.data[index]['sub_location'][index2]['name'],snapshot.data[index]['sub_location'][index2]['id'.toString()]);
                                                                                Get.to(()=>Main_home());

                                                                              },
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.location_on_outlined),
                                                                                    Text(snapshot.data[index]['sub_location'][index2]['name']),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                )

                                                            ),
                                                          );
                                                        }),
                                                  ),

                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            );
                          });
                    });
              },
              child: Container(
                height: size.height / 18,
                width: size.width / 1.2,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Center(
                  child: Text('Enter Location Manually',style: TextStyle(
                      color: Colors.white,fontWeight: FontWeight.w600
                  ),),
                ),
              ),
            )

/*
            SizedBox(
              width: size.width * 0.98,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Select location from here"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width,
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
                                            child: DropdownButton<String>(
                                              hint: _mySelection == null
                                                  ? Text("Select Location",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey))
                                                  : Text(loc!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey)),
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
                                                  _mySelection = value;
                                                  val =
                                                      _mySelection!.split('_');
                                                  print(val[0] + " NEw value");
                                                  print(
                                                      val[1] + " class value");
                                                  loc = val[1];
                                                  locid = val[0];
                                                  setlocation(loc,locid);
                                                });
                                                print(_mySelection);
                                                sublocation = subLocation(
                                                    locid.toString());

                                                */
/* get_s = get_sectioon(
                                        class_id
                                            .toString());*/ /*

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
                      ),
                      _mySelection != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width,
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
                                                  child: DropdownButton<String>(
                                                    hint: selection == null
                                                        ? Text(
                                                            "Select Sub Location",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey))
                                                        : Text(subloc!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey)),
                                                    items: shots
                                                        .map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (value) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value: value[
                                                                              "id"]
                                                                          .toString() +
                                                                      "_" +
                                                                      value[
                                                                          'name'],
                                                                  child: Text(
                                                                    value[
                                                                        'name'],
                                                                  ),
                                                                ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selection = value;
                                                        val = selection!
                                                            .split('_');
                                                        print(val[0] +
                                                            " NEw value");
                                                        print(val[1] +
                                                            " class value");
                                                        subloc = val[1];

                                                        sublocid = val[0];
                                                        setSublocation(subloc,sublocid);
                                                      });
                                                      */
/* get_s = get_sectioon(
                                        class_id
                                            .toString());*/ /*

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
                    _mySelection!=null?Column(
                      children: [
                        SizedBox(
                          height: size.height / 10,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => Main_home());
                          },
                          child: Container(
                            height: size.height / 18,
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.orange),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        )
                      ],
                    ):Container()
                    ],
                  )),
            ),
*/
          ],
        )
     /*   loaded == true
            ? Column(
                children: [
                  Lottie.asset("assets/images/location.json"),
                  Center(
                      child: Text(
                    "We Don't have your Location!!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                      child: Text(
                    "Set your location to start exploring",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  )),
                  Center(
                      child: Text(
                    "Restaurants near you",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: (){
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          elevation: 10,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return SingleChildScrollView(
                                    child:                     Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: size.height,
                                        width: size.width,
                                        child: Container(
                                          decoration: BoxDecoration(

                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:28.0,right: 28),
                                                child: TextFormField(
                                                  controller: _controller,
                                                  onChanged: (String text) {
                                                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                                                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                                                      _search();
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                                                    border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                                    hintText: "Search by restaurants name",


                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.all(8.0),
                                                  child: StreamBuilder(
                                                    stream: _stream,
                                                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                                                      if (snapshot.data == null) {
                                                        return  Container(
                                                            constraints: BoxConstraints(),
                                                            child: FutureBuilder(
                                                                future: myfuture,
                                                                builder: (_, AsyncSnapshot snapshot) {
                                                                  print(snapshot.data);
                                                                  switch (snapshot.connectionState) {
                                                                    case ConnectionState.waiting:
                                                                      return Column(
                                                                        children: [
                                                                          SizedBox(height: size.height/3,),
                                                                          Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                                                                          Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                                                                        ],
                                                                      );
                                                                    default:
                                                                      if (snapshot.hasError) {
                                                                        Text('Error: ${snapshot.error}');
                                                                      } else {
                                                                        return snapshot.hasData
                                                                            ?                                    Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child:             Container(
                                                                            height: size.height/1.2,
                                                                            child: ListView.builder(

                                                                                shrinkWrap: true,
                                                                                itemCount: snapshot.data.length,
                                                                                itemBuilder: (_,index){

                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        Get.to(() => resturent_details(
                                                                                          id: snapshot.data[index]['id'].toString(),
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
                                                                                                          image: NetworkImage(AppUrl.pic_url1+snapshot.data[index]['extra_info']['profile_image']),
                                                                                                          fit: BoxFit.cover,
                                                                                                        )),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      snapshot.data[index]['name'],
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
                                                                                                  snapshot.data[index]['extra_info']['address']??'',
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
                                                                                                      snapshot.data[index]['restaurant_type'],
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
                                                                                  );
                                                                                }),
                                                                          ),

                                                                        )



                                                                            : Text('No data');
                                                                      }
                                                                  }
                                                                  return CircularProgressIndicator();
                                                                }));
                                                      }

                                                      if (snapshot.data == "waiting") {
                                                        return Column(
                                                          children: [
                                                            SizedBox(height: size.height/3,),
                                                            Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                                                            Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                                                          ],
                                                        );                     }

                                                      return    Container(
                                                        height: size.height/1.4,
                                                        child: ListView.builder(

                                                            shrinkWrap: true,
                                                            itemCount: snapshot.data.length,
                                                            itemBuilder: (_,index){

                                                              return   Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Get.to(() => resturent_details(
                                                                      id: snapshot.data[index]['id'].toString(),
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
                                                                                      image: NetworkImage(AppUrl.pic_url1+snapshot.data[index]['extra_info']['profile_image']),
                                                                                      fit: BoxFit.cover,
                                                                                    )),
                                                                              ),
                                                                              *//* Positioned(
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
                          )),*//*
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Row(
                                                                              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                                                              children: [
                                                                                Text(
                                                                                  snapshot.data[index]['name'],
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
                                                                              snapshot.data[index]['extra_info']['address']??'',
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
                                                                                  snapshot.data[index]['restaurant_type'],
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
                                                              );
                                                            }),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  );
                                });
                          });
                    },
                    child: Container(
                      height: size.height / 18,
                      width: size.width / 1.2,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: Center(
                        child: Text('Enter Location Manually',style: TextStyle(
                          color: Colors.white,fontWeight: FontWeight.w600
                        ),),
                      ),
                    ),
                  )

*//*
            SizedBox(
              width: size.width * 0.98,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Select location from here"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width,
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
                                            child: DropdownButton<String>(
                                              hint: _mySelection == null
                                                  ? Text("Select Location",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey))
                                                  : Text(loc!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey)),
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
                                                  _mySelection = value;
                                                  val =
                                                      _mySelection!.split('_');
                                                  print(val[0] + " NEw value");
                                                  print(
                                                      val[1] + " class value");
                                                  loc = val[1];
                                                  locid = val[0];
                                                  setlocation(loc,locid);
                                                });
                                                print(_mySelection);
                                                sublocation = subLocation(
                                                    locid.toString());

                                                *//*
*//* get_s = get_sectioon(
                                        class_id
                                            .toString());*//* *//*

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
                      ),
                      _mySelection != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width,
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
                                                  child: DropdownButton<String>(
                                                    hint: selection == null
                                                        ? Text(
                                                            "Select Sub Location",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey))
                                                        : Text(subloc!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey)),
                                                    items: shots
                                                        .map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (value) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value: value[
                                                                              "id"]
                                                                          .toString() +
                                                                      "_" +
                                                                      value[
                                                                          'name'],
                                                                  child: Text(
                                                                    value[
                                                                        'name'],
                                                                  ),
                                                                ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selection = value;
                                                        val = selection!
                                                            .split('_');
                                                        print(val[0] +
                                                            " NEw value");
                                                        print(val[1] +
                                                            " class value");
                                                        subloc = val[1];

                                                        sublocid = val[0];
                                                        setSublocation(subloc,sublocid);
                                                      });
                                                      *//*
*//* get_s = get_sectioon(
                                        class_id
                                            .toString());*//* *//*

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
                    _mySelection!=null?Column(
                      children: [
                        SizedBox(
                          height: size.height / 10,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => Main_home());
                          },
                          child: Container(
                            height: size.height / 18,
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.orange),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        )
                      ],
                    ):Container()
                    ],
                  )),
            ),
*//*
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: size.height / 2.5,
                  ),
                  SpinKitCircle(
                    color: AppColors.orange,
                    size: 30,
                  ),
                  Center(
                    child: Text("Loading Location Please wait..."),
                  )
                ],
              ),*/
      ),
    ));
  }
}

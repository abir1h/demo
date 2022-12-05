import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import '../booking/bookingDetails.dart';
import '../splash/onboarding_page.dart';
import 'package:http/http.dart'as http;
class booking extends StatefulWidget {
  const booking({Key? key}) : super(key: key);

  @override
  State<booking> createState() => _bookingState();
}

class _bookingState extends State<booking> {
  Future? viewall_experience;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.bookingShow), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewall_experience=allExperience();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.orange, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        centerTitle: true,
        backgroundColor: AppColors.orange,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              // setState(() {
              //   dashboard = getpost();
              // });
              // Get.to(() => const reg());
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/images/Menu.svg',
                height: 25,
                width: 25,
              ),
            ),
          ),
        ),
        title: const Text(
          "Booking",
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
      body: FutureBuilder(
        future: viewall_experience,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(height: size.height/3,),
                Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
              ],
            );          } else if (snapshot.hasData) {
            return  ListView.builder(


              itemBuilder: (_,index){

                return   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: size.width,
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data[index]['booking_date']+" , ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14),
                                      ),Text(
                                        snapshot.data[index]['booking_time'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize:12),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Icon(Icons.group,color: AppColors.orange,size: 15,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data[index]['person'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12),
                                      ),
                                    ),                            ],)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0,left: 8),
                                                child: Text(
                                                  snapshot.data[index]['restaurant_info']['name'],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0),
                                            child: Dash(
                                                direction: Axis.vertical,
                                                length: 15,
                                                dashLength: 1,
                                                dashColor: Colors.grey),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.deepOrangeAccent),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8,bottom: 8),
                                                child: Text(
                                                  snapshot.data[index]['party_type'],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data[index]['status'].toString().toUpperCase(),
                                      style: TextStyle(color: snapshot.data[index]['status']=="Accepted"?Colors.green:snapshot.data[index]['status']=="Canceled"?Colors.red:AppColors.orange,fontWeight: FontWeight.w700),),
                                  )
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                children: [
                                  Icon(Icons.book,color: Colors.grey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                     "#"+ snapshot.data[index]['code'],
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              InkWell(
                                onTap: (){
                                  Get.to(() => bookingDetails(
                                    resturent_id:snapshot.data[index]['restaurant_info']['id'].toString(),

                                    gesttime1: snapshot.data[index]['guest_propose_datetime_1'] ?? 't',
                                    gusttime2: snapshot.data[index]['guest_propose_datetime_2'] ?? 't',
                                    restTime1: snapshot.data[index]['restaurant_propose_datetime_1'] ?? 't',
                                    restTime2: snapshot.data[index]['restaurant_propose_datetime_2'] ?? 't',
                                    bookingid:snapshot.data[index]['id'].toString() ,
                                    bookingdate: snapshot.data[index]['booking_date'],bookingTime: snapshot.data[index]['booking_time'],person: snapshot.data[index]['person'],
                                    occasion: snapshot.data[index]['party_type'],status:snapshot.data[index]['status'] ,name:snapshot.data[index]['restaurant_info']['name'],
                                    reservationid:snapshot.data[index]['code'] ,specialreq:snapshot.data[index]['special_request'] ?? '',phone:snapshot.data[index]['restaurant_info']['username'] ,));
                                },
                                child: Container(
                                  height: size.height/35,
                                  width: size.width,
                                  decoration: BoxDecoration(

                                  ),child: Text("Order Details".toUpperCase(),style: TextStyle(color:AppColors.orange,fontWeight: FontWeight.w700),),
                                ),
                              ),                      ]),
                      )),
                );

              },

              itemCount: snapshot.data.length,
              shrinkWrap: true,
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
    ));
  }
}

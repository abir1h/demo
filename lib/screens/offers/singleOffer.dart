import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/briwse_byfood/view_all_browse_by_food.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/Appurl.dart';
import '../MainHome/resturent_details.dart';

class singleOffer extends StatefulWidget {
  final String id,discount_type,upto,location,start,end;

  const singleOffer({Key? key, required this.id, required this.discount_type, required this.upto, required this.location, required this.start, required this.end}) : super(key: key);

  @override
  State<singleOffer> createState() => _singleOfferState();
}

class _singleOfferState extends State<singleOffer> {
  Future? resturentViewall;
  Future allsingleexperience(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(AppUrl.singleOffer + widget.discount_type+'/'+widget.upto+'/'+widget.location+'/'+widget.start+'/'+widget.end),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collectedd' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      userData1.length>0? setState(() {
        image = AppUrl.pic_url1 + userData1[0]['restaurant_list'][0]['extra_info']['profile_image'];
        result=userData1[0]['restaurant_list'].length;

      }): setState(() {
        result=0;

      });

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var result;

  var image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resturentViewall = allsingleexperience(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child:  result!=null?result>0?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: size.height / 4,
                      width: size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(image != null ? image : ''),
                              fit: BoxFit.cover)),
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
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height / 18,
                    width: size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: size.height / 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.orange),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                       /* SizedBox(
                          width: 4,
                        ),
                        Container(
                          height: size.height / 18,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(.2),
                          ),
                          child: Center(
                            child: SvgPicture.asset('assets/images/Filter.svg'),
                          ),
                        )*/
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Resturent Near You",
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
                FutureBuilder(
                  future: resturentViewall,
                  builder: (_, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: size.height,
                        width: size.width,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey.shade200,
                                child: Container(
                                  height: 150,
                                  width: size.width,
                                  margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    // color: appColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    // Get.to(() => resturent_details(
                                    //   id: '2',
                                    // ));
                                    Get.to(() => resturent_details(
                                      id: snapshot.data[0]
                                      ['restaurant_list'][index]
                                      ['restaurant_info']['id']
                                          .toString(),
                                    ));
                                  },
                                  child: Container(
                                    width: size.width,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.grey.withOpacity(0.5),

                                            spreadRadius: 2,

                                            blurRadius: 4,

                                            offset: const Offset(0,
                                                5), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: size.height / 5,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(AppUrl
                                                          .pic_url1 +
                                                          snapshot.data[0][
                                                          'restaurant_list']
                                                          [index][
                                                          'extra_info']
                                                          [
                                                          'profile_image']),
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
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data[0][
                                                  'restaurant_list']
                                                  [index]['name'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
/*
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(18),
                                                      color: Colors.grey
                                                          .withOpacity(.2)),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: Row(
                                                      children: const [
                                                        Text('4.5'),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        Text(
                                                          '( 100+)',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
*/
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              snapshot.data[0][
                                              'restaurant_list']
                                              [index]['extra_info']['address']??'',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data[0][
                                                  'restaurant_list']
                                                  [index]

                                                  ['restaurant_type'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Colors.orange),
                                                ),

                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                            EdgeInsets.only(left: 8.0),
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

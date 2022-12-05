import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import '../rating/Rating.dart';
import 'package:http/http.dart'as http;

class all_reviews extends StatefulWidget {
  final String id;
  const all_reviews({Key? key,required this.id}) : super(key: key);

  @override
  State<all_reviews> createState() => _all_reviewsState();
}

class _all_reviewsState extends State<all_reviews> {
  Future? dashboard;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.reviewAll + widget.id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
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
  @override
  void initState() {
    super.initState();
    dashboard = getpost();

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
        title: const Text(
          "All  Ratings & Reviews",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
         /* Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )*/
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: size.height,
            width: size.width,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
/*
               InkWell(
                 onTap: (){
*/
/*
                   Get.to(()=>Rating());
*//*

                 },
                 child: Column(
                   children: [
                     const Padding(
                       padding: EdgeInsets.all(8.0),
                       child: Text(
                         "Rate Your Experience",
                         style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: 16),
                       ),
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: const [
                         Icon(
                           Icons.star_border_rounded,
                           color: Colors.amberAccent,
                           size: 50,
                         ),
                         Icon(
                           Icons.star_border_rounded,
                           color: Colors.amberAccent,
                           size: 50,
                         ),
                         Icon(
                           Icons.star_border_rounded,
                           color: Colors.amberAccent,
                           size: 50,
                         ),
                         Icon(
                           Icons.star_border_rounded,
                           color: Colors.amberAccent,
                           size: 50,
                         ),
                         Icon(
                           Icons.star_border_rounded,
                           color: Colors.amberAccent,
                           size: 50,
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
*/
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reviews",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: dashboard,
                    builder: (_, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasData) {
                        return ListView.builder(itemBuilder: (_,index){return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),

                                  spreadRadius: 2,

                                  blurRadius: 4,

                                  offset: const Offset(0,
                                      0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        child: Lottie.asset('assets/images/profile.json',fit: BoxFit.cover),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[index]['user']['name'].toString(),
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                            BorderRadius.circular(
                                                18)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children:  [
                                            Text(
                                              snapshot.data[index]['overall_rating'],
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color:
                                                  Colors.white),
                                            ),
                                            Icon(Icons.star,
                                                color: Colors.yellow)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                snapshot.data[index]['review_details']!=null?  Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data[index]['review_details'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ):Container(),
                                /* const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Read more",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                    ),*/

                                Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: size.height / 10,
                                    width: size.width ,
                                    decoration:
                                    const BoxDecoration(),
                                    child: Column(
                                      children: [
                                        Container(
                                          height:
                                          size.height / 10,
                                          width: size.width ,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      AppUrl.pic_url1+snapshot.data[index]['image']),
                                                  fit: BoxFit
                                                      .cover)),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(5.0),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                                        //       Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 5.0,right: 5),
                                        //   child: Row(
                                        //     children: [
                                        //       Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
                                        //       Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                )
/*
                                                    SizedBox(
                                                      height: size.height / 8,
                                                      width: size.width,
                                                      child: ListView.builder(
                                                        itemBuilder: (_, index) {
                                                          return Padding(
                                                            padding:
                                                            const EdgeInsets.all(8.0),
                                                            child: Container(
                                                              height: size.height / 10,
                                                              width: size.width / 3,
                                                              decoration:
                                                              const BoxDecoration(),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                    size.height / 10,
                                                                    width: size.width / 3,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        image: DecorationImage(
                                                                            image: AssetImage(
                                                                                sliderList[
                                                                                index]),
                                                                            fit: BoxFit
                                                                                .cover)),
                                                                  ),
                                                                  // Padding(
                                                                  //   padding: const EdgeInsets.all(5.0),
                                                                  //   child: Row(
                                                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  //     children: [
                                                                  //       Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                                                                  //       Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                                                                  //     ],
                                                                  //   ),
                                                                  // ),
                                                                  // Padding(
                                                                  //   padding: const EdgeInsets.only(left: 5.0,right: 5),
                                                                  //   child: Row(
                                                                  //     children: [
                                                                  //       Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
                                                                  //       Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
                                                                  //     ],
                                                                  //   ),
                                                                  // )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        shrinkWrap: true,
                                                        itemCount: 3,
                                                        scrollDirection: Axis.horizontal,
                                                      ),
                                                    ),
*/
                              ],
                            ),
                          ),
                        );},itemCount: snapshot.data.length,shrinkWrap: true,);
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Center(
                              child: Text("No Review Found"),
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
                )
              ],
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: widget.height * 0.7,
        width: widget.width * 0.98,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: widget.height / 7,
                    width: widget.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      color: AppColors.offers,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Flat",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: widget.width / 6,
                                    ),
                                    const Text(
                                      "5%",
                                      style: TextStyle(
                                          color: AppColors.orange,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "off",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Offer Available : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "From ",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "01/02/2022",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "To ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "01/02/2022",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Details :",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nunc nec ultricies dictum blandit nisi netus posuere in. Tortor nibh dignissim in ipsum, scelerisque. Ut est pellentesque tortor ut amet. Dictum nibh ornare hac nisl volutpat id sit feugiat.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Terms & Conditions : lorem ipsum dolor tiamat amor ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: AppColors.orange,
                        ),
                        Text(
                          "Previous Offer",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          "View Next Offer",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

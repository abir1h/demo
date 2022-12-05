import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/rating/Rating.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/Appurl.dart';
class billing extends StatefulWidget {

  @override
  State<billing> createState() => _billingState();
}

class _billingState extends State<billing> {
  Future? viewall_experience;

  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.billing), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'][0];
      setState(() {
        booking_id=userData1['bill']['booking_id'];
      });

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future review_skip(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.ratingSkip+id), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);

    } else {
      print("post have no Data${response.body}");
    }
  }

   var booking_id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewall_experience=allExperience();
  }
  bool expanded=false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: ()async{
        review_skip(booking_id.toString());
        return false;
      },
      child: SafeArea(child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              review_skip(booking_id.toString());

              Get.back();
            },
          ),
          centerTitle: true,
          title: Row(
            children: [
               Text("Billing Information",style: TextStyle(
                  color:AppColors.orange,fontSize: 14,fontWeight: FontWeight.w400
              ),),

            ],
          ),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: viewall_experience,
                builder: (_, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: size.height / 10,
                      width: size.width,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
                    return             Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: Text('To be Added ',style: TextStyle(
                                        color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                                    )),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Total Bill : ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                          Text(snapshot.data['bill']['total_bill'].toString()+' Tk ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                        ],
                                      ), Row(
                                        children: [
                                          Text('Discounted Bill : ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                          Text(snapshot.data['bill']['discount_bill'].toString()+' Tk ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                        ],
                                      ),Row(
                                        children: [
                                          Text('Advanced Paid : ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                          Text(snapshot.data['bill']['advance_bill'].toString()+' Tk ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                        ],
                                      ),Row(
                                        children: [
                                          Text('Total Amount Left : ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                          Text(snapshot.data['bill']['left_amount_bill'].toString()+' Tk ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                                // Center(child: Lottie.asset('assets/images/progress.json',height: size.height/8,)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(snapshot.data['user']['name']+" You have to",style: TextStyle(
                                        color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                                    )),
                                  ),
                                ),Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text('Pay',style: TextStyle(
                                        color:Colors.black,fontSize: 20,fontWeight: FontWeight.w500
                                    )),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: size.height/15,
                                    width: size.width/2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.orange)
                                    ),child: Center(
                                    child: Text(snapshot.data['bill']['total_bill']+' tk',style: TextStyle(
                                        fontSize: 18,fontWeight: FontWeight.w700,color: AppColors.orange
                                    ),),
                                  ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Center(
                                  child: InkWell(
                                    onTap:(){
                  review_skip(booking_id.toString());

                  Get.to(()=>Rating(id: booking_id.toString(),));
                                    },
                                    child: Container(
                                      height: size.height/18,
                                      width: size.width/1.5,
                                      decoration: BoxDecoration(
                                          color: AppColors.orange,
                                          borderRadius: BorderRadius.circular(10)
                                      ),child: Center(
                                      child: Text('Leave Us a Review',style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Center(
                                  child: Text("Or",style: TextStyle(
                                    color: Colors.black,fontWeight: FontWeight.w700,

                                  ),),
                                ),
                                SizedBox(height: 10,),
                                Center(
                                  child: InkWell(
                                    onTap:(){
                                      review_skip(booking_id.toString());
                                      Get.back();

                                    },
                                    child: Text("Skip",style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.orange,fontWeight: FontWeight.w700,

                                    ),),
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
                                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
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
                                        Text(snapshot.data['restaurant_info']['name'],style: TextStyle(
                                            color:Colors.black,fontSize: 12,fontWeight: FontWeight.w800
                                        )),
                                        Container(
                                          width: size.width/2,

                                          child: Row(

                                            children: [
                                              Text('Number of Guest',style: TextStyle(
                                                  color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                              )),Text(': '+snapshot.data['person'],style: TextStyle(
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
                                              )),Text(':  '+snapshot.data['party_type'],style: TextStyle(
                                                  color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                              )),
                                            ],
                                          ),
                                        ), Container(
                                          width: size.width/2,

                                          child: Row(
                                            children: [
                                              Text('Special Req :   ',style: TextStyle(
                                                  color:Colors.black,fontSize: 12,fontWeight: FontWeight.w500
                                              )),Text(snapshot.data['special_request']??"",style: TextStyle(
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
                                              )),Text(':  #'+snapshot.data['code'],style: TextStyle(
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
                                              )),Text(':  '+snapshot.data['booking_date'],style: TextStyle(
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
                                              )),Text(':  '+snapshot.data['booking_time'],style: TextStyle(
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
                               /* Center(child: Text(
                                    'Cancel Reservation',style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color:AppColors.orange,fontSize: 16,fontWeight: FontWeight.w600
                                )
                                ),),
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Call Gosy for help :15451',style: TextStyle(
                                      color:Colors.grey.withOpacity(.5),fontSize: 12,fontWeight: FontWeight.w400
                                  )
                                  ),
                                ),)*/


                              ],
                            ),
                          ),
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
              ),
            ],
          ),
        ),

      )),
    );
  }
}

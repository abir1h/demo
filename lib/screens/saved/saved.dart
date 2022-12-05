import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
class saved extends StatefulWidget {

  @override
  State<saved> createState() => _savedState();
}

class _savedState extends State<saved> {
  Future? resturentViewall;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.saved), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future bookmark(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.bookmark +id),
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

      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      /*
              name= userData1['basicInfo']['name'];
        */
      setState(() {
        resturentViewall=allExperience();

      });
      print(userData1);
      return userData1;
    } else {

      print("post have no Data${response.body}");
    }
  }

  var image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resturentViewall=allExperience();
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
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
          "Saved",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
        /*  Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )*/
        ],
      ),

      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
                          return snapshot.data[index]['restaurant_info']!=null?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => resturent_details(
                                  id: snapshot.data[index]['restaurant_info']['id'].toString(),
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

                    Positioned(
                        top: 10,
                        right: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              bookmark(snapshot.data[index]['restaurant_id'].toString());

                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.orange),
                                child: const Icon(
                                  Icons.bookmark_border,
                                  color: Colors.white,
                                )),
                          ),
                        )),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                          children: [
                                            Text(
                                              snapshot.data[index]['restaurant_info']['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
/*
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(18),
                                                  color: Colors.grey.withOpacity(.2)),
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
                                                          color: Colors.black,
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
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: size.width/1.5,
                                          child: Text(
                                            snapshot.data[index]['extra_info']['address']??'',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ) ,

                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data[index]['restaurant_info']['restaurant_type'],
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

                        itemCount: snapshot.data.length,
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
        ),
      ),
    ));
  }
}

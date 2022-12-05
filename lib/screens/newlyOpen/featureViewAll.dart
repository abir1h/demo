import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import '../MainHome/resturent_details.dart';
class featureViewAll extends StatefulWidget {
  const featureViewAll({Key? key}) : super(key: key);

  @override
  State<featureViewAll> createState() => _featureViewAllState();
}

class _featureViewAllState extends State<featureViewAll> {
  Future? viewall_experience;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.featureViewall+locaitonid!+"/"+subid!), headers: requestHeaders);
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
    var size=MediaQuery.of(context).size;
    return SafeArea(child:
    Scaffold(
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
          "Featured Restaurants",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
          /*Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )*/
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
            return ListView.builder(
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Get.to(()=>resturent_details(id: snapshot.data[index]['id'].toString()));
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
                                    left: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(18),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children:  [
                                            Text(snapshot.data[index]['raing'].toString()),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellowAccent,
                                            ),
                                            Text(
                                              '( '+snapshot.data[index]['rating_count'].toString()+'+ )',
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
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            snapshot.data[index]['bookmark_show']==1?snapshot.data[index]['bookmark_show']=0:snapshot.data[index]['bookmark_show']=1;
                                            bookmark(snapshot.data[index]['id'].toString());
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration:  BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: snapshot.data[index]['bookmark_show']==0?Colors.white:Colors.orange),
                                            child:  Icon(
                                              Icons.bookmark_border,
                                              color: snapshot.data[index]['bookmark_show']==0?Colors.black:Colors.white,
                                            )),
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                snapshot.data[index]['extra_info']['cuisine_type'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.grey),
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
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
      print(userData1);
      return userData1;
    } else {

      print("post have no Data${response.body}");
    }
  }
}

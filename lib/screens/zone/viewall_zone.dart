import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
class ViewAllZone extends StatefulWidget {
  const ViewAllZone({Key? key}) : super(key: key);

  @override
  State<ViewAllZone> createState() => _ViewAllZoneState();
}

class _ViewAllZoneState extends State<ViewAllZone> {
  Future? viewall_experience;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.view_all_experience), headers: requestHeaders);
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
          "All Experience",
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
          children: [
           Padding(
              padding: const EdgeInsets.all(8.0),
              child:Column(
                children: [
                  FutureBuilder(
                    future: viewall_experience,
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
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      // color: appColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else if (snapshot.hasData) {
                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),

                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.centerLeft,
                                      //   end: Alignment.centerRight,
                                      //   colors: [
                                      //    AppColors.start3.withOpacity(.00015),
                                      //     Colors.white,
                                      //   ],
                                      // )
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: size.height / 5.5,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(AppUrl
                                                      .pic_url1 +
                                                      snapshot.data
                                                      [index]['image']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data
                                                [index]['title'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                               Text(
                                                snapshot.data[index]['experience_zone'].length.toString() + " Places",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                })
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

          ],
        ),
      ),

    ));
  }
}

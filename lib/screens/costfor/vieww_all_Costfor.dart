import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'package:http/http.dart' as http;
import 'package:learning_school_bd/screens/costfor/singleCostfor.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
class view_all_costfor extends StatefulWidget {
  const view_all_costfor({Key? key}) : super(key: key);

  @override
  State<view_all_costfor> createState() => _view_all_costforState();
}

class _view_all_costforState extends State<view_all_costfor> {
  Future? viewall_experience;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.view_all_costfor), headers: requestHeaders);
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
          "All Cost For",
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
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),



                      SizedBox(
                          height: size.height ,

                          width: size.width,
                          child:ListView.builder(


                            itemBuilder: (_,index){

                              return  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                    Get.to(()=>
                                        costFor_single(id:snapshot.data
                                        [index]['id'].toString() ,));
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: size.height/4,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                            ,
                                            image: DecorationImage(
                                                image: NetworkImage(AppUrl.pic_url1 +
                                                    snapshot.data[index]['image'],),fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                      Positioned(
                                          bottom:0,
                                          child: Container(
                                            height:size.height/18,
                                            width:size.width,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                            ),child: Center(
                                              child: Text("Under "+snapshot.data[index]['title']+" Tk",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 18),)

                                          ),
                                          ))
                                    ],
                                  ),
                                ),
                              );

                            },

                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                          )),
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

    ));
  }
}

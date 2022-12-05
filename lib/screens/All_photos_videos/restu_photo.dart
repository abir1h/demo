import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'package:http/http.dart' as http;
import 'package:learning_school_bd/screens/events/singleEvent.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import '../MainHome/test.dart';
class restu_phopto extends StatefulWidget {
  final String id;
  const restu_phopto({Key? key,required this.id}) : super(key: key);

  @override
  State<restu_phopto> createState() => _restu_phoptoState();
}

class _restu_phoptoState extends State<restu_phopto> {
  Future? viewall_experience;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.restu_photo+widget.id), headers: requestHeaders);
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
          "Photos & Videos",
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
      body:               FutureBuilder(
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

                return  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
/*
                      Get.to(()=>singleEvent(id: '0',));
*/
                      Get.to(()=>test(picture:snapshot.data[index]['album']));


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
                                      snapshot.data[index]['album'][index]['image'],),fit: BoxFit.cover
                              )
                          ),
                        ),
                        Positioned(
                            bottom:0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:size.height/18,
                                width:size.width,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                ),child: Center(
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(snapshot.data[index]['photo_title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 18),),
                                      Text("( "+snapshot.data[index]['album'].length.toString()+" Pages )",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 18),),
                                    ],
                                  )

                              ),
                              ),
                            ))
                      ],
                    ),
                  ),
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

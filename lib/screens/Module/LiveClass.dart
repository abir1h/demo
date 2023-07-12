import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/Appurl.dart';
import '../LiveCourse/VideoConferrance.dart';
import 'ModuleController.dart';
import 'package:http/http.dart'as http;
class LiveClass extends StatefulWidget {
  const LiveClass({Key? key}) : super(key: key);

  @override
  State<LiveClass> createState() => _LiveClassState();
}

class _LiveClassState extends State<LiveClass> {
  final controller = Get.put(ModuleController());
  Future? ExamDetails;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(AppUrl.LiveClasses + controller.Courseid.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['data']['module'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ExamDetails = allExperience();
  }
  bool ischecked=false;
  Play_video(String Link)async{
    String? _id =
    YoutubePlayer.convertUrlToId(Link);

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: _id!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    await showDialog(
        context: context,
        builder: (context) {

      bool isChecked = false;
      return StatefulBuilder (builder: (context, setState1) {
        return Center(
            child: Container(
              height: MediaQuery.of(context).size.height/3.5,
              margin: EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 15),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(30)),
                  color: Colors.white),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color(0xff9572EF), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        child: Card(

                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,

                            //   onReady () {
                            // _controller.addListener(listener);
                            // },
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ));
      });
    });
  }


  Future checkVideoType(String id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(AppUrl.LiveClassesType + id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['data'];
      setState(() {
        ischecked=false;
        type=userData1['type'];
        ClassLink=userData1['class_link'];
        ClassLinkurl=userData1['class_link_url'];
      });
      userData1['type']=="live"?Get.to(()=>Meeting(MeetindUrl: userData1['class_link_url'],)):Play_video(ClassLinkurl!);
      print(userData1);
      return userData1;
    } else {
      setState(() {
        ischecked=false;

      });

      print("post have no Data${response.body}");
    }

  }
  String? type;
  String? ClassLink;
  String? ClassLinkurl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button

          backgroundColor: Colors.white, elevation: 0,

          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title:  Text(
            controller.CourseName.toString(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16),
          )
      ),
      body: FutureBuilder(
        future: ExamDetails,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: size.height / 3,
                ),
                SpinKitCircle(
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
                Center(
                  child: Text(
                    " Please wait while Loading..",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [


                  ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {

                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),color: Colors.white,
                                  border: Border.all(color: AppColors.border,width: 1)
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(                                        crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(snapshot.data[index]['title'],style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w700,fontSize: 16,),),
                                    Divider(thickness: 0,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(snapshot.data[index]['description'],style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 14,),),
                                              ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                  children: [
                                                    Text( DateFormat.yMMMMd('en_US').format(DateTime.parse(snapshot.data[index]['date'])),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 12,),),

                                                  ],
                                              ),
                                                )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              snapshot.data[index]['flag']='1';

                                            });
                                            checkVideoType(snapshot.data[index]['id'].toString());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              color: AppColors.greybg,
                                            ),child: Padding(
                                              padding: const EdgeInsets.all(18.0),
                                              child:  snapshot.data[index]['flag']!='1'?Center(child: Icon(Icons.play_arrow_outlined,size: 25,),):SpinKitCircle(color: AppColors.primaryGreen,size: 20,),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                        );
                      })
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text("No Data Found"),
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

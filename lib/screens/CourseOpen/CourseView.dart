import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/CourseOpen/CourseController.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import '../../utils/Appurl.dart';

class CoursView extends StatefulWidget {
  final String id,coursename;
  const CoursView({
    Key? key,
    required this.id, required this.coursename,
  }) : super(key: key);

  @override
  State<CoursView> createState() => _CoursViewState();
}

class _CoursViewState extends State<CoursView> with TickerProviderStateMixin{
  bool isloading = false;
  YoutubePlayerController? _controller;
  TextEditingController? _idController;
  TextEditingController? _seekToController;
  PlayerState? _playerState;
  YoutubeMetaData? _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  Future? CourseDetails;
  bool load=false;
  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller!.value.playerState;
        _videoMetaData = _controller!.metadata;
      });
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _idController!.dispose();
    _seekToController!.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    CourseDetails = GetCourseDetails(widget.id);
    _controller = YoutubePlayerController(
      initialVideoId: 'gQDByCdjUXw',
      flags: const YoutubePlayerFlags(
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  GetCourseDetails(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'authorization': "Bearer $token"
      };

      var response =
          await http.get(Uri.parse(AppUrl.CourseDetails+widget.id), headers: requestHeaders);
      if (response.statusCode == 200) {
        var userData1 = jsonDecode(response.body)['data'];
        setState(() {
          price=userData1['price'];
        });

        print(userData1);
        return userData1;
      } else {
        print("post have no Data${response.body}");
        var userData1 = jsonDecode(response.body)['data'];
        return userData1;
      }
    } catch (e) {
      print(e);
      setState(() {
        isloading = false;
      });
    }
    setState(() {
      isloading = false;
    });
  }
  var price='';

  final controller = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(CourseController());
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: size.height / 10,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Divider(
              thickness: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                   "৳"+ price.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: size.height / 18,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: const Center(
                        child: Text(
                          "Enroll",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )

          ],
        ),
      ),
      appBar: AppBar(
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
        title: Text(
          widget.coursename,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      backgroundColor: Colors.white,
          body: ListView(
            children: [
              Container(
                constraints: const BoxConstraints(),
                child: FutureBuilder(
                  future: CourseDetails,
                  builder: (_, AsyncSnapshot snapshot) {
                    print(snapshot.data);

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 5,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.3),
                            highlightColor: Colors.grey.withOpacity(0.1),
                            child: ListView.builder(
                              itemBuilder: (_, __) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: 40.0,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 6,
                            ),
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          Text('Error: ${snapshot.error}');
                        } else {
                          String? _id = YoutubePlayer.convertUrlToId(snapshot.data['promo_video']);

                          YoutubePlayerController _controller = YoutubePlayerController(
                            initialVideoId:_id!,
                            flags: YoutubePlayerFlags(
                              autoPlay: false,
                              mute: true,
                            ),
                          );
                          return snapshot.hasData
                              ?        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height / 3.8,
                                width: size.width,
                                child: YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,

                                  //   onReady () {
                                  // _controller.addListener(listener);
                                  // },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(snapshot.data['video_title']),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.groups_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.data['total_video']+" Total Video",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bookmark_add_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.data['total_time']+" Minutes Video",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_box_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.data['total_sheet']+" Sheets",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.dock,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Model Test on Question Bank",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.quiz,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "2940 Quizes",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.live_tv,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "80 Live Classes",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                thickness: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "What you will learn from this course",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Html( //to show HTML as widget.
                                  data:   snapshot.data['we_have_to_learn'],

                                  //body padding (Optional)
                                  //baseURl (optional)

                                ),
                              ),

/*
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: AppColors.mainColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: Text(
                                              controller.learn[index],
                                              style: TextStyle(color: Colors.black),
                                              softWrap: true,
                                            ))
                                      ],
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: controller.learn.length,
                              ),
*/
                           /*   Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: HtmlWidget( //to show HTML as widget.
                                  snapshot.data['we_have_to_learn'],

                                  //body padding (Optional)
                                  //baseURl (optional)

                                ),
                              ),*/

                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                thickness: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Program Instructor",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        snapshot.data['course_instructor_image']!=null? CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                          NetworkImage(AppUrl.pic_url1+snapshot.data['course_instructor_image']),
                                        ):CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                          NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6v-Quj0rUbKfkYkO5xry7QsyV_3dNemjlbw&usqp=CAU"),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data['course_instructor'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                snapshot.data['course_instructor_details'],                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                 /*   Divider(
                                      indent: 5,
                                      thickness: 2,
                                    )*/
                                  ],
                                ),
                              ),
/*
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'All Instructors',
                                    style: TextStyle(decoration: TextDecoration.underline),
                                  ),
                                  Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
*/
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                thickness: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Course Details",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Html( //to show HTML as widget.
                    data:   snapshot.data['about_course'],

                      //body padding (Optional)
                      //baseURl (optional)

                      ),
                    ),  SizedBox(
                                height: 10,
                              ),
                              Divider(
                                thickness: 10,
                              ),Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "More Videos",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                           ListView.builder(

                               itemBuilder: (_,index){
                                 String? _id = YoutubePlayer.convertUrlToId(snapshot.data['all_videos'][index]['video_link']);

                                 YoutubePlayerController _controller2 = YoutubePlayerController(
                                   initialVideoId:_id!,
                                   flags: YoutubePlayerFlags(
                                     autoPlay: false,
                                     mute: true,
                                   ),
                                 );
                             return  ExpansionTile(
                               initiallyExpanded: snapshot.data['all_videos'][index]['lock_status']=='0'?true:false,
                               title: Text(
                                 snapshot.data['all_videos'][index]['title'],
                                 style: TextStyle(
                                     color: Colors.black,
                                     fontWeight: FontWeight.w800,
                                     fontSize: 16),
                               ),
                               children: <Widget>[
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Card(

                                     child: YoutubePlayer(
                                       controller: _controller2,
                                       showVideoProgressIndicator: true,

                                       //   onReady () {
                                       // _controller.addListener(listener);
                                       // },
                                     ),
                                   ),
                                 ),
                               ],
                             );
                           },
                           itemCount: snapshot.data['all_videos'].length,
                             shrinkWrap: true,
                           ),


                           /*   const ExpansionTile(
                                initiallyExpanded: true,
                                title: Text(
                                  'About the BCS Preli LIVE Course',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 10),
                                    child: Text(
                                      "BCS Preli LIVE course from 10 Minute School is a complete and thorough guideline for 46th BCS Preliminary preparation.The BCS Preli LIVE Course starts on 1st April, 2023. But you can enroll in the course now and join the LIVE classes for 45th BCS Preliminary exam and stay ahead in the gameThis course contains 147 recorded video lectures on 10 subjects included in the BCS Preli Syllabus and all these classes are conducted by experienced BCS Cadres. You will also get access to 3 weekly live classes which result in 80 live classes in six months, 2,940 quizzes with answers to test yourself, and 125 lecture sheets that cover the entire BCS Preli Syllabus. This course provides you with a BCS Question Bank of 34 years and lets you sit for model tests based on these papers.This course guided by a group of talented and successful BCS cadres is a comprehensive test preparation material for a BCS aspirant. This unique combination of live and recorded classes, top-notch lecture sheets, topic-wise quiz, question banks and weekly model tests will help you prepare for the BCS Preliminary exam in the shortest possible time. ",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              const ExpansionTile(
                                title: Text(
                                  'Why should I enroll in this BCS Preli Live Course?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      "•You'll be able to cover the entire BCS syllabus for the preliminary exam by watching a set of videos.",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 10),
                                    child: Text(
                                      "•You'll be able to prepare yourself for other job exams as well.",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              const ExpansionTile(
                                title: Text(
                                  'What is unique about this BCS Preliminary course?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 10),
                                    child: Text(
                                      "•Our experienced BCS Cadre instructors have presented every lecture via smartboard in an easy-to-understand method.",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 10),
                                    child: Text(
                                      "•Our lecture sheets have been prepared by leading BCS Cadres, instructors, and content researchers.",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 10),
                                    child: Text(
                                      "•The illustrations and visuals used in the materials are interactive and are designed to memorize information well.",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ],
                              ),*/
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                thickness: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Have any questions?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Container(
                                  height: size.height / 18,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.wifi_calling_3_outlined,
                                        color: AppColors.mainColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "call 16910",
                                        style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          )

                              : Text('No data');
                        }
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),


            ],
          ),

        ));
  }
}

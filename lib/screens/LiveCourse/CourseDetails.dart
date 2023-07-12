import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/LiveCourse/payment.dart';
import 'package:learning_school_bd/screens/Module/ModuleController.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import '../Module/ModuleView.dart';
import 'TabbarView/Helpline.dart';
import 'TabbarView/about.dart';
import 'TabbarView/instructors.dart';
import 'package:http/http.dart' as http;

class CourseDetails extends StatefulWidget {
  final String id, name;
  const CourseDetails({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails>
    with TickerProviderStateMixin {
  List imageList = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg',
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg'
  ];
  late TabController _tabController;

  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  final _tabs = [];
  var price;
  bool isloading = false;
  Future? CourseDetails;
  Future details() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'authorization': "Bearer $token"
      };

      var response = await http.get(Uri.parse(AppUrl.CourseInfo + widget.id),
          headers: requestHeaders);
      if (response.statusCode == 200) {
        var userData1 = jsonDecode(response.body)['data'];
        setState(() {
          price = userData1['course_price'];
          isenroll = userData1['is_entroll'].toString();
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
  }

  List<Widget> screnns = [];
  bool showmore = false;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this);
    CourseDetails = details();

    super.initState();
  }

  var selected_tab = 0;
  var isenroll = '';
  ExpandableController? controller_ex;
  //Tab Header
  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
  }

  ScrollController? controller2;

  int counter = 0;
  ScrollController? controllersc = ScrollController();
  final controller = Get.put(ModuleController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: price != null
          ? ShowUpAnimation(
              animationDuration: const Duration(milliseconds: 1000),
              curve: Curves.easeIn,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                height: size.height / 6.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                " ৳" + price.toString(),
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Promo Code",
                            style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Text(isenroll.toString()),
                    int.parse(isenroll) > 0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                controller.CourseName.value = widget.name;
                                controller.Courseid.value = widget.id;
                                Get.to(() => const ModuleView(),
                                    transition: Transition.rightToLeft,
                                    duration:
                                        const Duration(milliseconds: 500));
                              },
                              child: Container(
                                height: size.height / 18,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.blackpanther),
                                child: const Center(
                                  child: Text(
                                    "Go to Module",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                controller.CourseName.value = widget.name;
                                controller.Courseid.value = widget.id;
                                controller.price.value = price.toString();

                                Get.to(() => const payment(),
                                    transition: Transition.rightToLeft,
                                    duration:
                                        const Duration(milliseconds: 1000));
                              },
                              child: Container(
                                height: size.height / 18,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primaryyeollo),
                                child: const Center(
                                  child: Text(
                                    "Join Live batch",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ))
          : const SizedBox(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0), // here the desired height
        child: Column(
          children: [
            AppBar(
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
                widget.name.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            ),
            Container(
                height: size.height / 9,
                width: size.width,
                decoration: const BoxDecoration(color: AppColors.primarg),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: SizedBox(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Apply promo LARAVEL and get 2200 Taka Discount only for",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.timer,
                                  color: AppColors.primarg,
                                ),
                                Text(
                                  " 8 Days",
                                  style: TextStyle(
                                      color: AppColors.primarg,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Apply Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
      body: FutureBuilder(
        future: CourseDetails,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: size.height / 3,
                ),
                const SpinKitCircle(
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
                const Center(
                  child: Text(
                    " Please wait while Loading..",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData) {
            String? _id =
                YoutubePlayer.convertUrlToId(snapshot.data['demo_video']);

            YoutubePlayerController _controller = YoutubePlayerController(
              initialVideoId: _id!,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: true,
              ),
            );

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data['course_name'].toString(),
                      style: const TextStyle(
                          color: AppColors.blackpanther,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        snapshot.data['course_sort_description'].toString()),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: size.height / 6,
                        width: size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  AppUrl.pic_url1 +
                                      snapshot.data['course_image'],
                                ),
                                fit: BoxFit.cover)),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Container(
                          height: size.height / 11,
                          width: size.width / 2.9,
                          decoration: BoxDecoration(
                              color: AppColors.c1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Icon(
                                Icons.access_time_outlined,
                                color: AppColors.primaryOrange,
                              ),
                              Text(
                                snapshot.data['days_remaining'].toString() +
                                    " Days Remaining ",
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 48.0),
                        child: Container(
                          height: size.height / 11,
                          width: size.width / 3,
                          decoration: BoxDecoration(
                              color: AppColors.c2,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Icon(
                                Icons.person_add_outlined,
                                color: AppColors.primaryGreen,
                              ),
                              Text(
                                snapshot.data['total_seat'].toString() +
                                    " Seats left",
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  snapshot.data['getting_in_this_course'].length > 0
                      ? Column(
                          children: [
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "You're getting in this course",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            childAspectRatio: 16 / 4,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    itemCount: snapshot
                                        .data['getting_in_this_course'].length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            size: 20,
                                            color: AppColors.primaryGreen,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(snapshot.data[
                                                  'getting_in_this_course']
                                              [index]['content_name'])
                                        ],
                                      );
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const Divider(),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.book,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/class.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Free Orientation Class"),
                                        Row(
                                          children: const [
                                            Icon(Icons.date_range),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "15 Aug Tue,9:00 PM",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: size.height / 18,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: AppColors.blackpanther,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text(
                                  "Book Your Seat",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width,
                      child: Row(
                        children: [
                          const VerticalDivider(
                            color: AppColors.div,
                            width: 10,
                            thickness: 2,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.div,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data['course_batch_name'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 1,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.2)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: AppColors.div,
                                    ),
                                    const Text(
                                      'Starting Time: ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      snapshot.data['start_date'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 1,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.2)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: AppColors.div,
                                    ),
                                    const Text(
                                      'Class Days: ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      snapshot.data['class_days'].toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 1,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.2)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: AppColors.div,
                                    ),
                                    const Text(
                                      'Class Time: ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      snapshot.data['class_time'].toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ExpansionTile(
                    trailing: const SizedBox(),
                    initiallyExpanded: false,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: size.height / 10,
                        width: size.width,
                        child: Row(
                          children: [
                            const VerticalDivider(
                              color: AppColors.primaryGreen,
                              width: 10,
                              thickness: 2,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/play.png',
                                            height: 70,
                                            width: 70,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            'Free Demo Class',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: size.height / 18,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons
                                                      .play_circle_outline_outlined,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Watch Video",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    children: <Widget>[
                      YoutubePlayerBuilder(
                          onExitFullScreen: () {
                            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                            SystemChrome.setPreferredOrientations(
                                DeviceOrientation.values);
                          },
                          player: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.blueAccent,
                            topActions: <Widget>[
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  _controller.metadata.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                onPressed: () {},
                              ),
                            ],
                            onReady: () {},
                            onEnded: (data) {},
                          ),
                          builder: (BuildContext, Widget) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,

                                  //   onReady () {
                                  // _controller.addListener(listener);
                                  // },
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/stat.jpeg'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Expanded(
                            child: Text(
                          'Study Plan',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        /* Row(
                                children: [
                                  Text(
                                    '54 Live Clases ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryprice_text,
                                    ),
                                  ),
                                  Text(
                                    ' 358 pre-recorded Videos',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),*/
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width / 4,
                    child: const Divider(),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data['module'].length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(.3))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:ExpansionTile(
                                initiallyExpanded: index==0?true:false,
                                title:  Column(
                                  children: [
                                Row(
                                children: [
                                Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Module " +
                                        (index + 1).toString(),
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data['module'][index]
                                  ['title'],
                                  style: const TextStyle(
                                      color: AppColors
                                          .blackpanther,
                                      fontSize: 15),
                                ),
                              )
                              ],
                            ),


                        ],
                        ),
                                children: [
                                  Column(
                                    children: [
                                      Html(
                                        data: snapshot.data['module'][index]
                                        ['description'],
                                      )
                                    ],
                                  ),
                                ],
                              )
                              /*ExpandablePanel(
                                //controller: controller_ex,
                                theme: ExpandableThemeData(iconColor: Colors.blue,),



                                  header: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Module " +
                                                    (index + 1).toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              snapshot.data['module'][index]
                                                  ['title'],
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .blackpanther,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),

                                      *//*  Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.video_camera_back_outlined,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "3 Live Clases",
                                                    style: TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.format_list_bulleted_outlined,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "3 Tests",
                                                    style: TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit_note,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "1 Assignments",
                                                      style: TextStyle(fontSize: 10),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),*//*
                                    ],
                                  ),
                                  collapsed: const SizedBox(),
                                  expanded:
                                      *//*Column(
                                        children: [
                                          Divider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "DAY 1",
                                                    style: TextStyle(color: AppColors.primaryprice_text),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.blackpanther,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Live Class".toUpperCase(),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('প্রথম লাইভ ক্লাস নিবেন রাব্বিল হাসান স্যার ।')
                                            ],
                                          ),
                                          Divider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "DAY 2",
                                                    style: TextStyle(color: AppColors.primaryprice_text),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.t_grey.withOpacity(.3),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Concept Class".toUpperCase(),
                                                        style:
                                                        TextStyle(color: Colors.black, fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Foundation of Software Engineering এর উপর কনসেপচুয়াল ক্লাস')
                                            ],
                                          ),
                                          Divider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "DAY 3",
                                                    style: TextStyle(color: AppColors.primaryprice_text),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.t_grey.withOpacity(.3),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Concept Class".toUpperCase(),
                                                        style:
                                                        TextStyle(color: Colors.black, fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Foundation of Software Engineering এর উপর কনসেপচুয়াল ক্লাস')
                                            ],
                                          ),
                                          Divider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "DAY 4",
                                                    style: TextStyle(color: AppColors.primaryprice_text),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.t_grey.withOpacity(.3),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Quiz Class".toUpperCase(),
                                                        style:
                                                        TextStyle(color: Colors.black, fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Quiz দিয়ে নিজেকে ঝালিয়ে নিন')
                                            ],
                                          ),
                                        ],
                                      ),*//*
                                      Column(
                                    children: [
                                      Html(
                                        data: snapshot.data['module'][index]
                                            ['description'],
                                      )
                                    ],
                                  ),


                              ),*/
                            ),
                          ),
                        );
                      }),
                  /*  showmore == false
                            ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showmore = true;
                                });
                              },
                              child: Container(
                                width: size.width,
                                height: size.height / 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.t_grey
                                            .withOpacity(.2))),
                                child: Center(
                                    child: Text(showmore == false
                                        ? 'Show More'
                                        : "Show Less")),
                              ),
                            ),
                          ),
                        )
                            : Container(),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Instructors',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: size.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data['instructor'].length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    height: size.height / 9,
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        const VerticalDivider(
                                          color: AppColors.green,
                                          thickness: 2,
                                        ),
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              "assets/images/ins1.jpg"),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                snapshot.data['instructor']
                                                    [index]['instructor_name'],
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .primaryprice_text,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Expanded(
                                                child: Html(
                                                  data: snapshot
                                                          .data['instructor']
                                                      [index]['description'],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  about(text: snapshot.data['about_course']),
                  const HelpLine(),
                  SizedBox(
                    height: size.height / 5,
                  )
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

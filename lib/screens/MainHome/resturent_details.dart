import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:learning_school_bd/screens/MainHome/test.dart';
import 'package:learning_school_bd/screens/offers/offers_resturents.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../utils/Appurl.dart';
import '../All_photos_videos/AllPhotos.dart';
import '../All_photos_videos/restu_photo.dart';
import '../Menu/all_menu.dart';
import '../booking/bookingScreen.dart';
import '../food_drinks/seeall.dart';
import '../offers/offers.dart';
import '../see_all_reviews/see_all_reviews.dart';
import 'Main-Home.dart';
import 'package:http/http.dart' as http;

class resturent_details extends StatefulWidget {
  final String id;
  resturent_details({required this.id});
  @override
  _resturent_detailsState createState() => _resturent_detailsState();
}

class _resturent_detailsState extends State<resturent_details> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List sliderList = [
    "assets/images/f1.png",
    "assets/images/f2.png",
    "assets/images/f3.png",
    "assets/images/f4.png",
    "assets/images/f5.png",
  ];
  int activePage = 1;
  int page_positioned = 0;
  late PageController controller;

  Future? dashboard;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.restu_profile + widget.id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      name= userData1['basicInfo']['name'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var name;

  @override
  void initState() {
    super.initState();
    dashboard = getpost();
    load();


    controller = PageController();
  }
bool loaded=false;
  load(){
    Future.delayed(const Duration(seconds: 1), (){
      print("Executed after 5 seconds");
      setState(() {
        loaded=true;
      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int counter = 0;
  ScrollController? controllersc=ScrollController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var top = 0.0;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return SafeArea(
      child: loaded==true?Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: size.height / 15,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.start.withOpacity(1),
                              Colors.orange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Create an event",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Get.to(()=>bookingScreen(restuName: name,id: widget.id,));
                    },
                    child: Container(
                        height: size.height / 15,
                        decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            //   colors: [
                            //    AppColors.start.withOpacity(1),
                            //    Colors.orange,
                            //   ],
                            // ),
                            color: Colors.white,
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Book Now",
                              style: TextStyle(
                                  color: AppColors.start_color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: FutureBuilder(
            future: dashboard,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    SizedBox(height: size.height/3,),
                    Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                    const Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                  ],
                );              } else if (snapshot.hasData) {
                return NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        leading: const Icon(
                          Icons.arrow_back,
                          color: Colors.transparent,
                        ),
                        backgroundColor: Colors.transparent,



                        expandedHeight: size.height / 1.8,
                        // backgroundColor: Colors.white,
                        flexibleSpace: LayoutBuilder(builder:
                            (BuildContext context,
                            BoxConstraints constraints) {
                          // print('constraints=' + constraints.toString());

                          top = constraints.biggest.height;
                          return FlexibleSpaceBar(
                            centerTitle: true,

                            // background: Image.asset('assets/images/f2.png',fit: BoxFit.cover,width: double.maxFinite,),
                            background: Column(
                              children: [
                                // Container(
                                //         height: MediaQuery.of(context).size.height/4,
                                //         child: CarouselSlider.builder(
                                //           options: CarouselOptions(
                                //             scrollDirection: Axis.horizontal,
                                //             scrollPhysics: AlwaysScrollableScrollPhysics(),
                                //             height: 300,
                                //             autoPlay: true,
                                //             reverse: true,
                                //             enlargeCenterPage: true,
                                //             viewportFraction: 1,
                                //           ),
                                //           itemCount: sliderList.length,
                                //
                                //           itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                //
                                //              Stack(
                                //                clipBehavior: Clip.none,
                                //                children: [
                                //                  Positioned(
                                //                    bottom: 0,
                                //                    child: new DotsIndicator(
                                //                      dotsCount: sliderList.length,
                                //                      position: 1,
                                //                    ),
                                //                  ),
                                //                  Container(
                                //                    height: size.height/5,
                                //                    width: size.width,
                                //                    decoration: BoxDecoration(
                                //                        borderRadius: BorderRadius.circular(10),
                                //                        image: DecorationImage(
                                //                            image: AssetImage(sliderList[itemIndex]),
                                //                            fit: BoxFit.cover
                                //                        )
                                //                    ),
                                //                    // child: InkWell(
                                //                    //
                                //                    //     onTap: ()async{
                                //                    //       // var url=snapshot.data[itemIndex]['links'];
                                //                    //       // if (await canLaunch(url))
                                //                    //       //   await launch(url);
                                //                    //       // else
                                //                    //       //   // can't launch url, there is some error
                                //                    //       //   throw "Could not launch $url";
                                //                    //     },
                                //                    //     child:Image.asset('assets/images/ban.jpg',width: width,))
                                //                  ),
                                //                ],
                                //              )
                                //         ),
                                //       ),

                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    SizedBox(
                                      height: size.height / 3.5,
                                      child: PageIndicatorContainer(
                                        child: PageView.builder(
                                          itemCount: sliderList.length,
                                          itemBuilder: (BuildContext context,
                                              int itemIndex) {
                                            return Container(
                                              height: size.height / 3.5,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          AppUrl.pic_url1+  snapshot.data['basicInfo']['extra_info']['banner_image']),
                                                      fit: BoxFit.cover)),
                                            );
                                          },
                                        ),
                                        align: IndicatorAlign.bottom,
                                        length: 4,
                                        indicatorSpace: 10.0,
                                      ),
                                    ),
                                    Positioned(
                                        left: 5,top: 8,
                                        child:  Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          print('tapped');
                                          Get.to(
                                                  () => Main_home());
                                          // Get.back();
                                        },
                                        child: const CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                          Colors.white,
                                          child: Center(
                                            child:Icon(
                                              Icons
                                                  .arrow_back_ios_outlined,
                                              color: Colors
                                                  .black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                    Positioned(
                                        right: -5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: size.height / 18,
                                            width: size.width,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                                children: [

                                                  Row(
                                                    children:  [
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            snapshot.data['bookMark']==1?snapshot.data['bookMark']=0:snapshot.data['bookMark']=1;
                                                            bookmark(snapshot.data['basicInfo']['id'].toString());
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                          snapshot.data['bookMark']==1?AppColors.orange:Colors.white,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .bookmark_border,
                                                              color:
                                                              snapshot.data['bookMark']==1?Colors.white:Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      const CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                        Colors.white,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.share_sharp,
                                                            color:
                                                            Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                    // Positioned(
                                    //     bottom: 10,
                                    //     right: 20,
                                    //     child: Container(
                                    //       height: size.height / 18,
                                    //       width: size.width / 3.6,
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //         color: Colors.white,
                                    //       ),
                                    //       child: Padding(
                                    //         padding:
                                    //             const EdgeInsets.all(8.0),
                                    //         child: Row(
                                    //           children: const [
                                    //             Icon(
                                    //               Icons.image,
                                    //               color: Colors.black,
                                    //             ),
                                    //             Text(
                                    //               "All Photos",
                                    //               style: TextStyle(
                                    //                   fontWeight:
                                    //                       FontWeight.w500,
                                    //                   fontSize: 14),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     )),
                                    Positioned(
                                      bottom: -60,
                                      left: 10,
                                      child: CircularProfileAvatar(
                                        '',
                                        child: Image.network(
                                          AppUrl.pic_url1+  snapshot.data['basicInfo']['extra_info']['profile_image'],fit: BoxFit.cover,
                                        ),
                                        borderColor: Colors.white,
                                        borderWidth: 10,
                                        elevation: 2,
                                        radius: 70,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -70,
                                      right: 20,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height / 18,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              color: AppColors.rating_back,
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children:  [
                                                  InkWell(
                                                    onTap: (){
                                                      /*
                                                                                                        Get.to(()=>test());
                                                  */
                                                    },
                                                    child: Text(
                                                     snapshot.data['rating'].toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.only(
                                                  bottomLeft:
                                                  Radius.circular(10),
                                                  bottomRight:
                                                  Radius.circular(10),
                                                )),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                children:  [
                                                  Text(
                                                    snapshot.data['reviewCount'].toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  const Text(
                                                    "Reviews",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.height / 15,
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data['basicInfo']['name'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children:  [
                                              const Icon(
                                                Icons.food_bank,
                                                color: AppColors.rating_back,
                                              ),
                                              Text(
                                                snapshot.data['basicInfo']['extra_info']['cuisine_type'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons
                                                    .perm_contact_cal_rounded,
                                                color: AppColors.rating_back,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      snapshot.data['basicInfo']['extra_info']['address']??'',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(.7),
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children:  [
                                                  const Icon(
                                                    Icons.home,
                                                    color:
                                                    AppColors.rating_back,
                                                  ),
                                                  Text(
                                                    snapshot.data['basicInfo']['extra_info']['sitting_type']
                                                    ,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: const [
                                                  Icon(
                                                    Icons.money,
                                                    color:
                                                    AppColors.rating_back,
                                                  ),
                                                  Text(
                                                    "600tk for 2 ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ]))
                              ],
                            ),
                          );
                        })),
//                     SliverFillRemaining(
//                         hasScrollBody: true,
//                         child: ListView.builder(itemBuilder: (_,index){return Column(
//                           children: [
// /*
//                             top>56.0?Container():SizedBox(height: size.height/55,),
// */
//
//                             Container(
//                               height:size.height,
//                               child: ScrollableListTabView(
//
//                                 tabHeight: 48,
//                                 bodyAnimationDuration: const Duration(milliseconds: 150),
//                                 tabAnimationCurve: Curves.easeOut,
//                                 tabAnimationDuration: const Duration(milliseconds: 200),
//                                 tabs: [
//                                   ScrollableListTab(
//                                     tab: const ListTab(
//                                         label: Text('Offers',
//                                             style: TextStyle(fontWeight: FontWeight.bold)),
//                                         activeBackgroundColor: Colors.orange,
//                                         showIconOnList: false),
//                                     body: ListView(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: InkWell(
//                                             onTap:(){
//                                             },
//                                             child: Text(
//                                               'Browse by Offers',
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.normal),
//                                             ),
//                                           ),
//                                         ),
//                                         GridView.builder(
//                                             shrinkWrap: true,
//                                             gridDelegate:
//                                             const SliverGridDelegateWithMaxCrossAxisExtent(
//                                                 maxCrossAxisExtent: 145,
//                                                 childAspectRatio: 4 / 3,
//                                                 crossAxisSpacing: 8,
//                                                 mainAxisSpacing: 10),
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             itemCount: snapshot.data['offerInfo'].length,
//                                             itemBuilder: (_, index) => Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Container(
//                                                 height: size.height / 7.6,
//                                                 width: size.width / 3.5,
//                                                 decoration: BoxDecoration(
//                                                     color: AppColors.bg_background2,
//                                                     borderRadius: BorderRadius.circular(10)),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(left: 8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       const SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       // const Text(
//                                                       //   'Upto',
//                                                       //   style: TextStyle(
//                                                       //       fontSize: 14,
//                                                       //       fontWeight: FontWeight.w400,
//                                                       //       color: Colors.white),
//                                                       // ),
//                                                       Text(
//                                                         snapshot.data['offerInfo'][index]['flat_discount']+" % ",
//                                                         style: const TextStyle(
//                                                             fontSize: 28,
//                                                             fontWeight: FontWeight.w700,
//                                                             color: Colors.white),
//                                                       ),
//                                                       const Text(
//                                                         'Flat Discont!',
//                                                         style: TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight: FontWeight.w600,
//                                                             color: Colors.white),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             )),
//                                         const SizedBox(
//                                           height: 25,
//                                         ),
//                                         Center(
//                                           child: InkWell(
//                                             onTap: () {
//                                               Get.to(() => const offers());
//                                             },
//                                             child: const Text(
//                                               'See All Offers',
//                                               style: TextStyle(
//                                                   color: Colors.orange,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 14),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   ScrollableListTab(
//                                     tab: const ListTab(
//                                         label: Text('Menu',
//                                             style: TextStyle(fontWeight: FontWeight.bold)),
//                                         activeBackgroundColor: Colors.orange,
//                                         showIconOnList: false),
//                                     body: ListView(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Text(
//                                             'Food & Drinks Menu',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                         ),
//                                         GridView.builder(
//                                             shrinkWrap: true,
//                                             gridDelegate:
//                                             SliverGridDelegateWithFixedCrossAxisCount(
//                                                 crossAxisCount: 3,
//                                                 childAspectRatio:
//                                                 (itemWidth / itemHeight),
//                                                 crossAxisSpacing: 2,
//                                                 mainAxisSpacing: 1),
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             itemCount: snapshot.data['foodDrinkmenu'].length,
//                                             itemBuilder: (_, index) => Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Stack(
//                                                   clipBehavior: Clip.none,
//                                                   children: [
//                                                     Container(
//                                                       height: size.height / 4,
//                                                       width: size.width / 3,
//                                                       decoration: BoxDecoration(
//                                                           image: DecorationImage(
//                                                               image: NetworkImage(
//                                                                   AppUrl.pic_url1+  snapshot.data['foodDrinkmenu'][index]['album'][0]['image']),
//                                                               fit: BoxFit.cover),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .withOpacity(0.2),
//
//                                                               spreadRadius: 2,
//
//                                                               blurRadius: 4,
//
//                                                               offset: const Offset(0,
//                                                                   0), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                           color: Colors.white,
//                                                           borderRadius:
//                                                           BorderRadius.circular(10)),
//                                                       child: Stack(
//                                                         children: [
//                                                           Positioned(
//                                                             bottom: 0,
//                                                             child: Container(
//                                                               height: 25,
//                                                               width: size.width / 3.6,
//                                                               decoration: const BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.only(
//                                                                       bottomLeft: Radius
//                                                                           .circular(10),
//                                                                       bottomRight:
//                                                                       Radius
//                                                                           .circular(
//                                                                           10)),
//                                                                   color: Colors.black54),
//                                                               child:  Center(
//                                                                 child: Text(
//                                                                   snapshot.data['foodDrinkmenu'][index]['photo_title']+ ' (${snapshot.data['foodDrinkmenu'][index]['album_count']} pages)',
//                                                                   style: TextStyle(
//                                                                       fontSize: 12,
//                                                                       color: Colors.white,
//                                                                       fontWeight:
//                                                                       FontWeight.bold),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ))),
//                                         Center(
//                                           child: InkWell(
//                                             onTap: () {
//                                               Get.to(() => const All_menu());
//                                             },
//                                             child: const Text(
//                                               'See All Menu',
//                                               style: TextStyle(
//                                                   color: Colors.orange,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 14),
//                                             ),
//                                           ),
//                                         ),
//                                         const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Text(
//                                             'Best Selling Items',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: size.height / 5,
//                                           width: size.width,
//                                           child: ListView.builder(
//                                             itemBuilder: (_, index) {
//                                               return Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Container(
//                                                   height: size.height / 10,
//                                                   width: size.width / 3,
//                                                   decoration: const BoxDecoration(),
//                                                   child: Column(
//                                                     children: [
//                                                       Container(
//                                                         height: size.height / 10,
//                                                         width: size.width / 3,
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                             BorderRadius.circular(10),
//                                                             image: DecorationImage(
//                                                                 image: NetworkImage(
//                                                                     AppUrl.pic_url1+snapshot.data['bestSelling'][index]['image']),
//                                                                 fit: BoxFit.cover)),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.all(5.0),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                           children:  [
//                                                             Text(
//                                                               snapshot.data['bestSelling'][index]['title'],
//                                                               style: TextStyle(
//                                                                   color: Colors.black,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 16),
//                                                             ),
//                                                             Text(
//                                                               snapshot.data['bestSelling'][index]['have_to_eat'],
//                                                               style: TextStyle(
//                                                                   color: Colors.black,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 16),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             left: 5.0, right: 5),
//                                                         child: Row(
//                                                           children:  [
//                                                             Text(
//                                                               snapshot.data['bestSelling'][index]['price']+'   ',
//                                                               style: TextStyle(
//                                                                   color: Colors.orange,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 18),
//                                                             ),
//                                                             Text(
//                                                               'tk',
//                                                               style: TextStyle(
//                                                                   color: AppColors.price,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 16),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             shrinkWrap: true,
//                                             itemCount: snapshot.data['bestSelling'].length,
//                                             scrollDirection: Axis.horizontal,
//                                           ),
//                                         ),
//                                         // SizedBox(
//                                         //   height: size.height / 5,
//                                         //   width: size.width,
//                                         //   child: ListView.builder(
//                                         //     itemBuilder: (_, index) {
//                                         //       return Padding(
//                                         //         padding: const EdgeInsets.all(8.0),
//                                         //         child: Container(
//                                         //           height: size.height / 10,
//                                         //           width: size.width / 3,
//                                         //           decoration: const BoxDecoration(),
//                                         //           child: Column(
//                                         //             children: [
//                                         //               Container(
//                                         //                 height: size.height / 10,
//                                         //                 width: size.width / 3,
//                                         //                 decoration: BoxDecoration(
//                                         //                     borderRadius:
//                                         //                         BorderRadius.circular(10),
//                                         //                     image: DecorationImage(
//                                         //                         image: NetworkImage(AppUrl.pic_url1+
//                                         //                             snapshot.data['bestSelling'][index]['image']),
//                                         //                         fit: BoxFit.cover)),
//                                         //               ),
//                                         //               Padding(
//                                         //                 padding: const EdgeInsets.all(5.0),
//                                         //                 child: Row(
//                                         //                   mainAxisAlignment:
//                                         //                       MainAxisAlignment
//                                         //                           .spaceBetween,
//                                         //                   children:  [
//                                         //                     Text(
//                                         //                       snapshot.data['bestSelling'][index]['title'],
//                                         //                       style: TextStyle(
//                                         //                           color: Colors.black,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 16),
//                                         //                     ),
//                                         //                     Text(
//                                         //                       snapshot.data['bestSelling'][index]['have_to_eat'],
//                                         //                       style: TextStyle(
//                                         //                           color: Colors.black,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 16),
//                                         //                     ),
//                                         //                   ],
//                                         //                 ),
//                                         //               ),
//                                         //               Padding(
//                                         //                 padding: const EdgeInsets.only(
//                                         //                     left: 5.0, right: 5),
//                                         //                 child: Row(
//                                         //                   children:  [
//                                         //                     Text(
//                                         //                       snapshot.data['bestSelling'][index]['price']+'   ',
//                                         //                       style: TextStyle(
//                                         //                           color: Colors.orange,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 18),
//                                         //                     ),
//                                         //                     Text(
//                                         //                       'tk',
//                                         //                       style: TextStyle(
//                                         //                           color: AppColors.price,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 16),
//                                         //                     ),
//                                         //                   ],
//                                         //                 ),
//                                         //               )
//                                         //             ],
//                                         //           ),
//                                         //         ),
//                                         //       );
//                                         //     },
//                                         //     shrinkWrap: true,
//                                         //     itemCount: 3,
//                                         //     scrollDirection: Axis.horizontal,
//                                         //   ),
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                   ScrollableListTab(
//                                     tab: const ListTab(
//                                         label: Text('Photos',
//                                             style: TextStyle(fontWeight: FontWeight.bold)),
//                                         activeBackgroundColor: Colors.orange,
//                                         showIconOnList: false),
//                                     body: ListView(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Text(
//                                             'Photos & Videos',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                         ),
//                                         GridView.builder(
//                                             shrinkWrap: true,
//                                             gridDelegate:
//                                             SliverGridDelegateWithFixedCrossAxisCount(
//                                                 crossAxisCount: 3,
//                                                 childAspectRatio:
//                                                 (itemWidth / itemHeight),
//                                                 crossAxisSpacing: 2,
//                                                 mainAxisSpacing: 1),
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             itemCount: snapshot.data['photoVideo'].length,
//                                             itemBuilder: (_, index) => Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Stack(
//                                                   clipBehavior: Clip.none,
//                                                   children: [
//                                                     Container(
//                                                       height: size.height / 4,
//                                                       width: size.width / 3,
//                                                       decoration: BoxDecoration(
//                                                           image: DecorationImage(
//                                                               image: NetworkImage(
//                                                                   AppUrl.pic_url1+snapshot.data['photoVideo'][index]['album'][0]['image']),
//                                                               fit: BoxFit.cover),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .withOpacity(0.2),
//
//                                                               spreadRadius: 2,
//
//                                                               blurRadius: 4,
//
//                                                               offset: const Offset(0,
//                                                                   0), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                           color: Colors.white,
//                                                           borderRadius:
//                                                           BorderRadius.circular(10)),
//                                                       child: Stack(
//                                                         children: [
//                                                           Positioned(
//                                                             bottom: 0,
//                                                             child: Container(
//                                                               height: 25,
//                                                               width: size.width / 3.6,
//                                                               decoration: const BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.only(
//                                                                       bottomLeft: Radius
//                                                                           .circular(10),
//                                                                       bottomRight:
//                                                                       Radius
//                                                                           .circular(
//                                                                           10)),
//                                                                   color: Colors.black54),
//                                                               child:  Center(
//                                                                 child: Text(
//                                                                   snapshot.data['photoVideo'][index]['photo_title']+ ' (${snapshot.data['photoVideo'][index]['album_count']} pages)',
//
//                                                                   style: TextStyle(
//                                                                       fontSize: 12,
//                                                                       color: Colors.white,
//                                                                       fontWeight:
//                                                                       FontWeight.bold),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ))),
//                                         Center(
//                                           child: InkWell(
//                                             onTap: () {
//                                               Get.to(() => const All_photos());
//                                             },
//                                             child: const Text(
//                                               'See All Photos & Videos',
//                                               style: TextStyle(
//                                                   color: Colors.orange,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 14),
//                                             ),
//                                           ),
//                                         ),
//                                         const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Text(
//                                             'Chefs Choice',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: size.height / 5,
//                                           width: size.width,
//                                           child: ListView.builder(
//                                             itemBuilder: (_, index) {
//                                               return Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Container(
//                                                   height: size.height / 10,
//                                                   width: size.width / 3,
//                                                   decoration: const BoxDecoration(),
//                                                   child: Column(
//                                                     children: [
//                                                       Container(
//                                                         height: size.height / 10,
//                                                         width: size.width / 3,
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                             BorderRadius.circular(10),
//                                                             image: DecorationImage(
//                                                                 image: NetworkImage(
//                                                                     AppUrl.pic_url1+snapshot.data['chefChoice'][index]['image']),
//                                                                 fit: BoxFit.cover)),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.all(5.0),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                           children:  [
//                                                             Text(
//                                                               snapshot.data['chefChoice'][index]['title'],
//                                                               style: TextStyle(
//                                                                   color: Colors.black,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 16),
//                                                             ),
//                                                             Text(
//                                                               snapshot.data['chefChoice'][index]['have_to_eat'],
//                                                               style: TextStyle(
//                                                                   color: Colors.black,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 16),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             left: 5.0, right: 5),
//                                                         child: Row(
//                                                           children:  [
//                                                             Text(
//                                                               snapshot.data['chefChoice'][index]['price']+'   ',
//                                                               style: TextStyle(
//                                                                   color: Colors.orange,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 18),
//                                                             ),
//                                                             Text(
//                                                               'tk',
//                                                               style: TextStyle(
//                                                                   color: AppColors.price,
//                                                                   fontWeight:
//                                                                   FontWeight.w500,
//                                                                   fontSize: 16),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             shrinkWrap: true,
//                                             itemCount: snapshot.data['chefChoice'].length,
//                                             scrollDirection: Axis.horizontal,
//                                           ),
//                                         ),
//                                         // SizedBox(
//                                         //   height: size.height / 5,
//                                         //   width: size.width,
//                                         //   child: ListView.builder(
//                                         //     itemBuilder: (_, index) {
//                                         //       return Padding(
//                                         //         padding: const EdgeInsets.all(8.0),
//                                         //         child: Container(
//                                         //           height: size.height / 10,
//                                         //           width: size.width / 3,
//                                         //           decoration: const BoxDecoration(),
//                                         //           child: Column(
//                                         //             children: [
//                                         //               Container(
//                                         //                 height: size.height / 10,
//                                         //                 width: size.width / 3,
//                                         //                 decoration: BoxDecoration(
//                                         //                     borderRadius:
//                                         //                         BorderRadius.circular(10),
//                                         //                     image: DecorationImage(
//                                         //                         image: AssetImage(
//                                         //                             sliderList[index]),
//                                         //                         fit: BoxFit.cover)),
//                                         //               ),
//                                         //               Padding(
//                                         //                 padding: const EdgeInsets.all(5.0),
//                                         //                 child: Row(
//                                         //                   mainAxisAlignment:
//                                         //                       MainAxisAlignment
//                                         //                           .spaceBetween,
//                                         //                   children: const [
//                                         //                     Text(
//                                         //                       'Pasta',
//                                         //                       style: TextStyle(
//                                         //                           color: Colors.black,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 16),
//                                         //                     ),
//                                         //                     Text(
//                                         //                       '1:2',
//                                         //                       style: TextStyle(
//                                         //                           color: Colors.black,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 16),
//                                         //                     ),
//                                         //                   ],
//                                         //                 ),
//                                         //               ),
//                                         //               Padding(
//                                         //                 padding: const EdgeInsets.only(
//                                         //                     left: 5.0, right: 5),
//                                         //                 child: Row(
//                                         //                   children: const [
//                                         //                     Text(
//                                         //                       '320   ',
//                                         //                       style: TextStyle(
//                                         //                           color: Colors.orange,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 18),
//                                         //                     ),
//                                         //                     Text(
//                                         //                       'tk',
//                                         //                       style: TextStyle(
//                                         //                           color: AppColors.price,
//                                         //                           fontWeight:
//                                         //                               FontWeight.w500,
//                                         //                           fontSize: 16),
//                                         //                     ),
//                                         //                   ],
//                                         //                 ),
//                                         //               )
//                                         //             ],
//                                         //           ),
//                                         //         ),
//                                         //       );
//                                         //     },
//                                         //     shrinkWrap: true,
//                                         //     itemCount: 3,
//                                         //     scrollDirection: Axis.horizontal,
//                                         //   ),
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                   ScrollableListTab(
//                                       tab: const ListTab(
//                                         label: Text('Ratings & Reviews'),
//                                       ),
//                                       body: ListView(
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                                   children: [
//                                                     const Padding(
//                                                       padding: EdgeInsets.all(8.0),
//                                                       child: Text(
//                                                         "Ratings",
//                                                         style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 16,
//                                                             fontWeight: FontWeight.w600),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Row(
//                                                         children: const [
//                                                           Text(
//                                                             "4.5",
//                                                             style: TextStyle(
//                                                                 color: Colors.black,
//                                                                 fontSize: 40,
//                                                                 fontWeight:
//                                                                 FontWeight.w700),
//                                                           ),
//                                                           Text(
//                                                             "   Overall",
//                                                             style: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.w400),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 25,
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Row(
//                                                         children: const [
//                                                           Icon(Icons.star,
//                                                               color: Colors.yellow),
//                                                           Icon(Icons.star,
//                                                               color: Colors.yellow),
//                                                           Icon(Icons.star,
//                                                               color: Colors.yellow),
//                                                           Icon(Icons.star,
//                                                               color: Colors.yellow),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     const Padding(
//                                                       padding: EdgeInsets.all(8.0),
//                                                       child: Text(
//                                                         "80% would recommend it to a friend",
//                                                         style: TextStyle(
//                                                             color: Colors.grey,
//                                                             fontSize: 12,
//                                                             fontWeight: FontWeight.w400),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Row(
//                                                       children: const [
//                                                         Padding(
//                                                           padding: EdgeInsets.all(8.0),
//                                                           child: Text(
//                                                             "5",
//                                                             style: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.w400),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 100,
//                                                           child: LinearProgressIndicator(
//                                                             minHeight: 15,
//                                                             value: 1,
//                                                             backgroundColor: Colors.white,
//                                                             color: AppColors.mainColor,
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: const [
//                                                         Padding(
//                                                           padding: EdgeInsets.all(8.0),
//                                                           child: Text(
//                                                             "4",
//                                                             style: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.w400),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 100,
//                                                           child: LinearProgressIndicator(
//                                                             minHeight: 15,
//                                                             value: .7,
//                                                             backgroundColor: Colors.white,
//                                                             color: AppColors.mainColor,
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: const [
//                                                         Padding(
//                                                           padding: EdgeInsets.all(8.0),
//                                                           child: Text(
//                                                             "3",
//                                                             style: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.w400),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 100,
//                                                           child: LinearProgressIndicator(
//                                                             minHeight: 15,
//                                                             value: .4,
//                                                             backgroundColor: Colors.white,
//                                                             color: AppColors.mainColor,
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: const [
//                                                         Padding(
//                                                           padding: EdgeInsets.all(8.0),
//                                                           child: Text(
//                                                             "3",
//                                                             style: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.w400),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 100,
//                                                           child: LinearProgressIndicator(
//                                                             minHeight: 15,
//                                                             value: .2,
//                                                             backgroundColor: Colors.white,
//                                                             color: AppColors.mainColor,
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: const [
//                                                         Padding(
//                                                           padding: EdgeInsets.all(8.0),
//                                                           child: Text(
//                                                             "1",
//                                                             style: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.w400),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 100,
//                                                           child: LinearProgressIndicator(
//                                                             minHeight: 15,
//                                                             value: .1,
//                                                             backgroundColor: Colors.white,
//                                                             color: AppColors.mainColor,
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       )),
//                                   ScrollableListTab(
//                                       tab: const ListTab(
//                                         label: Text('Latest Reviews'),
//                                       ),
//                                       body: ListView(
//                                         shrinkWrap: true,
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         children: [
//                                           Column(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Container(
//                                                   height: size.height / 2.8,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     borderRadius: BorderRadius.circular(10),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey.withOpacity(0.2),
//
//                                                         spreadRadius: 2,
//
//                                                         blurRadius: 4,
//
//                                                         offset: const Offset(0,
//                                                             0), // changes position of shadow
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                     children: [
//                                                       Padding(
//                                                         padding: const EdgeInsets.all(8.0),
//                                                         child: Row(
//                                                           children: [
//                                                             const CircleAvatar(
//                                                               radius: 40,
//                                                               backgroundColor: Colors.grey,
//                                                               backgroundImage: AssetImage(
//                                                                   'assets/images/profile.jpg'),
//                                                             ),
//                                                             const Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Text(
//                                                                 'Tushar Al.',
//                                                                 style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 16,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Container(
//                                                               height: 30,
//                                                               width: 60,
//                                                               decoration: BoxDecoration(
//                                                                   color: Colors.green,
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(
//                                                                       18)),
//                                                               child: Row(
//                                                                 mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                                 children: const [
//                                                                   Text(
//                                                                     '4.5',
//                                                                     style: TextStyle(
//                                                                         fontWeight:
//                                                                         FontWeight.bold,
//                                                                         color:
//                                                                         Colors.white),
//                                                                   ),
//                                                                   Icon(Icons.star,
//                                                                       color: Colors.yellow)
//                                                                 ],
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       const Padding(
//                                                         padding: EdgeInsets.all(8.0),
//                                                         child: Text(
//                                                           "Visited the place during holiday..They work serve their pizza well and the crust...",
//                                                           style: TextStyle(
//                                                               color: Colors.grey,
//                                                               fontSize: 12,
//                                                               fontWeight: FontWeight.w400),
//                                                         ),
//                                                       ),
//                                                       const Padding(
//                                                         padding: EdgeInsets.all(8.0),
//                                                         child: Text(
//                                                           "Read more",
//                                                           style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontSize: 14,
//                                                               fontWeight: FontWeight.w400),
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: size.height / 8,
//                                                         width: size.width,
//                                                         child: ListView.builder(
//                                                           itemBuilder: (_, index) {
//                                                             return Padding(
//                                                               padding:
//                                                               const EdgeInsets.all(8.0),
//                                                               child: Container(
//                                                                 height: size.height / 10,
//                                                                 width: size.width / 3,
//                                                                 decoration:
//                                                                 const BoxDecoration(),
//                                                                 child: Column(
//                                                                   children: [
//                                                                     Container(
//                                                                       height:
//                                                                       size.height / 10,
//                                                                       width: size.width / 3,
//                                                                       decoration: BoxDecoration(
//                                                                           borderRadius:
//                                                                           BorderRadius
//                                                                               .circular(
//                                                                               10),
//                                                                           image: DecorationImage(
//                                                                               image: AssetImage(
//                                                                                   sliderList[
//                                                                                   index]),
//                                                                               fit: BoxFit
//                                                                                   .cover)),
//                                                                     ),
//                                                                     // Padding(
//                                                                     //   padding: const EdgeInsets.all(5.0),
//                                                                     //   child: Row(
//                                                                     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                     //     children: [
//                                                                     //       Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
//                                                                     //       Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
//                                                                     //     ],
//                                                                     //   ),
//                                                                     // ),
//                                                                     // Padding(
//                                                                     //   padding: const EdgeInsets.only(left: 5.0,right: 5),
//                                                                     //   child: Row(
//                                                                     //     children: [
//                                                                     //       Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
//                                                                     //       Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
//                                                                     //     ],
//                                                                     //   ),
//                                                                     // )
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           },
//                                                           shrinkWrap: true,
//                                                           itemCount: 3,
//                                                           scrollDirection: Axis.horizontal,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 20,
//                                               ),
//                                               Center(
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     Get.to(() => const all_reviews());
//                                                   },
//                                                   child: const Text(
//                                                     'See All Reviews',
//                                                     style: TextStyle(
//                                                         color: Colors.orange,
//                                                         fontWeight: FontWeight.w500,
//                                                         fontSize: 14),
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       )),
//                                   ScrollableListTab(
//                                       tab: const ListTab(
//                                         label: Text('Details'),
//                                       ),
//                                       body: ListView(
//                                         shrinkWrap: true,
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         children: [
//                                           const Padding(
//                                             padding: EdgeInsets.all(16.0),
//                                             child: Text(
//                                               "Address",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: const [
//                                                 Padding(
//                                                   padding: EdgeInsets.only(left: 8.0),
//                                                   child: Icon(
//                                                     Icons.location_pin,
//                                                     color: Colors.orange,
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                     child: Text(
//                                                       'Mirpur 12, Pallabi, E block, Line -06, House -21, Kalsi Dhaka 1216',
//                                                       style: TextStyle(
//                                                           color: Colors.grey,
//                                                           fontWeight: FontWeight.w400,
//                                                           fontSize: 16),
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                           Image.asset(
//                                             'assets/images/map.jpeg',
//                                             width: size.width,
//                                             height: size.height / 6,
//                                             fit: BoxFit.cover,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.no_food,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Cuisine",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "Deshi , Italian & Chinese",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.store,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Establishment Type",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "Rooftop",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.add_comment_outlined,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Sitting Type",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "Open Floor",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.add_comment_outlined,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Indoor Restaurant",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "Open Floor",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.wallet_giftcard,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Feature & Facilities",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 18.0),
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                       children: [
//                                                         Row(
//                                                           children: const [
//                                                             Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Icon(
//                                                                 Icons.smoking_rooms,
//                                                                 color: Colors.orange,
//                                                                 size: 20,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               'Smoking Zone',
//                                                               style: TextStyle(
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 14),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: const [
//                                                             Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Icon(
//                                                                 Icons.support,
//                                                                 color: Colors.orange,
//                                                                 size: 20,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               'Dj',
//                                                               style: TextStyle(
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 14),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: const [
//                                                             Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Icon(
//                                                                 Icons.support,
//                                                                 color: Colors.orange,
//                                                                 size: 20,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               'Kids Zone',
//                                                               style: TextStyle(
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 14),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: const [
//                                                             Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Icon(
//                                                                 Icons.support,
//                                                                 color: Colors.orange,
//                                                                 size: 20,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               'Lounge',
//                                                               style: TextStyle(
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 14),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: const [
//                                                             Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Icon(
//                                                                 Icons.support,
//                                                                 color: Colors.orange,
//                                                                 size: 20,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               'Sports screening',
//                                                               style: TextStyle(
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 14),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: const [
//                                                             Padding(
//                                                               padding: EdgeInsets.all(8.0),
//                                                               child: Icon(
//                                                                 Icons.support,
//                                                                 color: Colors.orange,
//                                                                 size: 20,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               'Private Dining',
//                                                               style: TextStyle(
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                   FontWeight.w400,
//                                                                   fontSize: 14),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(
//                                                       width: 15,
//                                                     ),
//                                                     Column(
//                                                         crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                         children: [
//                                                           Row(
//                                                             children: const [
//                                                               Padding(
//                                                                 padding:
//                                                                 EdgeInsets.all(8.0),
//                                                                 child: Icon(
//                                                                   Icons.airplay_outlined,
//                                                                   color: Colors.orange,
//                                                                   size: 20,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 'Live Performance',
//                                                                 style: TextStyle(
//                                                                     color: Colors.grey,
//                                                                     fontWeight:
//                                                                     FontWeight.w400,
//                                                                     fontSize: 14),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Row(
//                                                             children: const [
//                                                               Padding(
//                                                                 padding:
//                                                                 EdgeInsets.all(8.0),
//                                                                 child: Icon(
//                                                                   Icons.airplay_outlined,
//                                                                   color: Colors.orange,
//                                                                   size: 20,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 'Lift',
//                                                                 style: TextStyle(
//                                                                     color: Colors.grey,
//                                                                     fontWeight:
//                                                                     FontWeight.w400,
//                                                                     fontSize: 14),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Row(
//                                                             children: const [
//                                                               Padding(
//                                                                 padding:
//                                                                 EdgeInsets.all(8.0),
//                                                                 child: Icon(
//                                                                   Icons.airplay_outlined,
//                                                                   color: Colors.orange,
//                                                                   size: 20,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 'Poolside',
//                                                                 style: TextStyle(
//                                                                     color: Colors.grey,
//                                                                     fontWeight:
//                                                                     FontWeight.w400,
//                                                                     fontSize: 14),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Row(
//                                                             children: const [
//                                                               Padding(
//                                                                 padding:
//                                                                 EdgeInsets.all(8.0),
//                                                                 child: Icon(
//                                                                   Icons.airplay_outlined,
//                                                                   color: Colors.orange,
//                                                                   size: 20,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 'Gaming',
//                                                                 style: TextStyle(
//                                                                     color: Colors.grey,
//                                                                     fontWeight:
//                                                                     FontWeight.w400,
//                                                                     fontSize: 14),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Row(
//                                                             children: const [
//                                                               Padding(
//                                                                 padding:
//                                                                 EdgeInsets.all(8.0),
//                                                                 child: Icon(
//                                                                   Icons.airplay_outlined,
//                                                                   color: Colors.orange,
//                                                                   size: 20,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 'Library',
//                                                                 style: TextStyle(
//                                                                     color: Colors.grey,
//                                                                     fontWeight:
//                                                                     FontWeight.w400,
//                                                                     fontSize: 14),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Row(
//                                                             children: const [
//                                                               Padding(
//                                                                 padding:
//                                                                 EdgeInsets.all(8.0),
//                                                                 child: Icon(
//                                                                   Icons.airplay_outlined,
//                                                                   color: Colors.orange,
//                                                                   size: 20,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 'Mobile wallet accpeted',
//                                                                 style: TextStyle(
//                                                                     color: Colors.grey,
//                                                                     fontWeight:
//                                                                     FontWeight.w400,
//                                                                     fontSize: 14),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ]),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.group,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Guest Capacity",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "500 People",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.food_bank_outlined,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Must Try",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "Pizza , Chicken ,Pasta",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(16.0),
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.food_bank_outlined,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "Average Cost",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w600),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               "1000 for 2 , Lorem ipsum dolor tiamet",
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 const CircleAvatar(
//                                                   backgroundImage:
//                                                   AssetImage('assets/images/f1.png'),
//                                                   radius: 15,
//                                                 ),
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                     children: [
//                                                       const Padding(
//                                                         padding:
//                                                         EdgeInsets.only(left: 18.0),
//                                                         child: Text(
//                                                           "Pizza Hut is a louge service  that gives pizza all over the place. it does lorem ipsum tiamat dolor...",
//                                                           style: TextStyle(
//                                                               color: Colors.grey,
//                                                               fontSize: 16,
//                                                               fontWeight: FontWeight.w400),
//                                                         ),
//                                                       ),
//                                                       const SizedBox(
//                                                         height: 15,
//                                                       ),
//                                                       Row(
//                                                         children: const [
//                                                           Padding(
//                                                             padding:
//                                                             EdgeInsets.only(left: 18.0),
//                                                             child: Text(
//                                                               "Read more",
//                                                               style: TextStyle(
//                                                                   color: Colors.black,
//                                                                   fontSize: 16,
//                                                                   fontWeight:
//                                                                   FontWeight.w400),
//                                                             ),
//                                                           ),
//                                                           Icon(
//                                                             Icons.arrow_forward,
//                                                             color: Colors.black,
//                                                           )
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       )),
//                                 ],
//                               ),
//                             ),
//
//                           ],
//
//                         );},itemCount: 1,physics: NeverScrollableScrollPhysics(),)
//                     )
                  ];
                },body: Container(
                  height: size.height,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Expanded(
                        child: ScrollableListTabView(

                          tabHeight: 48,
                          bodyAnimationDuration: const Duration(milliseconds: 150),
                          tabAnimationCurve: Curves.easeOut,
                          tabAnimationDuration: const Duration(milliseconds: 200),
                          tabs: [
                            ScrollableListTab(
                              tab: const ListTab(
                                  label: Text('Offers',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  activeBackgroundColor: Colors.orange,
                                  showIconOnList: false),
                              body: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap:(){
                                      },
                                      child: const Text(
                                        'Browse by Offers',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                       SliverGridDelegateWithFixedCrossAxisCount(

                                          crossAxisCount: 3,
                                          childAspectRatio:
                                          1,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 0),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data['offerInfo'].length,
                                      itemBuilder: (_, index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: size.height / 8,
                                          width: size.width / 3.7,
                                          decoration: BoxDecoration(
                                              color: AppColors.bg_background2,
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                // const Text(
                                                //   'Upto',
                                                //   style: TextStyle(
                                                //       fontSize: 14,
                                                //       fontWeight: FontWeight.w400,
                                                //       color: Colors.white),
                                                // ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      snapshot.data['offerInfo'][index]['flat_discount'],
                                                      style: const TextStyle(
                                                          fontSize: 28,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white),
                                                    ),  snapshot.data['offerInfo'][index]['type']=="flat_discount"?const Text(
                                                     " % ",
                                                      style: TextStyle(
                                                          fontSize: 28,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white),
                                                    ):Container(),
                                                  ],
                                                ),
                                                 Text(
                                                   snapshot.data['offerInfo'][index]['type']=="flat_discount"?
                                                   "Flat Discount":
                                                   snapshot.data['offerInfo'][index]['type']=="conditional_discount"?"Condition":
                                                   snapshot.data['offerInfo'][index]['type']=="item_discount"?"Item":"Happy Hour",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() =>  resturent_offer(offerlist: snapshot.data['offerInfo'],));
                                      },
                                      child: const Text(
                                        'See All Offers',
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ) ,const SizedBox(
                                    height: 25,
                                  ),                                  Divider(thickness: 15,),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                            ScrollableListTab(
                              tab: const ListTab(
                                  label: Text('Menu',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  activeBackgroundColor: Colors.orange,
                                  showIconOnList: false),
                              body: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Food & Drinks Menu',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio:
                                          1,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 0),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data['foodDrinkmenu'].length,
                                      itemBuilder: (_, index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(right: 35,top: 8,
                                                child: Container(
                                                  child: Stack(
                                                    clipBehavior:Clip.none,
                                                    children: [
                                                      Positioned(
                                                        top:10,
                                                        child: Container(
                                                          height: size.height / 5.8,
                                                          width: size.width / 2.9,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Colors.white,border: Border.all(color: Colors.grey.withOpacity(.5))
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: size.height / 5,
                                                        width: size.width / 3.1,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: Colors.white,border: Border.all(color: Colors.grey.withOpacity(.5))
                                                        ),
                                                      ) ,
                                                    ],
                                                  ),
                                                ),
                                              ),

                                               InkWell(
                                                onTap:(){
                                                  Get.to(()=>test(picture: snapshot.data['foodDrinkmenu'][index]['album']));
                                                },
                                                child: Container(
                                                  height: size.height / 4,
                                                  width: size.width / 2.8,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              AppUrl.pic_url1+  snapshot.data['foodDrinkmenu'][index]['album'][0]['image']),
                                                          fit: BoxFit.cover),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),

                                                          spreadRadius: 2,

                                                          blurRadius: 4,

                                                          offset: const Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 35,
                                                          width: size.width / 2.8,
                                                          decoration: const BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(10),
                                                                  bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                      10)),
                                                              color: Colors.black54),
                                                          child:  Center(
                                                            child: Text(
                                                              snapshot.data['foodDrinkmenu'][index]['photo_title']+ ' (${snapshot.data['foodDrinkmenu'][index]['album_count']} pages)',
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ))),

                                SizedBox(height: 10,),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() =>  foodDrinks_seeAll(id: widget.id.toString(),));
                                      },
                                      child: const Text(
                                        'See All Menu',
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),  Padding(
                                    padding: const EdgeInsets.only(left: 80.0),
                                    child: Divider(thickness: 1,),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Best Selling Items',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height / 5,
                                    width: size.width,
                                    child: ListView.builder(
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (context) => CustomDialog(
                                                  height: size.height, width: size.width,
                                                  price:snapshot.data['bestSelling'][index]['price'],
                                                  title:  snapshot.data['bestSelling'][index]['title'],
                                                  image: AppUrl.pic_url1+snapshot.data['bestSelling'][index]['image'],
                                                  ratio:  snapshot.data['bestSelling'][index]['have_to_eat'],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height / 10,
                                              width: size.width / 3,
                                              decoration: const BoxDecoration(),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: size.height / 10,
                                                    width: size.width / 3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                AppUrl.pic_url1+snapshot.data['bestSelling'][index]['image']),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children:  [
                                                        Text(
                                                          snapshot.data['bestSelling'][index]['title'],
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          snapshot.data['bestSelling'][index]['have_to_eat'],
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 5.0, right: 5),
                                                    child: Row(
                                                      children:  [
                                                        Text(
                                                          snapshot.data['bestSelling'][index]['price']+'   ',
                                                          style: const TextStyle(
                                                              color: Colors.orange,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 18),
                                                        ),
                                                        const Text(
                                                          'tk',
                                                          style: TextStyle(
                                                              color: AppColors.price,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: snapshot.data['bestSelling'].length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 80.0),
                                    child: Divider(thickness: 1,),
                                  ),   const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Chefs Recommended Items',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height / 5,
                                    width: size.width,
                                    child: ListView.builder(
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (context) => CustomDialog(
                                                  height: size.height, width: size.width,
                                                  price:snapshot.data['chefChoice'][index]['price'],
                                                  title:  snapshot.data['chefChoice'][index]['title'],
                                                  image: AppUrl.pic_url1+snapshot.data['chefChoice'][index]['image'],
                                                  ratio:  snapshot.data['chefChoice'][index]['have_to_eat'],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height / 10,
                                              width: size.width / 3,
                                              decoration: const BoxDecoration(),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: size.height / 10,
                                                    width: size.width / 3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                AppUrl.pic_url1+snapshot.data['chefChoice'][index]['image']),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children:  [
                                                        Text(
                                                          snapshot.data['chefChoice'][index]['title'],
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          snapshot.data['chefChoice'][index]['have_to_eat'],
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 5.0, right: 5),
                                                    child: Row(
                                                      children:  [
                                                        Text(
                                                          snapshot.data['chefChoice'][index]['price']+'   ',
                                                          style: const TextStyle(
                                                              color: Colors.orange,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 18),
                                                        ),
                                                        const Text(
                                                          'tk',
                                                          style: TextStyle(
                                                              color: AppColors.price,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: snapshot.data['chefChoice'].length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                  Divider(thickness: 15,),

                                  // SizedBox(
                                  //   height: size.height / 5,
                                  //   width: size.width,
                                  //   child: ListView.builder(
                                  //     itemBuilder: (_, index) {
                                  //       return Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Container(
                                  //           height: size.height / 10,
                                  //           width: size.width / 3,
                                  //           decoration: const BoxDecoration(),
                                  //           child: Column(
                                  //             children: [
                                  //               Container(
                                  //                 height: size.height / 10,
                                  //                 width: size.width / 3,
                                  //                 decoration: BoxDecoration(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(10),
                                  //                     image: DecorationImage(
                                  //                         image: NetworkImage(AppUrl.pic_url1+
                                  //                             snapshot.data['bestSelling'][index]['image']),
                                  //                         fit: BoxFit.cover)),
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.all(5.0),
                                  //                 child: Row(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .spaceBetween,
                                  //                   children:  [
                                  //                     Text(
                                  //                       snapshot.data['bestSelling'][index]['title'],
                                  //                       style: TextStyle(
                                  //                           color: Colors.black,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                     Text(
                                  //                       snapshot.data['bestSelling'][index]['have_to_eat'],
                                  //                       style: TextStyle(
                                  //                           color: Colors.black,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(
                                  //                     left: 5.0, right: 5),
                                  //                 child: Row(
                                  //                   children:  [
                                  //                     Text(
                                  //                       snapshot.data['bestSelling'][index]['price']+'   ',
                                  //                       style: TextStyle(
                                  //                           color: Colors.orange,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 18),
                                  //                     ),
                                  //                     Text(
                                  //                       'tk',
                                  //                       style: TextStyle(
                                  //                           color: AppColors.price,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     },
                                  //     shrinkWrap: true,
                                  //     itemCount: 3,
                                  //     scrollDirection: Axis.horizontal,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            ScrollableListTab(
                              tab: const ListTab(
                                  label: Text('Photos',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  activeBackgroundColor: Colors.orange,
                                  showIconOnList: false),
                              body: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Photos & Videos',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio:
                                          1,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 0),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data['photoVideo'].length,
                                      itemBuilder: (_, index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  Get.to(()=>test(picture: snapshot.data['photoVideo'][index]['album']));

                                                },
                                                child: Container(
                                                  height: size.height / 4,
                                                  width: size.width / 2.8,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              AppUrl.pic_url1+snapshot.data['photoVideo'][index]['album'][0]['image']),
                                                          fit: BoxFit.cover),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),

                                                          spreadRadius: 2,

                                                          blurRadius: 4,

                                                          offset: const Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 35,
                                                          width: size.width / 2.8,
                                                          decoration: const BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(10),
                                                                  bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                      10)),
                                                              color: Colors.black54),
                                                          child:  Center(
                                                            child: Text(
                                                              snapshot.data['photoVideo'][index]['photo_title']+ ' (${snapshot.data['photoVideo'][index]['album_count']} pages)',

                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),SizedBox(height: 15,),

                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() =>  restu_phopto(id: widget.id.toString(),));
                                      },
                                      child: const Text(
                                        'See All Photos & Videos',
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),SizedBox(height: 15,),
                                  Divider(thickness: 15,),
                                  SizedBox(height: 15,),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Chefs Choice',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height / 5,
                                    width: size.width,
                                    child: ListView.builder(
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (context) => CustomDialog(
                                                    height: size.height, width: size.width,
                                                  price:snapshot.data['chefChoice'][index]['price'],
                                                  title:  snapshot.data['chefChoice'][index]['title'],
                                                  image: AppUrl.pic_url1+snapshot.data['chefChoice'][index]['image'],
                                                  ratio:  snapshot.data['chefChoice'][index]['have_to_eat'],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height / 10,
                                              width: size.width / 3,
                                              decoration: const BoxDecoration(),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: size.height / 10,
                                                    width: size.width / 3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                AppUrl.pic_url1+snapshot.data['chefChoice'][index]['image']),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children:  [
                                                        Text(
                                                          snapshot.data['chefChoice'][index]['title'],
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          snapshot.data['chefChoice'][index]['have_to_eat'],
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 5.0, right: 5),
                                                    child: Row(
                                                      children:  [
                                                        Text(
                                                          snapshot.data['chefChoice'][index]['price']+'   ',
                                                          style: const TextStyle(
                                                              color: Colors.orange,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 18),
                                                        ),
                                                        const Text(
                                                          'tk',
                                                          style: TextStyle(
                                                              color: AppColors.price,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: snapshot.data['chefChoice'].length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: size.height / 5,
                                  //   width: size.width,
                                  //   child: ListView.builder(
                                  //     itemBuilder: (_, index) {
                                  //       return Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Container(
                                  //           height: size.height / 10,
                                  //           width: size.width / 3,
                                  //           decoration: const BoxDecoration(),
                                  //           child: Column(
                                  //             children: [
                                  //               Container(
                                  //                 height: size.height / 10,
                                  //                 width: size.width / 3,
                                  //                 decoration: BoxDecoration(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(10),
                                  //                     image: DecorationImage(
                                  //                         image: AssetImage(
                                  //                             sliderList[index]),
                                  //                         fit: BoxFit.cover)),
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.all(5.0),
                                  //                 child: Row(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .spaceBetween,
                                  //                   children: const [
                                  //                     Text(
                                  //                       'Pasta',
                                  //                       style: TextStyle(
                                  //                           color: Colors.black,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                     Text(
                                  //                       '1:2',
                                  //                       style: TextStyle(
                                  //                           color: Colors.black,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(
                                  //                     left: 5.0, right: 5),
                                  //                 child: Row(
                                  //                   children: const [
                                  //                     Text(
                                  //                       '320   ',
                                  //                       style: TextStyle(
                                  //                           color: Colors.orange,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 18),
                                  //                     ),
                                  //                     Text(
                                  //                       'tk',
                                  //                       style: TextStyle(
                                  //                           color: AppColors.price,
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     },
                                  //     shrinkWrap: true,
                                  //     itemCount: 3,
                                  //     scrollDirection: Axis.horizontal,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            ScrollableListTab(
                                tab: const ListTab(
                                  activeBackgroundColor: Colors.orange,

                                  label: Text('Ratings & Reviews'),
                                ),
                                body: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Ratings",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children:  [
                                                    Text(
                                                      snapshot.data['rating'].toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 40,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                    ),
                                                    const Text(
                                                      "   Overall",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:  RatingBarIndicator(
                                                  rating: double.parse(snapshot.data['rating'].toString()),
                                                  itemBuilder: (context, index) => const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 50.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "80% would recommend it to a friend",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "5",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: LinearProgressIndicator(
                                                      minHeight: 15,
                                                      value: 1,
                                                      backgroundColor: Colors.white,
                                                      color: AppColors.mainColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "4",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: LinearProgressIndicator(
                                                      minHeight: 15,
                                                      value: .7,
                                                      backgroundColor: Colors.white,
                                                      color: AppColors.mainColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "3",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: LinearProgressIndicator(
                                                      minHeight: 15,
                                                      value: .4,
                                                      backgroundColor: Colors.white,
                                                      color: AppColors.mainColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "2",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: LinearProgressIndicator(
                                                      minHeight: 15,
                                                      value: .2,
                                                      backgroundColor: Colors.white,
                                                      color: AppColors.mainColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "1",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: LinearProgressIndicator(
                                                      minHeight: 15,
                                                      value: .1,
                                                      backgroundColor: Colors.white,
                                                      color: AppColors.mainColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    Container(
                                        height: size.height/7,
                                        width: size.width,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child:   SizedBox(
                                                  width: 70,

                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: AppColors.greenLight,
                                                        child: SvgPicture.asset('assets/images/food.svg'),
                                                      ),
                                                      Text(
                                                        'Food',
                                                        style: TextStyle(color: Colors.black),
                                                      ) ,Text(
                                                        snapshot.data['review'][0]['food_rating'].toString(),
                                                        style: TextStyle(color: Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ),
                                            Expanded(
                                                child:   SizedBox(
                                                  width: 70,

                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: AppColors.ora,
                                                        child: SvgPicture.asset('assets/images/service.svg'),
                                                      ),
                                                      Text(
                                                        'Service',
                                                        style: TextStyle(color: Colors.black),
                                                      ),Text(
                                                        snapshot.data['review'][0]['service_rating'].toString(),
                                                        style: TextStyle(color: Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ),
                                            Expanded(
                                                child:   SizedBox(
                                                  width: 70,

                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: AppColors.ambiance,
                                                        child: SvgPicture.asset('assets/images/group.svg',),
                                                      ),
                                                      Text(
                                                        'Ambience',
                                                        style: TextStyle(color: Colors.black,fontSize: 12),
                                                      ),Text(
                                                        snapshot.data['review'][0]['ambiance_rating'].toString(),
                                                        style: TextStyle(color: Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ),
                                            Expanded(
                                                child:   SizedBox(
                                                  width: 70,

                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: AppColors.pricing,
                                                        child: SvgPicture.asset('assets/images/price.svg',),
                                                      ),
                                                      Text(
                                                        'Pricing',
                                                        style: TextStyle(color: Colors.black,fontSize: 12),
                                                      ),Text(
                                                        snapshot.data['review'][0]['price_rating'].toString(),
                                                        style: TextStyle(color: Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ),
                                          ],
                                        ),
                                    )
                                  ],
                                )),
                            ScrollableListTab(
                                tab: const ListTab(
                                  activeBackgroundColor: Colors.orange,

                                  label: Text('Latest Reviews'),
                                ),
                                body: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      children: [
                                        snapshot.data['review'].length>0? SizedBox(
                                          height: size.height / 3,
                                          width: size.width/1.1,
                                          child: ListView.builder(itemBuilder: (_,index){
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: size.width/1.3,
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
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              snapshot.data['review'][index]['user']['name'].toString(),
                                                              style: const TextStyle(
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
                                                                  snapshot.data['review'][index]['overall_rating'],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color:
                                                                      Colors.white),
                                                                ),
                                                                const Icon(Icons.star,
                                                                    color: Colors.yellow)
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    snapshot.data['review'][index]['review_details']!=null?  Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                          snapshot.data['review'][index]['review_details'].toString(),
                                                        style: const TextStyle(
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
                                                                          AppUrl.pic_url1+snapshot.data['review'][index]['image']),
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
                                            );
                                          },itemCount: snapshot.data['review'].length,shrinkWrap: true,scrollDirection: Axis.horizontal,),
                                        ):const Text('No Reviews yet!',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(() =>  all_reviews(id: widget.id.toString(),));
                                            },
                                            child: const Text(
                                              'See All Reviews',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ), const SizedBox(
                                          height: 20,
                                        ),                                  Divider(thickness: 15,),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            ScrollableListTab(
                                tab: const ListTab(                                  activeBackgroundColor: Colors.orange,

                                  label: Text('Details'),
                                ),
                                body: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        "Address",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Icon(
                                              Icons.location_pin,
                                              color: Colors.orange,
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                                snapshot.data['basicInfo']['extra_info']['address']??'',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/map.jpeg',
                                      width: size.width,
                                      height: size.height / 6,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.no_food,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Cuisine",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        snapshot.data['basicInfo']['extra_info']['cuisine_type'],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.store,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Establishment Type",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        snapshot.data['basicInfo']['extra_info']['establisthment_type'],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.add_comment_outlined,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Sitting Type",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        snapshot.data['basicInfo']['extra_info']['sitting_type'],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children:  [
                                          const Icon(
                                            Icons.add_comment_outlined,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data['basicInfo']['restaurant_type'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        "Open Floor",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.wallet_giftcard,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Feature & Facilities",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Container(
                                        height: size.height/7,
                                        width: size.width,
                                        child: ListView.builder(itemBuilder: (_,index){
                                          return   Row(
                                            children:  [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.ac_unit,
                                                  color: Colors.orange,
                                                  size: 20,
                                                ),
                                              ),
                                              Text(
                                                snapshot.data['featureFacilities'][index]['restu_zone_info']['title'],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 14),
                                              )
                                            ],
                                          );
                                        },
                                          itemCount: snapshot.data['featureFacilities'].length,
                                          shrinkWrap: true,

                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.group,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Guest Capacity",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        snapshot.data['basicInfo']['extra_info']['guest_capacity']+   " People",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.food_bank_outlined,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Must Try",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        snapshot.data['basicInfo']['extra_info']['must_try'],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    snapshot.data['costFor']=='0'?Container():  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.food_bank_outlined,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Average Cost",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    snapshot.data['costFor']=='0'? Container():   Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                       snapshot.data['costFor'].toString()+" - Cost For 2",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    snapshot.data['basicInfo']['restaurant_description']==null?const SizedBox(height: 200,):Container(),
                                    snapshot.data['basicInfo']['restaurant_description']!=null? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           CircleAvatar(
                                            backgroundImage:
                                            NetworkImage(
                                              AppUrl.pic_url1+  snapshot.data['basicInfo']['extra_info']['profile_image']
                                            ),
                                            radius: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                 Padding(
                                                  padding:
                                                  const EdgeInsets.only(left: 18.0),
                                                  child: Text(
                                                    snapshot.data['basicInfo']['restaurant_description']??'',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              const SizedBox(height: 150,)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ):Container()
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),);
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text("No Resturent Fount"),
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
/*
          // SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // Container(
          //       //   height: MediaQuery.of(context).size.height/4,
          //       //   child: CarouselSlider.builder(
          //       //     options: CarouselOptions(
          //       //       scrollDirection: Axis.horizontal,
          //       //       scrollPhysics: AlwaysScrollableScrollPhysics(),
          //       //       height: 300,
          //       //       autoPlay: true,
          //       //       reverse: true,
          //       //       enlargeCenterPage: true,
          //       //       viewportFraction: 1,
          //       //     ),
          //       //     itemCount: sliderList.length,
          //       //
          //       //     itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          //       //
          //       //        Stack(
          //       //          clipBehavior: Clip.none,
          //       //          children: [
          //       //            Positioned(
          //       //              bottom: 0,
          //       //              child: new DotsIndicator(
          //       //                dotsCount: sliderList.length,
          //       //                position: 1,
          //       //              ),
          //       //            ),
          //       //            Container(
          //       //              height: size.height/5,
          //       //              width: size.width,
          //       //              decoration: BoxDecoration(
          //       //                  borderRadius: BorderRadius.circular(10),
          //       //                  image: DecorationImage(
          //       //                      image: AssetImage(sliderList[itemIndex]),
          //       //                      fit: BoxFit.cover
          //       //                  )
          //       //              ),
          //       //              // child: InkWell(
          //       //              //
          //       //              //     onTap: ()async{
          //       //              //       // var url=snapshot.data[itemIndex]['links'];
          //       //              //       // if (await canLaunch(url))
          //       //              //       //   await launch(url);
          //       //              //       // else
          //       //              //       //   // can't launch url, there is some error
          //       //              //       //   throw "Could not launch $url";
          //       //              //     },
          //       //              //     child:Image.asset('assets/images/ban.jpg',width: width,))
          //       //            ),
          //       //          ],
          //       //        )
          //       //   ),
          //       // ),
          //
          //   Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //
          //       Container(
          //         height: size.height/3.5,
          //
          //         child: PageIndicatorContainer(
          //           child: PageView.builder(
          //             itemCount: sliderList.length,
          //             itemBuilder: (BuildContext context, int itemIndex) {
          //               return Container(
          //                 height: size.height/3.5,
          //                 width: size.width,
          //                 decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                         image: AssetImage(sliderList[itemIndex]),
          //                         fit: BoxFit.cover
          //                     )
          //                 ),
          //               );
          //             },
          //           ),
          //           align: IndicatorAlign.bottom,
          //           length: 4,
          //           indicatorSpace: 10.0,
          //         ),
          //       ),
          //       Positioned(
          //           right: -5,
          //
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Container(
          //               height: size.height/18,
          //               width: size.width,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(left: 8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     CircleAvatar(
          //                       radius: 20,
          //                       backgroundColor: Colors.white,
          //                       child: Center(
          //
          //                         child: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,),
          //                       ),
          //                     ),
          //                     Row(
          //                       children: [
          //                         CircleAvatar(
          //                           radius: 20,
          //                           backgroundColor: Colors.white,
          //                           child: Center(
          //
          //                             child: Icon(Icons.bookmark_border,color: Colors.black,),
          //                           ),
          //                         ), SizedBox(width: 15,),CircleAvatar(
          //                           radius: 20,
          //                           backgroundColor: Colors.white,
          //                           child: Center(
          //
          //                             child: Icon(Icons.share_sharp,color: Colors.black,),
          //                           ),
          //                         ),
          //                       ],
          //                     )
          //
          //
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           )),
          //       Positioned(
          //           bottom: 10,
          //           right: 20,
          //           child: Container(
          //         height: size.height/18,
          //         width: size.width/3.6,
          //         decoration:BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: Colors.white,
          //
          //         ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Row(
          //                 children: [
          //                   Icon(Icons.image,color: Colors.black,),
          //                   Text("All Photos",style: TextStyle(
          //                     fontWeight: FontWeight.w500,fontSize: 14
          //                   ),)
          //                 ],
          //               ),
          //             ),
          //       )),
          //       Positioned(
          //           bottom: -60,
          //           left: 10,
          //
          //           child:     CircularProfileAvatar(
          //             '',
          //             child: Image.asset("assets/images/fl.jpg"),
          //             borderColor: Colors.white,
          //             borderWidth: 10,
          //             elevation: 2,
          //             radius: 70,
          //           ),) ,Positioned(
          //           bottom: -100,
          //           right: 20,
          //
          //           child:Column(
          //             children: [
          //               Container(
          //                 height: size.height/18,
          //                 decoration:BoxDecoration(
          //                   borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:Radius.circular(10), ),
          //                   color: AppColors.rating_back,
          //
          //                 ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Row(
          //                     children: [
          //
          //                       Text("4.5",style: TextStyle(
          //                           fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white
          //                       ),),
          //                       Icon(Icons.star,color: Colors.yellow,),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               Container(
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10), )
          //                 ),
          //                 child:Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Column(
          //                     children: [
          //
          //                       Text("1,550",style: TextStyle(
          //                           fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black
          //                       ),),
          //                       Text("Reviews",style: TextStyle(
          //                           fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black
          //                       ),),                          ],
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),)
          //
          //
          //     ],
          //   ),
          //       SizedBox(height: size.height/15,),
          //
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("Pizza Hut",style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 22,
          //               fontWeight: FontWeight.w600
          //             ),),
          //             SizedBox(height: 10,),
          //             Row(
          //               children: [
          //                 Icon(Icons.food_bank,color: AppColors.rating_back,),
          //                 Text("Chinease , Italian Cuisine",style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 14,fontWeight: FontWeight.w400
          //                 ),)
          //               ],
          //             ), SizedBox(height: 10,),
          //             Row(
          //               children: [
          //                 Icon(Icons.perm_contact_cal_rounded,color: AppColors.rating_back,),
          //                 Text("Mirpur 12, Pallabi Dhaka 1216",style: TextStyle(
          //                   color: Colors.grey.withOpacity(.7),
          //                   fontSize: 14,fontWeight: FontWeight.w400
          //                 ),)
          //               ],
          //             ),SizedBox(height: 10,),
          //             Row(
          //               children: [
          //                 Row(
          //                   children: [
          //                     Icon(Icons.home,color: AppColors.rating_back,),
          //                     Text("Outdoor & Indoor",style: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 14,fontWeight: FontWeight.w400
          //                     ),)
          //                   ],
          //                 ),
          //                 SizedBox(width: 10,),Row(
          //                   children: [
          //                     Icon(Icons.money,color: AppColors.rating_back,),
          //                     Text("600tk for 2 ",style: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 14,fontWeight: FontWeight.w400
          //                     ),)
          //                   ],
          //                 ),
          //               ],
          //             ),
          //             Container(
          //               height: size.height/2.5,
          //               child: ScrollableListTabView(
          //                 tabHeight: 48,
          //                 bodyAnimationDuration: const Duration(milliseconds: 150),
          //                 tabAnimationCurve: Curves.easeOut,
          //                 tabAnimationDuration: const Duration(milliseconds: 200),
          //                 tabs: [
          //                   ScrollableListTab(
          //
          //                       tab: ListTab(
          //                           label: Text('Offers',style:TextStyle(fontWeight: FontWeight.bold)),activeBackgroundColor: Colors.orange,
          //                           showIconOnList: false),
          //                       body:ListView(
          //                         physics: NeverScrollableScrollPhysics(),
          //                         shrinkWrap: true,
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Text('Browse by Offers',style: TextStyle(
          //                                 color: Colors.black,fontWeight: FontWeight.normal
          //                             ),),
          //                           ),
          //
          //                           GridView.builder(
          //                             shrinkWrap: true,
          //                             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //                                 maxCrossAxisExtent: 145,
          //                                 childAspectRatio:4/3,
          //                                 crossAxisSpacing: 8,
          //                                 mainAxisSpacing: 10),
          //                             physics: NeverScrollableScrollPhysics(),
          //                               itemCount: sliderList.length,
          //                             itemBuilder: (_, index) => Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Container(
          //                                 height: size.height/10,
          //                                 width: size.width/3,
          //                                 decoration: BoxDecoration(
          //                                   image: DecorationImage(image: AssetImage(sliderList[index])
          //                                     ,fit: BoxFit.cover
          //                                   ),
          //                                     boxShadow: [
          //                                       BoxShadow(
          //                                         color: Colors.grey.withOpacity(0.2),
          //
          //                                         spreadRadius: 2,
          //
          //                                         blurRadius: 4,
          //
          //                                         offset: Offset(
          //                                             0, 0), // changes position of shadow
          //                                       ),]    ,
          //                                     color: Colors.white,
          //                                     borderRadius:BorderRadius.circular(10)
          //                                 ),
          //
          //                               ),
          //                             )
          //                           ),
          //                           SizedBox(height: 25,),
          //                           Center(child: Text('See All Offers',style: TextStyle(
          //                             color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 14
          //                           ),),)
          //                         ],
          //                       ),),
          //                   ScrollableListTab(
          //
          //                     tab: ListTab(
          //                         label: Text('Menu',style:TextStyle(fontWeight: FontWeight.bold)),activeBackgroundColor: Colors.orange,
          //                         showIconOnList: false),
          //                     body:ListView(
          //                       physics: NeverScrollableScrollPhysics(),
          //                       shrinkWrap: true,
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text('Food & Drinks Menu',style: TextStyle(
          //                               color: Colors.black,fontWeight: FontWeight.normal
          //                           ),),
          //                         ),
          //
          //                         GridView.builder(
          //                             shrinkWrap: true,
          //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                               crossAxisCount: 3,
          //
          //                                 childAspectRatio: (itemWidth / itemHeight),
          //                                 crossAxisSpacing: 2,
          //                                 mainAxisSpacing: 1),
          //                             physics: NeverScrollableScrollPhysics(),
          //                             itemCount: sliderList.length,
          //                             itemBuilder: (_, index) => Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Stack(
          //                                 clipBehavior: Clip.none,
          //                                 children: [
          //
          //                                   Container(
          //                                     height: size.height/4,
          //                                     width: size.width/3,
          //                                     decoration: BoxDecoration(
          //                                         image: DecorationImage(image: AssetImage(sliderList[index])
          //                                             ,fit: BoxFit.cover
          //                                         ),
          //                                         boxShadow: [
          //                                           BoxShadow(
          //                                             color: Colors.grey.withOpacity(0.2),
          //
          //                                             spreadRadius: 2,
          //
          //                                             blurRadius: 4,
          //
          //                                             offset: Offset(
          //                                                 0, 0), // changes position of shadow
          //                                           ),]    ,
          //                                         color: Colors.white,
          //                                         borderRadius:BorderRadius.circular(10)
          //                                     ),
          //                                     child: Stack(
          //                                       children: [
          //                                         Positioned(
          //                                           bottom: 0,
          //                                           child: Container(
          //                                             height: 25,
          //                                             width: size.width/3.6,
          //                                             decoration: BoxDecoration(
          //                                               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          //                                                 color: Colors.black54
          //                                             ),child: Center(
          //                                             child: Text('Starter (2 pages)',style: TextStyle(
          //                                               fontSize: 12,
          //                                               color: Colors.white,fontWeight: FontWeight.bold
          //                                             ),),
          //                                           ),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //
          //                                   ),
          //                                 ],
          //                               )
          //                             )
          //                         ),
          //                         Center(child: Text('See All Menu',style: TextStyle(
          //                             color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 14
          //                         ),),),
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text('Best Selling Items',style: TextStyle(
          //                               color: Colors.black,fontWeight: FontWeight.bold
          //                           ),),
          //                         ),
          //                      Container(
          //                        height: size.height/5,
          //                        width: size.width,
          //                        child:    ListView.builder(itemBuilder: (_,index){
          //                          return Padding(
          //                            padding: const EdgeInsets.all(8.0),
          //                            child: Container(
          //                              height: size.height/10,
          //                              width: size.width/3,
          //                              decoration: BoxDecoration(
          //
          //                              ),
          //                              child: Container(
          //                                child: Column(
          //                                  children: [
          //                                    Container(height: size.height/10,
          //                                      width: size.width/3,
          //                                      decoration: BoxDecoration(
          //
          //                                        borderRadius: BorderRadius.circular(10),
          //                                        image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
          //                                      ),
          //                                    ),
          //                                    Padding(
          //                                      padding: const EdgeInsets.all(5.0),
          //                                      child: Row(
          //                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                        children: [
          //                                          Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                          Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                        ],
          //                                      ),
          //                                    ),
          //                                    Padding(
          //                                      padding: const EdgeInsets.only(left: 5.0,right: 5),
          //                                      child: Row(
          //                                        children: [
          //                                          Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
          //                                          Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                        ],
          //                                      ),
          //                                    )
          //                                  ],
          //                                ),
          //                              ),
          //                            ),
          //                          );
          //
          //                        },shrinkWrap: true,
          //                          itemCount: 3,
          //                          scrollDirection: Axis.horizontal,
          //                        ),
          //                      ),  Container(
          //                        height: size.height/5,
          //                        width: size.width,
          //                        child:    ListView.builder(itemBuilder: (_,index){
          //                          return Padding(
          //                            padding: const EdgeInsets.all(8.0),
          //                            child: Container(
          //                              height: size.height/10,
          //                              width: size.width/3,
          //                              decoration: BoxDecoration(
          //
          //                              ),
          //                              child: Container(
          //                                child: Column(
          //                                  children: [
          //                                    Container(height: size.height/10,
          //                                      width: size.width/3,
          //                                      decoration: BoxDecoration(
          //
          //                                        borderRadius: BorderRadius.circular(10),
          //                                        image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
          //                                      ),
          //                                    ),
          //                                    Padding(
          //                                      padding: const EdgeInsets.all(5.0),
          //                                      child: Row(
          //                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                        children: [
          //                                          Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                          Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                        ],
          //                                      ),
          //                                    ),
          //                                    Padding(
          //                                      padding: const EdgeInsets.only(left: 5.0,right: 5),
          //                                      child: Row(
          //                                        children: [
          //                                          Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
          //                                          Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                        ],
          //                                      ),
          //                                    )
          //                                  ],
          //                                ),
          //                              ),
          //                            ),
          //                          );
          //
          //                        },shrinkWrap: true,
          //                          itemCount: 3,
          //                          scrollDirection: Axis.horizontal,
          //                        ),
          //                      ),
          //
          //
          //
          //                       ],
          //                     ),),
          //                   ScrollableListTab(
          //
          //                     tab: ListTab(
          //                         label: Text('Photos',style:TextStyle(fontWeight: FontWeight.bold)),activeBackgroundColor: Colors.orange,
          //                         showIconOnList: false),
          //                     body:ListView(
          //                       physics: NeverScrollableScrollPhysics(),
          //                       shrinkWrap: true,
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text('Photos & Videos',style: TextStyle(
          //                               color: Colors.black,fontWeight: FontWeight.normal
          //                           ),),
          //                         ),
          //
          //                         GridView.builder(
          //                             shrinkWrap: true,
          //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                                 crossAxisCount: 3,
          //
          //                                 childAspectRatio: (itemWidth / itemHeight),
          //                                 crossAxisSpacing: 2,
          //                                 mainAxisSpacing: 1),
          //                             physics: NeverScrollableScrollPhysics(),
          //                             itemCount: sliderList.length,
          //                             itemBuilder: (_, index) => Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Stack(
          //                                   clipBehavior: Clip.none,
          //                                   children: [
          //
          //                                     Container(
          //                                       height: size.height/4,
          //                                       width: size.width/3,
          //                                       decoration: BoxDecoration(
          //                                           image: DecorationImage(image: AssetImage(sliderList[index])
          //                                               ,fit: BoxFit.cover
          //                                           ),
          //                                           boxShadow: [
          //                                             BoxShadow(
          //                                               color: Colors.grey.withOpacity(0.2),
          //
          //                                               spreadRadius: 2,
          //
          //                                               blurRadius: 4,
          //
          //                                               offset: Offset(
          //                                                   0, 0), // changes position of shadow
          //                                             ),]    ,
          //                                           color: Colors.white,
          //                                           borderRadius:BorderRadius.circular(10)
          //                                       ),
          //                                       child: Stack(
          //                                         children: [
          //                                           Positioned(
          //                                             bottom: 0,
          //                                             child: Container(
          //                                               height: 25,
          //                                               width: size.width/3.6,
          //                                               decoration: BoxDecoration(
          //                                                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          //                                                   color: Colors.black54
          //                                               ),child: Center(
          //                                               child: Text('Ambience (3)',style: TextStyle(
          //                                                   fontSize: 12,
          //                                                   color: Colors.white,fontWeight: FontWeight.bold
          //                                               ),),
          //                                             ),
          //                                             ),
          //                                           ),
          //                                         ],
          //                                       ),
          //
          //                                     ),
          //                                   ],
          //                                 )
          //                             )
          //                         ),
          //                         Center(child: Text('See All Menu',style: TextStyle(
          //                             color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 14
          //                         ),),),
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text('Best Selling Items',style: TextStyle(
          //                               color: Colors.black,fontWeight: FontWeight.bold
          //                           ),),
          //                         ),
          //                         Container(
          //                           height: size.height/5,
          //                           width: size.width,
          //                           child:    ListView.builder(itemBuilder: (_,index){
          //                             return Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Container(
          //                                 height: size.height/10,
          //                                 width: size.width/3,
          //                                 decoration: BoxDecoration(
          //
          //                                 ),
          //                                 child: Container(
          //                                   child: Column(
          //                                     children: [
          //                                       Container(height: size.height/10,
          //                                         width: size.width/3,
          //                                         decoration: BoxDecoration(
          //
          //                                             borderRadius: BorderRadius.circular(10),
          //                                             image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
          //                                         ),
          //                                       ),
          //                                       Padding(
          //                                         padding: const EdgeInsets.all(5.0),
          //                                         child: Row(
          //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                           children: [
          //                                             Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                             Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                           ],
          //                                         ),
          //                                       ),
          //                                       Padding(
          //                                         padding: const EdgeInsets.only(left: 5.0,right: 5),
          //                                         child: Row(
          //                                           children: [
          //                                             Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
          //                                             Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                           ],
          //                                         ),
          //                                       )
          //                                     ],
          //                                   ),
          //                                 ),
          //                               ),
          //                             );
          //
          //                           },shrinkWrap: true,
          //                             itemCount: 3,
          //                             scrollDirection: Axis.horizontal,
          //                           ),
          //                         ),  Container(
          //                           height: size.height/5,
          //                           width: size.width,
          //                           child:    ListView.builder(itemBuilder: (_,index){
          //                             return Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Container(
          //                                 height: size.height/10,
          //                                 width: size.width/3,
          //                                 decoration: BoxDecoration(
          //
          //                                 ),
          //                                 child: Container(
          //                                   child: Column(
          //                                     children: [
          //                                       Container(height: size.height/10,
          //                                         width: size.width/3,
          //                                         decoration: BoxDecoration(
          //
          //                                             borderRadius: BorderRadius.circular(10),
          //                                             image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
          //                                         ),
          //                                       ),
          //                                       Padding(
          //                                         padding: const EdgeInsets.all(5.0),
          //                                         child: Row(
          //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                           children: [
          //                                             Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                             Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                           ],
          //                                         ),
          //                                       ),
          //                                       Padding(
          //                                         padding: const EdgeInsets.only(left: 5.0,right: 5),
          //                                         child: Row(
          //                                           children: [
          //                                             Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
          //                                             Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
          //                                           ],
          //                                         ),
          //                                       )
          //                                     ],
          //                                   ),
          //                                 ),
          //                               ),
          //                             );
          //
          //                           },shrinkWrap: true,
          //                             itemCount: 3,
          //                             scrollDirection: Axis.horizontal,
          //                           ),
          //                         ),
          //
          //
          //
          //                       ],
          //                     ),),
          //                   ScrollableListTab(
          //                       tab: ListTab(label: Text('Label 4'), icon: Icon(Icons.add)),
          //                       body: ListView.builder(
          //                         shrinkWrap: true,
          //                         physics: NeverScrollableScrollPhysics(),
          //                         itemCount: 10,
          //                         itemBuilder: (_, index) => ListTile(
          //                           leading: Container(
          //                             height: 40,
          //                             width: 40,
          //                             decoration: BoxDecoration(
          //                                 shape: BoxShape.circle, color: Colors.grey),
          //                             alignment: Alignment.center,
          //                             child: Text(index.toString()),
          //                           ),
          //                           title: Text('List element $index'),
          //                         ),
          //                       )),
          //                   ScrollableListTab(
          //                       tab: ListTab(label: Text('Label 5'), icon: Icon(Icons.group)),
          //                       body: ListView.builder(
          //                         shrinkWrap: true,
          //                         physics: NeverScrollableScrollPhysics(),
          //                         itemCount: 10,
          //                         itemBuilder: (_, index) => ListTile(
          //                           leading: Container(
          //                             height: 40,
          //                             width: 40,
          //                             decoration: BoxDecoration(
          //                                 shape: BoxShape.circle, color: Colors.grey),
          //                             alignment: Alignment.center,
          //                             child: Text(index.toString()),
          //                           ),
          //                           title: Text('List element $index'),
          //                         ),
          //                       )),
          //                   ScrollableListTab(
          //                       tab: ListTab(label: Text('Label 6'), icon: Icon(Icons.subject)),
          //                       body: GridView.builder(
          //                         shrinkWrap: true,
          //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                             crossAxisCount: 2),
          //                         physics: NeverScrollableScrollPhysics(),
          //                         itemCount: 10,
          //                         itemBuilder: (_, index) => Card(
          //                           child: Center(child: Text('Card element $index')),
          //                         ),
          //                       )),
          //                   ScrollableListTab(
          //                       tab: ListTab(
          //                           label: Text('Label 7'),
          //                           icon: Icon(Icons.subject),
          //                           showIconOnList: true),
          //                       body: GridView.builder(
          //                         shrinkWrap: true,
          //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                             crossAxisCount: 2),
          //                         physics: NeverScrollableScrollPhysics(),
          //                         itemCount: 10,
          //                         itemBuilder: (_, index) => Card(
          //                           child: Center(child: Text('Card element $index')),
          //                         ),
          //                       )),
          //                   ScrollableListTab(
          //                       tab: ListTab(label: Text('Label 8'), icon: Icon(Icons.add)),
          //                       body: ListView.builder(
          //                         shrinkWrap: true,
          //                         physics: NeverScrollableScrollPhysics(),
          //                         itemCount: 10,
          //                         itemBuilder: (_, index) => ListTile(
          //                           leading: Container(
          //                             height: 40,
          //                             width: 40,
          //                             decoration: BoxDecoration(
          //                                 shape: BoxShape.circle, color: Colors.grey),
          //                             alignment: Alignment.center,
          //                             child: Text(index.toString()),
          //                           ),
          //                           title: Text('List element $index'),
          //                         ),
          //                       ))
          //                 ],
          //               ),
          //             ),
          //
          //           ],
          //         ),
          //       )
          //
          //
          //
          //     ],
          //   ),
          //
          //   ),
*/
          ):Scaffold(
        body: Column(
          children: [
            SizedBox(height: size.height/3,),
            Center(child: Lottie.asset('assets/images/loading.json',height: size.height/5)),
          ],
        ),
      ),
    );
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

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.height,
    required this.width,
    required this.price,
    required this.image,
    required this.title,
    required this.ratio,
  }) : super(key: key);

  final double height;
  final double width;
  final String image,ratio,title,price;

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
  DateTime selectedDate = DateTime.now();
  DateTime? picdate;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        picdate = picked;
      });
  }
  TextEditingController _timeC = TextEditingController();
  late Future<TimeOfDay?> selectedTimeRTL;
  static DateTime _eventdDate = DateTime.now();

  static var now =
  TimeOfDay.fromDateTime(DateTime.parse(_eventdDate.toString()));
  TimeOfDay timeOfDay = TimeOfDay.now();

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        _timeC.text = "${time.hour}:${time.minute}";

        pickedtime= _timeC.text;

      });
    }
  }
  var day,pickedtime;
  bool submit=false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: widget.height * 0.3,
            width: widget.width * 0.98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  height: widget.height/4.8,
                  width: widget.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.image,
                          ),fit: BoxFit.cover
                      ),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10)
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                      Column(crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("From TK "+widget.price,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                          Text(widget.ratio,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: -20,
              right: -15,
              child:InkWell (
                onTap: (){
                  Get.back();
                },
                child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.orange,width: 4)
            ),
                  child: const Icon(Icons.close,color: AppColors.orange,),
          ),
              ))
        ],
      ),
    );
  }
}
List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container();
    // SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // Container(
    //       //   height: MediaQuery.of(context).size.height/4,
    //       //   child: CarouselSlider.builder(
    //       //     options: CarouselOptions(
    //       //       scrollDirection: Axis.horizontal,
    //       //       scrollPhysics: AlwaysScrollableScrollPhysics(),
    //       //       height: 300,
    //       //       autoPlay: true,
    //       //       reverse: true,
    //       //       enlargeCenterPage: true,
    //       //       viewportFraction: 1,
    //       //     ),
    //       //     itemCount: sliderList.length,
    //       //
    //       //     itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
    //       //
    //       //        Stack(
    //       //          clipBehavior: Clip.none,
    //       //          children: [
    //       //            Positioned(
    //       //              bottom: 0,
    //       //              child: new DotsIndicator(
    //       //                dotsCount: sliderList.length,
    //       //                position: 1,
    //       //              ),
    //       //            ),
    //       //            Container(
    //       //              height: size.height/5,
    //       //              width: size.width,
    //       //              decoration: BoxDecoration(
    //       //                  borderRadius: BorderRadius.circular(10),
    //       //                  image: DecorationImage(
    //       //                      image: AssetImage(sliderList[itemIndex]),
    //       //                      fit: BoxFit.cover
    //       //                  )
    //       //              ),
    //       //              // child: InkWell(
    //       //              //
    //       //              //     onTap: ()async{
    //       //              //       // var url=snapshot.data[itemIndex]['links'];
    //       //              //       // if (await canLaunch(url))
    //       //              //       //   await launch(url);
    //       //              //       // else
    //       //              //       //   // can't launch url, there is some error
    //       //              //       //   throw "Could not launch $url";
    //       //              //     },
    //       //              //     child:Image.asset('assets/images/ban.jpg',width: width,))
    //       //            ),
    //       //          ],
    //       //        )
    //       //   ),
    //       // ),
    //
    //   Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //
    //       Container(
    //         height: size.height/3.5,
    //
    //         child: PageIndicatorContainer(
    //           child: PageView.builder(
    //             itemCount: sliderList.length,
    //             itemBuilder: (BuildContext context, int itemIndex) {
    //               return Container(
    //                 height: size.height/3.5,
    //                 width: size.width,
    //                 decoration: BoxDecoration(
    //                     image: DecorationImage(
    //                         image: AssetImage(sliderList[itemIndex]),
    //                         fit: BoxFit.cover
    //                     )
    //                 ),
    //               );
    //             },
    //           ),
    //           align: IndicatorAlign.bottom,
    //           length: 4,
    //           indicatorSpace: 10.0,
    //         ),
    //       ),
    //       Positioned(
    //           right: -5,
    //
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Container(
    //               height: size.height/18,
    //               width: size.width,
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     CircleAvatar(
    //                       radius: 20,
    //                       backgroundColor: Colors.white,
    //                       child: Center(
    //
    //                         child: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,),
    //                       ),
    //                     ),
    //                     Row(
    //                       children: [
    //                         CircleAvatar(
    //                           radius: 20,
    //                           backgroundColor: Colors.white,
    //                           child: Center(
    //
    //                             child: Icon(Icons.bookmark_border,color: Colors.black,),
    //                           ),
    //                         ), SizedBox(width: 15,),CircleAvatar(
    //                           radius: 20,
    //                           backgroundColor: Colors.white,
    //                           child: Center(
    //
    //                             child: Icon(Icons.share_sharp,color: Colors.black,),
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //
    //
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           )),
    //       Positioned(
    //           bottom: 10,
    //           right: 20,
    //           child: Container(
    //         height: size.height/18,
    //         width: size.width/3.6,
    //         decoration:BoxDecoration(
    //           borderRadius: BorderRadius.circular(10),
    //           color: Colors.white,
    //
    //         ),
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 children: [
    //                   Icon(Icons.image,color: Colors.black,),
    //                   Text("All Photos",style: TextStyle(
    //                     fontWeight: FontWeight.w500,fontSize: 14
    //                   ),)
    //                 ],
    //               ),
    //             ),
    //       )),
    //       Positioned(
    //           bottom: -60,
    //           left: 10,
    //
    //           child:     CircularProfileAvatar(
    //             '',
    //             child: Image.asset("assets/images/fl.jpg"),
    //             borderColor: Colors.white,
    //             borderWidth: 10,
    //             elevation: 2,
    //             radius: 70,
    //           ),) ,Positioned(
    //           bottom: -100,
    //           right: 20,
    //
    //           child:Column(
    //             children: [
    //               Container(
    //                 height: size.height/18,
    //                 decoration:BoxDecoration(
    //                   borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:Radius.circular(10), ),
    //                   color: AppColors.rating_back,
    //
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Row(
    //                     children: [
    //
    //                       Text("4.5",style: TextStyle(
    //                           fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white
    //                       ),),
    //                       Icon(Icons.star,color: Colors.yellow,),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10), )
    //                 ),
    //                 child:Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     children: [
    //
    //                       Text("1,550",style: TextStyle(
    //                           fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black
    //                       ),),
    //                       Text("Reviews",style: TextStyle(
    //                           fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black
    //                       ),),                          ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),)
    //
    //
    //     ],
    //   ),
    //       SizedBox(height: size.height/15,),
    //
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text("Pizza Hut",style: TextStyle(
    //               color: Colors.black,
    //               fontSize: 22,
    //               fontWeight: FontWeight.w600
    //             ),),
    //             SizedBox(height: 10,),
    //             Row(
    //               children: [
    //                 Icon(Icons.food_bank,color: AppColors.rating_back,),
    //                 Text("Chinease , Italian Cuisine",style: TextStyle(
    //                   color: Colors.black,
    //                   fontSize: 14,fontWeight: FontWeight.w400
    //                 ),)
    //               ],
    //             ), SizedBox(height: 10,),
    //             Row(
    //               children: [
    //                 Icon(Icons.perm_contact_cal_rounded,color: AppColors.rating_back,),
    //                 Text("Mirpur 12, Pallabi Dhaka 1216",style: TextStyle(
    //                   color: Colors.grey.withOpacity(.7),
    //                   fontSize: 14,fontWeight: FontWeight.w400
    //                 ),)
    //               ],
    //             ),SizedBox(height: 10,),
    //             Row(
    //               children: [
    //                 Row(
    //                   children: [
    //                     Icon(Icons.home,color: AppColors.rating_back,),
    //                     Text("Outdoor & Indoor",style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 14,fontWeight: FontWeight.w400
    //                     ),)
    //                   ],
    //                 ),
    //                 SizedBox(width: 10,),Row(
    //                   children: [
    //                     Icon(Icons.money,color: AppColors.rating_back,),
    //                     Text("600tk for 2 ",style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 14,fontWeight: FontWeight.w400
    //                     ),)
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Container(
    //               height: size.height/2.5,
    //               child: ScrollableListTabView(
    //                 tabHeight: 48,
    //                 bodyAnimationDuration: const Duration(milliseconds: 150),
    //                 tabAnimationCurve: Curves.easeOut,
    //                 tabAnimationDuration: const Duration(milliseconds: 200),
    //                 tabs: [
    //                   ScrollableListTab(
    //
    //                       tab: ListTab(
    //                           label: Text('Offers',style:TextStyle(fontWeight: FontWeight.bold)),activeBackgroundColor: Colors.orange,
    //                           showIconOnList: false),
    //                       body:ListView(
    //                         physics: NeverScrollableScrollPhysics(),
    //                         shrinkWrap: true,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text('Browse by Offers',style: TextStyle(
    //                                 color: Colors.black,fontWeight: FontWeight.normal
    //                             ),),
    //                           ),
    //
    //                           GridView.builder(
    //                             shrinkWrap: true,
    //                             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //                                 maxCrossAxisExtent: 145,
    //                                 childAspectRatio:4/3,
    //                                 crossAxisSpacing: 8,
    //                                 mainAxisSpacing: 10),
    //                             physics: NeverScrollableScrollPhysics(),
    //                               itemCount: sliderList.length,
    //                             itemBuilder: (_, index) => Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Container(
    //                                 height: size.height/10,
    //                                 width: size.width/3,
    //                                 decoration: BoxDecoration(
    //                                   image: DecorationImage(image: AssetImage(sliderList[index])
    //                                     ,fit: BoxFit.cover
    //                                   ),
    //                                     boxShadow: [
    //                                       BoxShadow(
    //                                         color: Colors.grey.withOpacity(0.2),
    //
    //                                         spreadRadius: 2,
    //
    //                                         blurRadius: 4,
    //
    //                                         offset: Offset(
    //                                             0, 0), // changes position of shadow
    //                                       ),]    ,
    //                                     color: Colors.white,
    //                                     borderRadius:BorderRadius.circular(10)
    //                                 ),
    //
    //                               ),
    //                             )
    //                           ),
    //                           SizedBox(height: 25,),
    //                           Center(child: Text('See All Offers',style: TextStyle(
    //                             color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 14
    //                           ),),)
    //                         ],
    //                       ),),
    //                   ScrollableListTab(
    //
    //                     tab: ListTab(
    //                         label: Text('Menu',style:TextStyle(fontWeight: FontWeight.bold)),activeBackgroundColor: Colors.orange,
    //                         showIconOnList: false),
    //                     body:ListView(
    //                       physics: NeverScrollableScrollPhysics(),
    //                       shrinkWrap: true,
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Text('Food & Drinks Menu',style: TextStyle(
    //                               color: Colors.black,fontWeight: FontWeight.normal
    //                           ),),
    //                         ),
    //
    //                         GridView.builder(
    //                             shrinkWrap: true,
    //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                               crossAxisCount: 3,
    //
    //                                 childAspectRatio: (itemWidth / itemHeight),
    //                                 crossAxisSpacing: 2,
    //                                 mainAxisSpacing: 1),
    //                             physics: NeverScrollableScrollPhysics(),
    //                             itemCount: sliderList.length,
    //                             itemBuilder: (_, index) => Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Stack(
    //                                 clipBehavior: Clip.none,
    //                                 children: [
    //
    //                                   Container(
    //                                     height: size.height/4,
    //                                     width: size.width/3,
    //                                     decoration: BoxDecoration(
    //                                         image: DecorationImage(image: AssetImage(sliderList[index])
    //                                             ,fit: BoxFit.cover
    //                                         ),
    //                                         boxShadow: [
    //                                           BoxShadow(
    //                                             color: Colors.grey.withOpacity(0.2),
    //
    //                                             spreadRadius: 2,
    //
    //                                             blurRadius: 4,
    //
    //                                             offset: Offset(
    //                                                 0, 0), // changes position of shadow
    //                                           ),]    ,
    //                                         color: Colors.white,
    //                                         borderRadius:BorderRadius.circular(10)
    //                                     ),
    //                                     child: Stack(
    //                                       children: [
    //                                         Positioned(
    //                                           bottom: 0,
    //                                           child: Container(
    //                                             height: 25,
    //                                             width: size.width/3.6,
    //                                             decoration: BoxDecoration(
    //                                               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
    //                                                 color: Colors.black54
    //                                             ),child: Center(
    //                                             child: Text('Starter (2 pages)',style: TextStyle(
    //                                               fontSize: 12,
    //                                               color: Colors.white,fontWeight: FontWeight.bold
    //                                             ),),
    //                                           ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //
    //                                   ),
    //                                 ],
    //                               )
    //                             )
    //                         ),
    //                         Center(child: Text('See All Menu',style: TextStyle(
    //                             color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 14
    //                         ),),),
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Text('Best Selling Items',style: TextStyle(
    //                               color: Colors.black,fontWeight: FontWeight.bold
    //                           ),),
    //                         ),
    //                      Container(
    //                        height: size.height/5,
    //                        width: size.width,
    //                        child:    ListView.builder(itemBuilder: (_,index){
    //                          return Padding(
    //                            padding: const EdgeInsets.all(8.0),
    //                            child: Container(
    //                              height: size.height/10,
    //                              width: size.width/3,
    //                              decoration: BoxDecoration(
    //
    //                              ),
    //                              child: Container(
    //                                child: Column(
    //                                  children: [
    //                                    Container(height: size.height/10,
    //                                      width: size.width/3,
    //                                      decoration: BoxDecoration(
    //
    //                                        borderRadius: BorderRadius.circular(10),
    //                                        image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
    //                                      ),
    //                                    ),
    //                                    Padding(
    //                                      padding: const EdgeInsets.all(5.0),
    //                                      child: Row(
    //                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                        children: [
    //                                          Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                          Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                        ],
    //                                      ),
    //                                    ),
    //                                    Padding(
    //                                      padding: const EdgeInsets.only(left: 5.0,right: 5),
    //                                      child: Row(
    //                                        children: [
    //                                          Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
    //                                          Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                        ],
    //                                      ),
    //                                    )
    //                                  ],
    //                                ),
    //                              ),
    //                            ),
    //                          );
    //
    //                        },shrinkWrap: true,
    //                          itemCount: 3,
    //                          scrollDirection: Axis.horizontal,
    //                        ),
    //                      ),  Container(
    //                        height: size.height/5,
    //                        width: size.width,
    //                        child:    ListView.builder(itemBuilder: (_,index){
    //                          return Padding(
    //                            padding: const EdgeInsets.all(8.0),
    //                            child: Container(
    //                              height: size.height/10,
    //                              width: size.width/3,
    //                              decoration: BoxDecoration(
    //
    //                              ),
    //                              child: Container(
    //                                child: Column(
    //                                  children: [
    //                                    Container(height: size.height/10,
    //                                      width: size.width/3,
    //                                      decoration: BoxDecoration(
    //
    //                                        borderRadius: BorderRadius.circular(10),
    //                                        image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
    //                                      ),
    //                                    ),
    //                                    Padding(
    //                                      padding: const EdgeInsets.all(5.0),
    //                                      child: Row(
    //                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                        children: [
    //                                          Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                          Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                        ],
    //                                      ),
    //                                    ),
    //                                    Padding(
    //                                      padding: const EdgeInsets.only(left: 5.0,right: 5),
    //                                      child: Row(
    //                                        children: [
    //                                          Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
    //                                          Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                        ],
    //                                      ),
    //                                    )
    //                                  ],
    //                                ),
    //                              ),
    //                            ),
    //                          );
    //
    //                        },shrinkWrap: true,
    //                          itemCount: 3,
    //                          scrollDirection: Axis.horizontal,
    //                        ),
    //                      ),
    //
    //
    //
    //                       ],
    //                     ),),
    //                   ScrollableListTab(
    //
    //                     tab: ListTab(
    //                         label: Text('Photos',style:TextStyle(fontWeight: FontWeight.bold)),activeBackgroundColor: Colors.orange,
    //                         showIconOnList: false),
    //                     body:ListView(
    //                       physics: NeverScrollableScrollPhysics(),
    //                       shrinkWrap: true,
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Text('Photos & Videos',style: TextStyle(
    //                               color: Colors.black,fontWeight: FontWeight.normal
    //                           ),),
    //                         ),
    //
    //                         GridView.builder(
    //                             shrinkWrap: true,
    //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                                 crossAxisCount: 3,
    //
    //                                 childAspectRatio: (itemWidth / itemHeight),
    //                                 crossAxisSpacing: 2,
    //                                 mainAxisSpacing: 1),
    //                             physics: NeverScrollableScrollPhysics(),
    //                             itemCount: sliderList.length,
    //                             itemBuilder: (_, index) => Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Stack(
    //                                   clipBehavior: Clip.none,
    //                                   children: [
    //
    //                                     Container(
    //                                       height: size.height/4,
    //                                       width: size.width/3,
    //                                       decoration: BoxDecoration(
    //                                           image: DecorationImage(image: AssetImage(sliderList[index])
    //                                               ,fit: BoxFit.cover
    //                                           ),
    //                                           boxShadow: [
    //                                             BoxShadow(
    //                                               color: Colors.grey.withOpacity(0.2),
    //
    //                                               spreadRadius: 2,
    //
    //                                               blurRadius: 4,
    //
    //                                               offset: Offset(
    //                                                   0, 0), // changes position of shadow
    //                                             ),]    ,
    //                                           color: Colors.white,
    //                                           borderRadius:BorderRadius.circular(10)
    //                                       ),
    //                                       child: Stack(
    //                                         children: [
    //                                           Positioned(
    //                                             bottom: 0,
    //                                             child: Container(
    //                                               height: 25,
    //                                               width: size.width/3.6,
    //                                               decoration: BoxDecoration(
    //                                                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
    //                                                   color: Colors.black54
    //                                               ),child: Center(
    //                                               child: Text('Ambience (3)',style: TextStyle(
    //                                                   fontSize: 12,
    //                                                   color: Colors.white,fontWeight: FontWeight.bold
    //                                               ),),
    //                                             ),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //
    //                                     ),
    //                                   ],
    //                                 )
    //                             )
    //                         ),
    //                         Center(child: Text('See All Menu',style: TextStyle(
    //                             color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 14
    //                         ),),),
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Text('Best Selling Items',style: TextStyle(
    //                               color: Colors.black,fontWeight: FontWeight.bold
    //                           ),),
    //                         ),
    //                         Container(
    //                           height: size.height/5,
    //                           width: size.width,
    //                           child:    ListView.builder(itemBuilder: (_,index){
    //                             return Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Container(
    //                                 height: size.height/10,
    //                                 width: size.width/3,
    //                                 decoration: BoxDecoration(
    //
    //                                 ),
    //                                 child: Container(
    //                                   child: Column(
    //                                     children: [
    //                                       Container(height: size.height/10,
    //                                         width: size.width/3,
    //                                         decoration: BoxDecoration(
    //
    //                                             borderRadius: BorderRadius.circular(10),
    //                                             image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                         padding: const EdgeInsets.all(5.0),
    //                                         child: Row(
    //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                             Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                         padding: const EdgeInsets.only(left: 5.0,right: 5),
    //                                         child: Row(
    //                                           children: [
    //                                             Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
    //                                             Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                           ],
    //                                         ),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             );
    //
    //                           },shrinkWrap: true,
    //                             itemCount: 3,
    //                             scrollDirection: Axis.horizontal,
    //                           ),
    //                         ),  Container(
    //                           height: size.height/5,
    //                           width: size.width,
    //                           child:    ListView.builder(itemBuilder: (_,index){
    //                             return Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Container(
    //                                 height: size.height/10,
    //                                 width: size.width/3,
    //                                 decoration: BoxDecoration(
    //
    //                                 ),
    //                                 child: Container(
    //                                   child: Column(
    //                                     children: [
    //                                       Container(height: size.height/10,
    //                                         width: size.width/3,
    //                                         decoration: BoxDecoration(
    //
    //                                             borderRadius: BorderRadius.circular(10),
    //                                             image: DecorationImage(image: AssetImage(sliderList[index]),fit: BoxFit.cover)
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                         padding: const EdgeInsets.all(5.0),
    //                                         child: Row(
    //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text('Pasta',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                             Text('1:2',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                         padding: const EdgeInsets.only(left: 5.0,right: 5),
    //                                         child: Row(
    //                                           children: [
    //                                             Text('320   ',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 18),),
    //                                             Text('tk',style: TextStyle(color: AppColors.price,fontWeight: FontWeight.w500,fontSize: 16),),
    //                                           ],
    //                                         ),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             );
    //
    //                           },shrinkWrap: true,
    //                             itemCount: 3,
    //                             scrollDirection: Axis.horizontal,
    //                           ),
    //                         ),
    //
    //
    //
    //                       ],
    //                     ),),
    //                   ScrollableListTab(
    //                       tab: ListTab(label: Text('Label 4'), icon: Icon(Icons.add)),
    //                       body: ListView.builder(
    //                         shrinkWrap: true,
    //                         physics: NeverScrollableScrollPhysics(),
    //                         itemCount: 10,
    //                         itemBuilder: (_, index) => ListTile(
    //                           leading: Container(
    //                             height: 40,
    //                             width: 40,
    //                             decoration: BoxDecoration(
    //                                 shape: BoxShape.circle, color: Colors.grey),
    //                             alignment: Alignment.center,
    //                             child: Text(index.toString()),
    //                           ),
    //                           title: Text('List element $index'),
    //                         ),
    //                       )),
    //                   ScrollableListTab(
    //                       tab: ListTab(label: Text('Label 5'), icon: Icon(Icons.group)),
    //                       body: ListView.builder(
    //                         shrinkWrap: true,
    //                         physics: NeverScrollableScrollPhysics(),
    //                         itemCount: 10,
    //                         itemBuilder: (_, index) => ListTile(
    //                           leading: Container(
    //                             height: 40,
    //                             width: 40,
    //                             decoration: BoxDecoration(
    //                                 shape: BoxShape.circle, color: Colors.grey),
    //                             alignment: Alignment.center,
    //                             child: Text(index.toString()),
    //                           ),
    //                           title: Text('List element $index'),
    //                         ),
    //                       )),
    //                   ScrollableListTab(
    //                       tab: ListTab(label: Text('Label 6'), icon: Icon(Icons.subject)),
    //                       body: GridView.builder(
    //                         shrinkWrap: true,
    //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                             crossAxisCount: 2),
    //                         physics: NeverScrollableScrollPhysics(),
    //                         itemCount: 10,
    //                         itemBuilder: (_, index) => Card(
    //                           child: Center(child: Text('Card element $index')),
    //                         ),
    //                       )),
    //                   ScrollableListTab(
    //                       tab: ListTab(
    //                           label: Text('Label 7'),
    //                           icon: Icon(Icons.subject),
    //                           showIconOnList: true),
    //                       body: GridView.builder(
    //                         shrinkWrap: true,
    //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                             crossAxisCount: 2),
    //                         physics: NeverScrollableScrollPhysics(),
    //                         itemCount: 10,
    //                         itemBuilder: (_, index) => Card(
    //                           child: Center(child: Text('Card element $index')),
    //                         ),
    //                       )),
    //                   ScrollableListTab(
    //                       tab: ListTab(label: Text('Label 8'), icon: Icon(Icons.add)),
    //                       body: ListView.builder(
    //                         shrinkWrap: true,
    //                         physics: NeverScrollableScrollPhysics(),
    //                         itemCount: 10,
    //                         itemBuilder: (_, index) => ListTile(
    //                           leading: Container(
    //                             height: 40,
    //                             width: 40,
    //                             decoration: BoxDecoration(
    //                                 shape: BoxShape.circle, color: Colors.grey),
    //                             alignment: Alignment.center,
    //                             child: Text(index.toString()),
    //                           ),
    //                           title: Text('List element $index'),
    //                         ),
    //                       ))
    //                 ],
    //               ),
    //             ),
    //
    //           ],
    //         ),
    //       )
    //
    //
    //
    //     ],
    //   ),
    //
    //   );
  });
}

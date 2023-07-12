import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/HomePage/HomeController.dart';
import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LiveCourse/CourseDetails.dart';

import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future? homepage;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.homepage), headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body);
      return userData1;
    } else {
      if (kDebugMode) {
        print("post have no Data${response.body}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    homepage = allExperience();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none_outlined,color: Colors.black87,),
          )
        ],
        title:Obx(()=> Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.name.value.toString(),style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 16)),
            Text(controller.phone.value.toString(),style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 12)),
          ],
        ),),
        leading:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.mainColor,
            child: Image.asset('assets/images/luser.png',height: 20,width: 20,color: Colors.white,)
          ),
        ),
      ),
      body: FutureBuilder(
        future: homepage,
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 6,
                    color: AppColors.Divider,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'My Courses',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Lottie.asset('assets/images/empty.json',
                        height: size.height / 7),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Text(
                        "Think outside the box. Enroll Courses can be found here"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 6,
                    color: AppColors.Divider,
                  ),
                 //region experience
                 /* const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Explore Course Categories',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),*/
                  //endregoin
                /*  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Container(
                      height: size.height / 4,
                      width: size.width,
                      child: ListView.builder(
                          clipBehavior: Clip.none,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.categoryList.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height / 5,
                                      width: size.width / 3.7,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: AppColors.br),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  controller
                                                      .categoryList[index],
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Center(
                                                          child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(controller
                                                        .CategoryName[index]),
                                                  ))),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                            ],
                                          ),
                                          const Text('9 Courses'),
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  const Divider(
                    thickness: 6,
                    color: AppColors.Divider,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        aspectRatio: 16 / 6,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        height: size.height / 5,
                        onPageChanged: (index, f) {},
                        animateToClosest: true,
                      ),
                      itemCount: snapshot.data['sliders'].length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                          InkWell(
                            onTap: () {


                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: size.height / 6,
                                width: size.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(AppUrl.pic_url1+snapshot.data['sliders'][itemIndex]['image']),
                                      fit: BoxFit.fill),

                                ),
                              ),
                            ),
                          ),
                    ),
                  ),

                  const Divider(
                    thickness: 6,
                    color: AppColors.Divider,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  snapshot.data['liveLessaon'] != null
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:  [
                                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/live.png',height: 50,width:50,),const SizedBox(width: 10,),

                                      const Text(
                                        'Live Courses',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'See more >',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: SizedBox(
                                    height: size.height / 2.2,
                                    width: size.width,
                                    child: ListView.builder(
                                        clipBehavior: Clip.none,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data['liveLessaon'].length,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(() => CourseDetails(
                                                      id: snapshot.data[
                                                      'liveLessaon']
                                                      [index]
                                                      ['id'].toString(),
                                                      name: snapshot.data[
                                                                  'liveLessaon']
                                                              [index]
                                                          ['course_name'],
                                                    ));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),color: Colors.white,
                                                  border: Border.all(color: AppColors.border,width: 3)
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: size.height/5,
                                                          width: size.width/1.2,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: NetworkImage(  AppUrl.pic_url1 +
                                                                  snapshot.data[
                                                                  'liveLessaon']
                                                                  [
                                                                  index]
                                                                  [
                                                                  'course_image'],),fit: BoxFit.cover
                                                            ),
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                                            ),
                                                        ),const SizedBox(height: 5,),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height:30,

                                                              decoration: BoxDecoration(
                                                                color: AppColors.greybg,borderRadius: BorderRadius.circular(5)
                                                              ),child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(child: Text(snapshot.data[
                                                            'liveLessaon']
                                                            [
                                                            index]['course_batch_name'].toString().toUpperCase(),style: const TextStyle(color: Colors.black87,fontSize: 14),),),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 15,),
                                                            Row(
                                                              children: [
                                                                Image.asset('assets/images/g.png',height: 30,width: 30,),                                                        const SizedBox(width: 15,),

                                                                Text(snapshot.data[
                                                        'liveLessaon']
                                                        [
                                                        index]['total_seat'].toString()+' Total Seats',style: const TextStyle(color: Colors.black87,fontSize: 12),),
                                                              ],
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                          const SizedBox(height: 15,),
                                                      SizedBox(
                                                          width: size.width/1.2,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(snapshot.data[
                                                            'liveLessaon']
                                                            [
                                                            index]['course_name'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: const TextStyle(
                                                        color: AppColors.blackpanther,fontWeight: FontWeight.w700,fontSize: 20
                                                      ),),
                                                          ))
                                                      /*  Container(
                                                          height: size.height / 8,
                                                          width: size.width / 2.2,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    AppUrl.pic_url1 +
                                                                        snapshot.data[
                                                                                    'liveLessaon']
                                                                                [
                                                                                index]
                                                                            [
                                                                            'course_image'],
                                                                  ),
                                                                  fit: BoxFit.cover),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5)),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          width: size.width / 2.1,
                                                          child: Text(
                                                            snapshot.data[
                                                                        'liveLessaon']
                                                                    [index]
                                                                ['course_name'],
                                                            softWrap: true,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.w800),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          width: size.width / 2.1,
                                                          child: Text(
                                                            "৳ " +
                                                                snapshot.data[
                                                                            'liveLessaon']
                                                                        [index]
                                                                    ['course_price'],
                                                            softWrap: true,
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .mainColor,
                                                                fontWeight:
                                                                    FontWeight.w800),
                                                          ),
                                                        ),*/
                                                      ],
                                                    ),const SizedBox(height: 15,),
                                                    Container(
                                                      width: size.width/1.2,
                                                      height: 70,
                                                      decoration: const BoxDecoration(
                                                        color: AppColors.gbg
                                                      ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                          children: [
                                                            const SizedBox(height: 10,),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text("৳ "+snapshot.data[
                                                                'liveLessaon']
                                                                [
                                                                index]['course_price'].toString(),style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,
                                                                fontSize: 16),),
                                                                Container(
                                                                  height:40,

                                                                  decoration: BoxDecoration(
                                                                      color: AppColors.blackpanther,borderRadius: BorderRadius.circular(5)
                                                                  ),child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Center(child: Text('Detils'.toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),),),
                                                                ),
                                                                ),
                                                              ],
                                                            )

                                                          ],
                                                      ),
                                                        ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                              ],
                            )
                          ],
                        )
                      : const SizedBox()
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

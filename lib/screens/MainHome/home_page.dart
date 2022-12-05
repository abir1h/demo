import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
import 'package:learning_school_bd/screens/MainHome/resturent_details.dart';
import 'package:learning_school_bd/screens/MainHome/test.dart';
import 'package:learning_school_bd/screens/auth/phone_login.dart';
import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:learning_school_bd/utils/set_location.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/store.dart';
import '../Billing/billing.dart';
import '../auth/changePassword.dart';
import '../auth/reg.dart';
import '../briwse_byfood/openFood.dart';
import '../briwse_byfood/view_all_browse_by_food.dart';
import '../costfor/singleCostfor.dart';
import '../costfor/vieww_all_Costfor.dart';
import '../events/singleEvent.dart';
import '../events/view_allEventg.dart';
import '../experience/experience.dart';
import '../experience/view_all_Experience.dart';
import '../newlyOpen/featureViewAll.dart';
import '../newlyOpen/newly_viewall.dart';
import '../offers/offers.dart';
import '../offers/singleOffer.dart';
import '../saved/search.dart';
import '../splash/onboarding_page.dart';
import '../zone/viewall_zone.dart';
import 'goeasyOpen.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  Future? dashboard;
  var l,s;
  getl()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');
    setState(() {
      l=locaitonid;
      s=subid;
    });
  }
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(AppUrl.dashboard + locaitonid! + '/' + subid!),
        headers: requestHeaders);
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
    dashboard = getpost();
    getname();
    getConnectivity();
    getlocaiton();
    getl();

/*
    getConnectivity();
*/
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  Future logoutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return await http.post(
      Uri.parse(AppUrl.logout),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'authorization': "Bearer $token",
      },
    );
  }

  List sliderList = [
    "assets/images/f2.png",
    "assets/images/f3.png",
    "assets/images/f4.png",
    "assets/images/f4.png",
    "assets/images/f5.png",
    "assets/images/f5.png",
  ];
  List shop_name = [
    'Pizza Hut',
    "Domino's",
    'Berget King',
    'Trump Cafe' "Domino's",
    'Berget King',
    'Trump Cafe'
  ];
  List browse_food = [
    "assets/images/f2.png",
    "assets/images/f3.png",
    "assets/images/f4.png",
    "assets/images/f4.png",
    "assets/images/f5.png",
    "assets/images/f4.png",
    "assets/images/f4.png",
    "assets/images/f5.png",
    "assets/images/f4.png",
    "assets/images/f4.png",
    "assets/images/f5.png",
  ];
  List go_easy = [
    "assets/images/g1.png",
    "assets/images/g2.png",
    "assets/images/g3.png",
    "assets/images/g4.png",
    "assets/images/g5.png",
    "assets/images/g1.png",
    "assets/images/g2.png",
    "assets/images/g3.png",
    "assets/images/g4.png",
    "assets/images/g5.png",
  ];
  List foodds = [
    'Pizza',
    'Ice-Cream',
    'Cake',
    'Waffle',
    'Sandwich',
    'Ramen',
    'Waffle',
    'Sandwich',
    'Ramen',
    'Sandwich',
    'Ramen',
  ];
  List events = [
    'Birthday',
    'Business\nMeeting',
    'Weeding\n Day',
    'Birthday',
    'Business\nMeeting',
    'Weeding\n Day',
  ];
  List events_image = [
    "assets/images/f2.png",
    "assets/images/f3.png",
    "assets/images/f4.png",
    "assets/images/f4.png",
    "assets/images/f5.png",
  ];
  Future bookmark(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.bookmark + id),
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
  getname()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name_ = prefs.getString('name');
    String? phone_ = prefs.getString('phone');
    setState(() {
      name=name_;
      phone=phone_;
    });
  }
  var name,phone;

  getConnectivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loc = prefs.getString('locaiton');
    loc == null ? Get.to(() => set_locaiton()) : null;
  }

  var loc, sublocaiton;
  getlocaiton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locaiton = prefs.getString('locaiton');
    String? sub = prefs.getString('sub_locaiton');
    setState(() {
      loc = locaiton;
      sublocaiton = sub;
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  var popresult = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          key: _key,

          backgroundColor: Colors.white,
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                Container(
                  width: size.width,
                  decoration: BoxDecoration(

                      color: Colors.white,


                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height/30,),

                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          Text("   "+name.toString(),style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          ),),
                        ],
                      ),
                    ),SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(phone.toString(),style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ),),
                      )
                    ],
                  ),
                ),


                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.key),
                  title: const Text('Change Password'),
                  onTap: () {
                    Get.to(()=>changePassword());
                  },
                ), ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async{
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    logoutApi();
                    await prefs.remove('token');
                    Get.to(()=>login_screen());
                  },
                ),
/*
                ListTile(
                  leading: Image.asset("assets/images/trm.png"),
                  title: const Text('Terms & Conditions'),
                  onTap: () {
                    Get.back();
                  },
                ),
*/

                /* ListTile(
            leading: Container(
                child: Image.asset("assets/images/refun.png")),
            title: const Text('Refund Policy'),
            onTap: () {
              Get.back();
            },
          ),*/
              ],
            ),
          ),

          appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              color: AppColors.orange),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        /* setState(() {
                          dashboard = getpost();
                        });*/
                        // Get.to(() => const reg());
                        _key.currentState!.openDrawer();
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
                    GestureDetector(
                      onTap: () => Get.to(() => set_locaiton()),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    /*Get.to(()=>set_locaiton());*/
                                  },
                                  child: Text(
                                    'Location',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            loc != null
                                ? Text(
                                    loc + "," + sublocaiton,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    loc.toString() +
                                        "," +
                                        sublocaiton.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        logoutApi();
                        await prefs.remove('token');
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Get.to(()=>search());
                  },
                  child: Container(
                    height: size.height / 18,
                    width: size.width / 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '  Search Restaurant of Food Items',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.bg,
                            child: SvgPicture.asset('assets/images/Filter.svg'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: dashboard,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(height: size.height/3,),
                Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
              ],
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: size.height / 35,
                ),
                Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: snapshot.data['slider'].length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(AppUrl.pic_url1 +
                                      snapshot.data['slider'][itemIndex]
                                          ['image']),
                                  fit: BoxFit.cover,
                                )),
                          )
                        ],
                      ),
                      options: CarouselOptions(
                        aspectRatio: 16 / 6,
                        viewportFraction: 0.8,
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
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sliderList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : AppColors.mainColor)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text(
                        "Go Easy",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "View All",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.orange),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: size.height / 6,
                    width: size.width,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data['location'].length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 60,
                              mainAxisExtent: 150,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Get.to(() => goEasyOpen(
                                id:  snapshot.data['location'][index]['id']
                                    .toString(),name:  snapshot.data['location'][index]['name'],));
                          },
                          child: Container(
                            height: 35,
                            width: 200,
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
                                color: Colors.grey.withOpacity(.2)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(AppUrl.pic_url1 +
                                                snapshot.data['location'][index]
                                                    ['image']??''))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data['location'][index]['name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Browse by Offers",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const offers());
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 6,
                  width: size.width,
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => singleOffer(
                                  id: snapshot.data['offer'][index]['id']
                                      .toString(),
                                  discount_type: snapshot.data['offer'][index]
                                      ['discount_type'],
                                  upto: snapshot.data['offer'][index]
                                              ['discount_type'] ==
                                          'condition'
                                      ? snapshot.data['offer'][index]['id']
                                          .toString()
                                      : snapshot.data['offer'][index]
                                              ['offer_title']
                                          .toString(),
                                  location: '0',
                                  end: "0",
                                  start: "0",
                                ));
                          },
                          child: Container(
                            height: size.height / 8.5,
                            width: size.width / 3.7,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),

                                    spreadRadius: 1,

                                    blurRadius: 4,

                                    offset: const Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                              gradient: snapshot.data['offer'][index]
                              ['discount_type'] =="flat"?LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.bg_background3,
                                  AppColors.bg_background2,

                                  Colors.white,
                                ],
                              ):LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.end_color1,
                                  AppColors.end_color2,
                                ],
                              ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  snapshot.data['offer'][index]
                                  ['discount_type'] =="flat"? Text(
                                    'Upto',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ):   snapshot.data['offer'][index]
                                  ['discount_type'] =="item" ?Container():snapshot.data['offer'][index]
                                  ['discount_type'] =="happy-hour"?Text(
                                    'Till',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ):Text(
                                    'Discount\nAbove',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  snapshot.data['offer'][index]
                                  ['discount_type'] =="happy-hour"  ? Column(
                                    children: [
                                      SizedBox(height: size.height/40,),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width:size.width/5,
                                            child: Text(
                                              snapshot.data['offer'][index]
                                              ['offer_title'],overflow: TextOverflow.ellipsis,
                                              maxLines: 1,softWrap: true,
                                              style:  TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                  color: snapshot.data['offer'][index]
                                                  ['discount_type'] =="flat"?Colors.white:AppColors.appbar),
                                            ),
                                          ),

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SizedBox(

                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Happy Hour",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ):snapshot.data['offer'][index]
                            ['discount_type'] =="item"?Column(
                            children: [
                            Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    snapshot.data['offer'][index]
                                    ['offer_title'][0]+   snapshot.data['offer'][index]
                                    ['offer_title'][1]+   snapshot.data['offer'][index]
                                    ['offer_title'][2]+   snapshot.data['offer'][index]
                                    ['offer_title'][3]+   snapshot.data['offer'][index]
                                    ['offer_title'][4],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),


                              ],
                            ),
                              Text(
                                snapshot.data['offer'][index]
                                ['offer_title'][5]+   snapshot.data['offer'][index]
                                ['offer_title'][6]+   snapshot.data['offer'][index]
                                ['offer_title'][7]+   snapshot.data['offer'][index]
                                ['offer_title'][8]+   snapshot.data['offer'][index]
                                ['offer_title'][9]+   snapshot.data['offer'][index]
                                ['offer_title'][10],overflow: TextOverflow.ellipsis,
                                maxLines: 1,softWrap: true,
                                style:  TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: snapshot.data['offer'][index]
                                    ['discount_type'] =="flat"?Colors.white:AppColors.appbar),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ],
                          ):    Row(mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      snapshot.data['offer'][index]
                                      ['discount_type'] =="flat"? Container(

                                        child: Text(
                                          snapshot.data['offer'][index]
                                              ['offer_title'],overflow: TextOverflow.ellipsis,
                                          maxLines: 1,softWrap: true,
                                          style:  TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: snapshot.data['offer'][index]
                                              ['discount_type'] =="flat"?Colors.white:AppColors.appbar),
                                        ),
                                      ): Container(
                                        width:size.width/5,
                                        child: Text(
                                          snapshot.data['offer'][index]
                                          ['offer_title'],overflow: TextOverflow.ellipsis,
                                          maxLines: 1,softWrap: true,
                                          style:  TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: snapshot.data['offer'][index]
                                              ['discount_type'] =="flat"?Colors.white:AppColors.appbar),
                                        ),
                                      ), snapshot.data['offer'][index]
                                      ['discount_type'] =="flat"?Text(
                                        " %",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ):Container(),

                                    ],
                                  ),


                                  snapshot.data['offer'][index]
                                  ['discount_type'] =="flat"?  Column(
                                    children: [
                                      SizedBox(
                                        width: size.width / 3.8,

                                        child: Text(
                                        snapshot.data['offer'][index]
                                          ['discount_type']+" Discount",
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                             fontSize: 12,
                                             fontWeight: FontWeight.bold,
                                             color: Colors.white),
                                            ),
                                      ),
                                    ],
                                  ): snapshot.data['offer'][index]
                                  ['discount_type'] =="happy-hour" ||snapshot.data['offer'][index]
                                  ['discount_type'] =="item" ?Container():SizedBox(
                                    width: size.width / 3.8,

                                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Tk bill",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data['offer'].length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Browse by Food",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => view_all_browsebyfood());
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: size.height / 4,
                    width: size.width,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data['category'].length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 90,
                              mainAxisExtent: 100,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => openFoood(
                                id: snapshot.data['category'][index]['id']
                                    .toString()));
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(  AppUrl.pic_url1 +
                                    snapshot.data['category'][index]['image'],),

                              ),
                              Text(snapshot.data['category'][index]['name'])
                            ],
                          ),
                        );
                      },
                    )),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Browse for Events",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () => Get.to(() => event_viewAll(
/*
                          id: snapshot.data[0]['restaurant_list'][index]['restaurant_info']['id'].toString(),
*/
                            )),
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
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
                          onTap: () {
                           /* Get.to(() => singleEvent(
                                  id: snapshot.data['event'][index]['id']
                                      .toString(),
                                ));*/
                            Get.to(() => newly_open_viewall());

                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: size.height / 5,
                                width: size.width / 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(AppUrl.pic_url1 +
                                          snapshot.data['event'][index]
                                              ['image']),
                                      fit: BoxFit.cover,
                                      opacity: .5,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.8),
                                          BlendMode.dstATop),
                                    )),
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 4,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: size.width / 4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data['event'][index]
                                                    ['event_title'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data['event'].length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Experience",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => experience_viewAll());
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height / 2,
                  width: size.width,
                  decoration: const BoxDecoration(color: AppColors.cream),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: size.height / 6,
                        width: size.width,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data['experience_zone'].length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 280,
                                  mainAxisExtent: 280,
                                  childAspectRatio: 4 / 4,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Get.to(() => singleexperience(
                                      id: snapshot.data['experience_zone']
                                              [index]['id']
                                          .toString(),
                                    ));
                              },
                              child: Container(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  AppUrl.pic_url1 +
                                                      snapshot.data[
                                                              'experience_zone']
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
                                            snapshot.data['experience_zone']
                                                [index]['title'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          /*const Text(
                                            '0 Places',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          )*/
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Average Cost for 2 Person",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => view_all_costfor());
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 6,
                  width: size.width,
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => costFor_single(
                                  id: snapshot.data['cost_for'][index]['id']
                                      .toString(),
                                ));
                          },
                          child: Container(
                            height: size.height / 7.9,
                            width: size.width / 3.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    AppUrl.pic_url1 +
                                        snapshot.data['cost_for'][index]
                                            ['image'],
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: .5,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.8),
                                      BlendMode.dstATop),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Under',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data['cost_for'][index]['title'],
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 18.0),
                                      child: Text(
                                        'TK',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data['cost_for'].length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                /* Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Restaurant Near You",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "View All",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.orange),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 3,
                  width: size.width,
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => resturent_details(
                                  id: '2',
                                ));
                          },
                          child: Container(
                            height: size.height / 3,
                            width: size.width / 1.2,
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
                                              image: AssetImage(sliderList[0]),
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
                                            child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: const Icon(
                                                  Icons.bookmark_border,
                                                  color: Colors.black,
                                                )),
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      shop_name[0],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Burger - Plater - Rice - Chickens',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Mirpur 12, Pallabi,Dhaka',
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
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // Get.to(()=>test());
                        },
                        child: Text(
                          "Newly Opened",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => newly_open_viewall());
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                snapshot.data['newly_open'].length > 0
                    ? SizedBox(
                        height: size.height / 2.5,
                        width: size.width,
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => resturent_details(
                                      id: snapshot.data['newly_open'][index]
                                              ['id']
                                          .toString()));
                                },
                                child: Container(
                                  height: size.height / 2.5,
                                  width: size.width / 1.2,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),

                                          spreadRadius: 2,

                                          blurRadius: 4,

                                          offset: const Offset(0,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    image: NetworkImage(AppUrl
                                                            .pic_url1 +
                                                        snapshot.data['newly_open']
                                                                    [index]
                                                                ['extra_info']
                                                            ['profile_image']),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Positioned(
                                                top: 10,
                                                left: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(snapshot
                                                            .data['newly_open']
                                                                [index]['raing']
                                                            .toString()),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        Text(
                                                          '( ' +
                                                              snapshot.data[
                                                                      'newly_open']
                                                                      [index][
                                                                      'rating_count']
                                                                  .toString() +
                                                              '+ )',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        snapshot.data['newly_open']
                                                                        [index]
                                                                    [
                                                                    'bookmark_show'] ==
                                                                1
                                                            ? snapshot.data['newly_open']
                                                                        [index][
                                                                    'bookmark_show'] =
                                                                0
                                                            : snapshot.data[
                                                                        'newly_open']
                                                                    [index][
                                                                'bookmark_show'] = 1;
                                                        bookmark(snapshot
                                                            .data['newly_open']
                                                                [index]['id']
                                                            .toString());
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: snapshot.data['newly_open']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'bookmark_show'] ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors
                                                                    .orange),
                                                        child: Icon(
                                                          Icons.bookmark_border,
                                                          color: snapshot.data[
                                                                              'newly_open']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'bookmark_show'] ==
                                                                  0
                                                              ? Colors.black
                                                              : Colors.white,
                                                        )),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data['newly_open'][index]
                                                ['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data['newly_open'][index]
                                                ['extra_info']['cuisine_type'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data['newly_open'][index]
                                                    ['extra_info']['address'] ??
                                                '',
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
                          itemCount: snapshot.data['newly_open'].length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      )
                    : Container(
                        child: Center(
                          child: Text(
                            "No resturant in this location",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Featured Restaurants",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => featureViewAll());
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                snapshot.data['feature'].length > 0
                    ? SizedBox(
                        height: size.height / 2.5,
                        width: size.width,
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => resturent_details(
                                      id: snapshot.data['feature'][index]['id']
                                          .toString()));
                                },
                                child: Container(
                                  height: size.height / 2.5,
                                  width: size.width / 1.2,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),

                                          spreadRadius: 2,

                                          blurRadius: 4,

                                          offset: const Offset(0,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    image: NetworkImage(AppUrl
                                                            .pic_url1 +
                                                        snapshot.data['feature']
                                                                    [index]
                                                                ['extra_info']
                                                            ['profile_image']),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Positioned(
                                                top: 10,
                                                left: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(snapshot
                                                            .data['feature']
                                                                [index]['raing']
                                                            .toString()),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        Text(
                                                          '( ' +
                                                              snapshot.data[
                                                                      'feature']
                                                                      [index][
                                                                      'rating_count']
                                                                  .toString() +
                                                              '+ )',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        snapshot.data['feature']
                                                                        [index]
                                                                    [
                                                                    'bookmark_show'] ==
                                                                1
                                                            ? snapshot.data['feature']
                                                                        [index][
                                                                    'bookmark_show'] =
                                                                0
                                                            : snapshot.data[
                                                                        'feature']
                                                                    [index][
                                                                'bookmark_show'] = 1;
                                                        bookmark(snapshot
                                                            .data['feature']
                                                                [index]['id']
                                                            .toString());
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: snapshot.data['feature']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'bookmark_show'] ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors
                                                                    .orange),
                                                        child: Icon(
                                                          Icons.bookmark_border,
                                                          color: snapshot.data[
                                                                              'feature']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'bookmark_show'] ==
                                                                  0
                                                              ? Colors.black
                                                              : Colors.white,
                                                        )),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data['feature'][index]
                                                ['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data['feature'][index]
                                                ['extra_info']['cuisine_type'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data['newly_open'][index]
                                                    ['extra_info']['address'] ??
                                                "",
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
                          itemCount: snapshot.data['feature'].length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      )
                    : Container(
                        child: Center(
                          child: Text(
                            "No resturant in this location",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                SizedBox(
                  height: size.height / 10,
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
      )),
    ));
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

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

        pickedtime = _timeC.text;
      });
    }
  }

  var day, pickedtime;
  bool submit = false;
  Future? getlocation, sublocation;
  Future location() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.location), headers: requestHeaders);
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

  Future subLocation(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.sub_location + id),
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

      print('Get post collected sub' + response.body);
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

  var loc, locid, subloc, sublocid;
  Future? myFuture, group_;
  var val;
  String? _mySelection, group_selection, selection;
  List shots = [];
  var _myJson;
  var section_name;
  var Section_id;
  var groupa_id;
  var group_name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation = location();
  }

/*
  Future rearrange(String day, String time,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.bookingRearange+widget.id),
    );
    request.fields.addAll({
      'date': day,
      'time': time,

    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            submit = false;
          });
          var userData1 = jsonDecode(response.body)['data'];
          Fluttertoast.showToast(
              msg: "Booking Request Submitted Succesfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Get.to(()=>Main_home());
*/
/*
          Get.to(() => bookingStatus(

            bookingId:userData1['restaurant_id'].toString() ,
            bookingdate: userData1['booking_date'],bookingTime: userData1['booking_time'],person: userData1['person'],
            occasion: userData1['party_type'],status:userData1['status'] ,name:userData1['restaurant_info']['name'],
            reservationid:userData1['code'] ,specialreq:userData1['special_request'] ?? '',));
*/ /*

        } else {
          setState(() {
            submit = false;
          });
          var data = jsonDecode(response.body);

          Fluttertoast.showToast(
              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
  }
*/
  setlocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locaiton", location);
  }

  setSublocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sub_locaiton", location);
  }

  var select_locaiton;
  setloc lc = setloc();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: widget.height * 0.7,
        width: widget.width * 0.98,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                LottieBuilder.asset("assets/images/location.json"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: widget.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all()),
                    child: Center(
                      child: FutureBuilder(
                          future: getlocation!,
                          builder: (context, snapshot) {
                            print(snapshot.data.toString());
                            shots = (snapshot.data ?? []) as List;
                            if (snapshot.hasData) {
                              return shots != null
                                  ? Container(
                                      child: DropdownButton<String>(
                                        hint: _mySelection == null
                                            ? Text("Select Location",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey))
                                            : Text(loc!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey)),
                                        items: shots
                                            .map<DropdownMenuItem<String>>(
                                                (value) =>
                                                    DropdownMenuItem<String>(
                                                      value: value["id"]
                                                              .toString() +
                                                          "_" +
                                                          value['name'],
                                                      child: Text(
                                                        value['name'],
                                                      ),
                                                    ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _mySelection = value;
                                            val = _mySelection!.split('_');
                                            print(val[0] + " NEw value");
                                            print(val[1] + " class value");
                                            loc = val[1];
                                            locid = val[0];
                                            setlocation(loc);
                                          });
                                          print(_mySelection);
                                          sublocation =
                                              subLocation(locid.toString());

                                          /* get_s = get_sectioon(
                                        class_id
                                            .toString());*/
                                        },
                                        underline: DropdownButtonHideUnderline(
                                            child: Container()),
                                      ),
                                    )
                                  : SpinKitThreeInOut(
                                      color: Colors.white,
                                      size: 10,
                                    );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ),
                ),
                _mySelection != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: widget.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              border: Border.all()),
                          child: Center(
                            child: FutureBuilder(
                                future: sublocation!,
                                builder: (context, snapshot) {
                                  print(snapshot.data.toString());
                                  shots = (snapshot.data ?? []) as List;
                                  if (snapshot.hasData) {
                                    return shots != null
                                        ? Container(
                                            child: DropdownButton<String>(
                                              hint: selection == null
                                                  ? Text("Select Sub Location",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey))
                                                  : Text(subloc!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey)),
                                              items: shots
                                                  .map<
                                                      DropdownMenuItem<
                                                          String>>((value) =>
                                                      DropdownMenuItem<String>(
                                                        value: value["id"]
                                                                .toString() +
                                                            "_" +
                                                            value['name'],
                                                        child: Text(
                                                          value['name'],
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selection = value;
                                                  val = selection!.split('_');
                                                  print(val[0] + " NEw value");
                                                  print(
                                                      val[1] + " class value");
                                                  subloc = val[1];

                                                  sublocid = val[0];
                                                  setSublocation(subloc);
                                                });
                                                /* get_s = get_sectioon(
                                        class_id
                                            .toString());*/
                                              },
                                              underline:
                                                  DropdownButtonHideUnderline(
                                                      child: Container()),
                                            ),
                                          )
                                        : SpinKitThreeInOut(
                                            color: Colors.white,
                                            size: 10,
                                          );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () {
                    Get.to(() => Main_home());
                  },
                  child: Container(
                    height: widget.height / 25,
                    width: widget.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.orange),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

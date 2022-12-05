import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:learning_school_bd/screens/MainHome/resturent_details.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import '../experience/experience.dart';

class goEasyOpen extends StatefulWidget {
  final String id, name;

  const goEasyOpen({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<goEasyOpen> createState() => _goEasyOpenState();
}

class _goEasyOpenState extends State<goEasyOpen> {
  Future? dashboard;
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

  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? locaitonid = prefs.getString('locaitonid');
    String? subid = prefs.getString('sub_locaitonid');
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.goeasy + widget.id),
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
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
        title: Text(
          widget.name,
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
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: dashboard,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: size.height / 3,
                ),
                Center(
                    child: Lottie.asset('assets/images/loading.json',
                        height: 200)),
                Center(
                  child: Text(
                    " Please wait while Loading..",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Text(
                    "Foods",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: size.height / 2.5,
                    width: size.width,
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => resturent_details(
                                  id: snapshot.data['foodRes'][index]['id']
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
                                                image: NetworkImage(
                                                    AppUrl.pic_url1 +
                                                        snapshot.data['foodRes']
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
                                                      BorderRadius.circular(18),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(snapshot
                                                        .data['foodRes'][index]
                                                            ['raing']
                                                        .toString()),
                                                    Icon(
                                                      Icons.star,
                                                      color:
                                                          Colors.yellowAccent,
                                                    ),
                                                    Text(
                                                      '( ' +
                                                          snapshot
                                                              .data['foodRes']
                                                                  [index][
                                                                  'rating_count']
                                                              .toString() +
                                                          '+ )',
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    snapshot.data['foodRes']
                                                                    [index][
                                                                'bookmark_show'] ==
                                                            1
                                                        ? snapshot.data[
                                                                    'foodRes']
                                                                [index][
                                                            'bookmark_show'] = 0
                                                        : snapshot.data[
                                                                    'foodRes']
                                                                [index]
                                                            ['bookmark_show'] = 1;
                                                    bookmark(snapshot
                                                        .data['foodRes'][index]
                                                            ['id']
                                                        .toString());
                                                  });
                                                },
                                                child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: snapshot.data[
                                                                            'foodRes']
                                                                        [index][
                                                                    'bookmark_show'] ==
                                                                0
                                                            ? Colors.white
                                                            : Colors.orange),
                                                    child: Icon(
                                                      Icons.bookmark_border,
                                                      color: snapshot.data[
                                                                          'foodRes']
                                                                      [index][
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
                                        snapshot.data['foodRes'][index]['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data['foodRes'][index]
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
                                        snapshot.data['foodRes'][index]
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
                      itemCount: snapshot.data['foodRes'].length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Text(
                    "Average Cost for 2 Person",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: size.height / 2.5,
                    width: size.width,
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => resturent_details(
                                  id: snapshot.data['costForRes'][index]['id']
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
                                                image: NetworkImage(AppUrl
                                                        .pic_url1 +
                                                    snapshot.data['costForRes']
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
                                                      BorderRadius.circular(18),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(snapshot
                                                        .data['costForRes']
                                                            [index]['raing']
                                                        .toString()),
                                                    Icon(
                                                      Icons.star,
                                                      color:
                                                          Colors.yellowAccent,
                                                    ),
                                                    Text(
                                                      '( ' +
                                                          snapshot.data[
                                                                  'costForRes']
                                                                  [index][
                                                                  'rating_count']
                                                              .toString() +
                                                          '+ )',
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    snapshot.data['costForRes']
                                                                    [index]
                                                                [
                                                                'bookmark_show'] ==
                                                            1
                                                        ? snapshot.data[
                                                                    'costForRes']
                                                                [index][
                                                            'bookmark_show'] = 0
                                                        : snapshot.data[
                                                                    'costForRes']
                                                                [index]
                                                            ['bookmark_show'] = 1;
                                                    bookmark(snapshot
                                                        .data['costForRes']
                                                            [index]['id']
                                                        .toString());
                                                  });
                                                },
                                                child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: snapshot.data[
                                                                            'costForRes']
                                                                        [index][
                                                                    'bookmark_show'] ==
                                                                0
                                                            ? Colors.white
                                                            : Colors.orange),
                                                    child: Icon(
                                                      Icons.bookmark_border,
                                                      color: snapshot.data[
                                                                          'costForRes']
                                                                      [index][
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
                                        snapshot.data['costForRes'][index]
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
                                        snapshot.data['costForRes'][index]
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
                                        snapshot.data['costForRes'][index]
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
                      itemCount: snapshot.data['costForRes'].length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Text(
                    "Experience Zones",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: size.height / 2.5,
                    width: size.width,
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => resturent_details(
                                  id: snapshot.data['expZoneRes'][index]['id']
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
                                                image: NetworkImage(AppUrl
                                                        .pic_url1 +
                                                    snapshot.data['expZoneRes']
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
                                                      BorderRadius.circular(18),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(snapshot
                                                        .data['expZoneRes']
                                                            [index]['raing']
                                                        .toString()),
                                                    Icon(
                                                      Icons.star,
                                                      color:
                                                          Colors.yellowAccent,
                                                    ),
                                                    Text(
                                                      '( ' +
                                                          snapshot.data[
                                                                  'expZoneRes']
                                                                  [index][
                                                                  'rating_count']
                                                              .toString() +
                                                          '+ )',
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    snapshot.data['expZoneRes']
                                                                    [index]
                                                                [
                                                                'bookmark_show'] ==
                                                            1
                                                        ? snapshot.data[
                                                                    'expZoneRes']
                                                                [index][
                                                            'bookmark_show'] = 0
                                                        : snapshot.data[
                                                                    'expZoneRes']
                                                                [index]
                                                            ['bookmark_show'] = 1;
                                                    bookmark(snapshot
                                                        .data['expZoneRes']
                                                            [index]['id']
                                                        .toString());
                                                  });
                                                },
                                                child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: snapshot.data[
                                                                            'expZoneRes']
                                                                        [index][
                                                                    'bookmark_show'] ==
                                                                0
                                                            ? Colors.white
                                                            : Colors.orange),
                                                    child: Icon(
                                                      Icons.bookmark_border,
                                                      color: snapshot.data[
                                                                          'expZoneRes']
                                                                      [index][
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
                                        snapshot.data['expZoneRes'][index]
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
                                        snapshot.data['expZoneRes'][index]
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
                                        snapshot.data['expZoneRes'][index]
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
                      itemCount: snapshot.data['expZoneRes'].length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
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

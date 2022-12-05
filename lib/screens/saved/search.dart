import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/colors.dart';
import '../MainHome/resturent_details.dart';

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  Future? myfuture;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.search+'0'), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  TextEditingController _controller = TextEditingController();

  StreamController? _streamController;
  Stream? _stream;

  Timer? _debounce;

  _search() async {
    if (_controller.text.isEmpty) {
      _streamController!.add(null);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {'authorization': "Bearer $token"};

    String controller = _controller.text.trim();
    _streamController!.add("waiting");
    Response response =
    await get(Uri.parse(AppUrl.search + controller), headers: requestHeaders);
    _streamController!.add(json.decode(response.body)['data']);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=getpost();


    _streamController = StreamController();
    _stream = _streamController!.stream;
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
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
          "Search Restaurant",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [

        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/30,),
              Padding(
                padding: const EdgeInsets.only(left:28.0,right: 28),
                child: TextFormField(
                  controller: _controller,
                  onChanged: (String text) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                      _search();
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                      border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "Search by restaurants name",


                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: _stream,
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return  Container(
                            constraints: BoxConstraints(),
                            child: FutureBuilder(
                                future: myfuture,
                                builder: (_, AsyncSnapshot snapshot) {
                                  print(snapshot.data);
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Column(
                                        children: [
                                          SizedBox(height: size.height/3,),
                                          Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                                          Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                                        ],
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        Text('Error: ${snapshot.error}');
                                      } else {
                                        return snapshot.hasData
                                            ?                                    Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child:             Container(
                                            height: height/1.2,
                                            child: ListView.builder(

                                                shrinkWrap: true,
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (_,index){

                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.to(() => resturent_details(
                                                          id: snapshot.data[index]['id'].toString(),
                                                        ));
                                                      },
                                                      child: Container(
                                                        width: size.width ,
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
                                                                          image: NetworkImage(AppUrl.pic_url1+snapshot.data[index]['extra_info']['profile_image']),
                                                                          fit: BoxFit.cover,
                                                                        )),
                                                                  ),
                                                                  /* Positioned(
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
                          )),*/
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                                                  children: [
                                                                    Text(
                                                                      snapshot.data[index]['name'],
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 18,
                                                                          color: Colors.black),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),

                                                              Padding(
                                                                padding: EdgeInsets.only(left: 8.0),
                                                                child: Text(
                                                                  snapshot.data[index]['extra_info']['address']??'',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12,
                                                                      color: Colors.black),
                                                                ),
                                                              ) ,

                                                              Padding(
                                                                padding: EdgeInsets.only(left: 8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      snapshot.data[index]['restaurant_type'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 12,
                                                                          color: Colors.orange),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Padding(
                                                                padding: EdgeInsets.only(left: 8.0),
                                                                child: Text(
                                                                  'Open Now',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w900,
                                                                      fontSize: 16,
                                                                      color: Colors.green),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),

                                        )



                                            : Text('No data');
                                      }
                                  }
                                  return CircularProgressIndicator();
                                }));
                      }

                      if (snapshot.data == "waiting") {
                        return Column(
                          children: [
                            SizedBox(height: size.height/3,),
                            Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                            Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                          ],
                        );                     }

                      return    Container(
                        height: height/1.4,
                        child: ListView.builder(

                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_,index){

                              return   Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => resturent_details(
                                      id: snapshot.data[index]['id'].toString(),
                                    ));
                                  },
                                  child: Container(
                                    width: size.width ,
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
                                                      image: NetworkImage(AppUrl.pic_url1+snapshot.data[index]['extra_info']['profile_image']),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              /* Positioned(
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
                          )),*/
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                              children: [
                                                Text(
                                                  snapshot.data[index]['name'],
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),

                                              ],
                                            ),
                                          ),

                                           Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                             snapshot.data[index]['extra_info']['address']??'',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ) ,

                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data[index]['restaurant_type'],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Colors.orange),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Open Now',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        ),
      ),

    ));
  }
}

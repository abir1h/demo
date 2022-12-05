import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:learning_school_bd/screens/offers/singleOffer.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import 'package:http/http.dart' as http;

class offers extends StatefulWidget {
  const offers({Key? key}) : super(key: key);

  @override
  State<offers> createState() => _offersState();
}

class _offersState extends State<offers> {
  Future? offers;
  Future getOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.view_all_offers), headers: requestHeaders);
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
    offers=getOffers();

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
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
          "All Offers",
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            children: [
              FutureBuilder(
                future: offers,
                builder: (_, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(height: size.height/3,),
                        Center(child: Lottie.asset('assets/images/loading.json',height: 200)),
                        Center(child: Text(" Please wait while Loading..",style: TextStyle(fontSize: 16),),)
                      ],
                    );                  } else if (snapshot.hasData) {
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Offers ( "+snapshot.data.length.toString()+" )",
                            style: const TextStyle(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                   /* showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                          height: size.height, width: size.width),
                                    );*/
                                    Get.to(() => singleOffer(
                                      id: snapshot.data[index]['id']
                                          .toString(),
                                      discount_type: snapshot.data[index]
                                      ['discount_type'],
                                      upto: snapshot.data[index]
                                      ['discount_type'] ==
                                          'condition'
                                          ? snapshot.data[index]['id']
                                          .toString()
                                          : snapshot.data[index]
                                      ['offer_title']
                                          .toString(),
                                      location: '0',
                                      end: "0",
                                      start: "0",
                                    ));
                                  },
                                  child: Container(
                                    height: size.height / 3,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),

                                          spreadRadius: 2,

                                          blurRadius: 4,

                                          offset: const Offset(
                                              0, 5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: size.height / 7,
                                          width: size.width,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                topLeft: Radius.circular(15)),
                                            color: AppColors.offers,
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                       Text(
                                                         snapshot.data[index]
                                                         ['discount_type'],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        children: [
                                                          SizedBox(
                                                            width: size.width / 6,
                                                          ),
                                                           Row(
                                                             children: [
                                                               Text(
                                                                snapshot.data[index]['offer_title'] +" ",
                                                                style: TextStyle(
                                                                    color: AppColors.orange,
                                                                    fontSize: 26,
                                                                    fontWeight:
                                                                    FontWeight.w900),
                                                          ),
                                                               snapshot.data[index]
                                                               ['discount_type'] =="flat"?Text(
                                                                 " % off",
                                                                 style: const TextStyle(
                                                                     fontSize: 24,
                                                                     fontWeight: FontWeight.w700,
                                                                     color: Colors.white),
                                                               ):Text(
                                                                 " ",
                                                                 style: const TextStyle(
                                                                     fontSize: 24,
                                                                     fontWeight: FontWeight.w700,
                                                                     color: Colors.white),
                                                               ),
                                                             ],
                                                           ),
                                                        /*  const Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              "off",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                  FontWeight.w600),
                                                            ),
                                                          ),*/
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Offer Available : ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          "From ",
                                                          style: TextStyle(
                                                              color: Colors.green,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                        Text(
                                                          "01/02/2022",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          "To ",
                                                          style: TextStyle(
                                                              color: Colors.blue,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                        Text(
                                                          "01/02/2022",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Terms & Conditions : lorem ipsum dolor tiamat amor ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
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
              )
            ],
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: widget.height * 0.7,
        width: widget.width * 0.98,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: widget.height / 7,
                    width: widget.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      color: AppColors.offers,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Flat",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: widget.width / 6,
                                    ),
                                    const Text(
                                      "15%",
                                      style: TextStyle(
                                          color: AppColors.orange,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "off",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Offer Available : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "From ",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "01/02/2022",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "To ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "01/02/2022",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Details :",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nunc nec ultricies dictum blandit nisi netus posuere in. Tortor nibh dignissim in ipsum, scelerisque. Ut est pellentesque tortor ut amet. Dictum nibh ornare hac nisl volutpat id sit feugiat.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Terms & Conditions : lorem ipsum dolor tiamat amor ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: AppColors.orange,
                        ),
                        Text(
                          "Previous Offer",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          "View Next Offer",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

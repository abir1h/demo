import 'dart:convert';
import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/Billing/billing.dart';
import 'package:learning_school_bd/screens/MainHome/home_page.dart';
import 'package:learning_school_bd/screens/rating/Rating.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import '../saved/saved.dart';
import 'booking.dart';

class Main_home extends StatefulWidget {
  @override
  _Main_homeState createState() => _Main_homeState();
}

class _Main_homeState extends State<Main_home> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    home_page(),
    Container(),
    saved(),
    booking()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int current_screen = 1;
  @override
  void initState() {
    // TODO: implement initState
    getConnectivity();
    super.initState();
  }

  getConnectivity() async {
    final stream = Stream.periodic(const Duration(seconds: 10), (i) async {
      print(i);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'authorization': "Bearer $token"
      };

      var response =
          await http.get(Uri.parse(AppUrl.billing), headers: requestHeaders);
      if (response.statusCode == 200) {
        var userData1 = jsonDecode(response.body);
        if (userData1['status_code'] == 200) {
          print('Get post collected' + response.body);
          Get.to(()=>billing());

          return userData1;
        } else {
          print("post have no Data${response.body}");
        }
      } else {
        print("post have no Data${response.body}");
      }

    });

    stream.listen(print);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("YES"),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  TextButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CircularProfileAvatar(
          '',
          child: const Center(
            child: Text(
              "E",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
            ),
          ),
          borderColor: Colors.white,
          borderWidth: 10,
          backgroundColor: AppColors.appbar,
          elevation: 0,
          radius: 40,
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 13,
            color: AppColors.bg,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _onItemTapped(0);
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/Home.svg',
                          color: _selectedIndex == 0
                              ? AppColors.appbar
                              : Colors.grey,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? AppColors.appbar
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: InkWell(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/offers.svg',
                            color: _selectedIndex == 1
                                ? AppColors.appbar
                                : Colors.grey,
                          ),
                          Text(
                            "Offers",
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? AppColors.appbar
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _onItemTapped(2);
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/save.svg',
                          color: _selectedIndex == 2
                              ? AppColors.appbar
                              : Colors.grey,
                        ),
                        Text(
                          "Saved ",
                          style: TextStyle(
                            color: _selectedIndex == 2
                                ? AppColors.appbar
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _onItemTapped(3);
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/Stoke.svg',
                          color: _selectedIndex == 3
                              ? AppColors.appbar
                              : Colors.grey,
                        ),
                        Text(
                          "Booking",
                          style: TextStyle(
                            color: _selectedIndex == 3
                                ? AppColors.appbar
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

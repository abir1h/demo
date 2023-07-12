import 'dart:convert';
import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';

import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import 'HomePage/HomeView.dart';
import 'More/More.dart';

class Main_home extends StatefulWidget {final int indexof;
Main_home({required this.indexof});
@override
_Main_homeState createState() => _Main_homeState();
}

class _Main_homeState extends State<Main_home> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    Container(),
    Container(),
    More(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int current_screen = 1;
  @override
  void initState() {
    _selectedIndex=widget.indexof;
    // TODO: implement initState

    super.initState();
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
        /* floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          backgroundColor: AppColors.mainColor,
          elevation: 0,
          radius: 40,
        ),*/
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 13,
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: Column(
                        children: [
                         Icon(Icons.menu_book_sharp,color: _selectedIndex == 0
                             ? AppColors.mainColor
                             : Colors.grey,),
                          Text(
                            "Home",
                            style: TextStyle(
                                color: _selectedIndex == 0
                                    ? AppColors.mainColor
                                    : Colors.grey,                          fontSize: 10

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.rocket_launch_outlined,color: _selectedIndex == 1
                              ? AppColors.mainColor
                              : Colors.grey,),
                          Text(
                            "Skills",
                            style: TextStyle(
                                color: _selectedIndex == 1
                                    ? AppColors.mainColor
                                    : Colors.grey,                          fontSize: 10

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child:  InkWell(
                    onTap: () {
                      _onItemTapped(2);
                    },
                    child: Column(
                      children: [
                        Icon(Icons.sim_card_download_outlined,color: _selectedIndex == 2
                            ? AppColors.mainColor
                            : Colors.grey,),
                        Text(
                          "Downlaod",
                          style: TextStyle(
                              color: _selectedIndex == 2
                                  ? AppColors.mainColor
                                  : Colors.grey,                          fontSize: 10

                          ),
                        )
                      ],
                    ),
                  ),),
                  Expanded(child:  InkWell(
                    onTap: () {
                      _onItemTapped(3);
                    },
                    child: Column(
                      children: [
                        Icon(Icons.dashboard_customize_outlined,color: _selectedIndex == 3
                            ? AppColors.mainColor
                            : Colors.grey,),
                        Text(
                          "More ",
                          style: TextStyle(
                              color: _selectedIndex == 3
                                  ? AppColors.mainColor
                                  : Colors.grey,                          fontSize: 10

                          ),
                        )
                      ],
                    ),
                  ),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

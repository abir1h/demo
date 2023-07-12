import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/auth/LogIn.dart';
import 'package:learning_school_bd/utils/colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:http/http.dart'as http;

import '../MainHome.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var token;

  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
  }


  var update;
  @override
  void initState() {
    // TODO: implement initState
    isLoogedIn();
    // initPlatformState();

    super.initState();
    startTimer();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  startTimer() async {
    var duration = Duration(milliseconds: 2000);
    return new Timer(duration, route);
  }


  route() async{

    token == null
        ? Get.to(()=>LoginView())
        :Get.to(()=>Main_home(indexof: 0,));
  }


  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(

        backgroundColor:AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: MediaQuery.of(context).size.height/3.5,),
              Center(child: Align(alignment:Alignment.center,child: Column(
                children: [
                  Image.asset('assets/images/login.png',height: 150,width: 150,),
                  SizedBox(height:  MediaQuery.of(context).size.height/25,),

                  SizedBox(height:  MediaQuery.of(context).size.height/25,),

                  Padding(
                    padding: const EdgeInsets.only(left:140.0,right:140),
                    child: LinearProgressIndicator(backgroundColor:AppColors.lorange,

                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                ],
              ))),

            ],
          ),
        )
    );
  }
}


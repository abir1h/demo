import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MainHome/Main-Home.dart';
import 'loginScreen.dart';
import 'onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var check_main;
  late AnimationController _controller;
  var update;
  @override
  void initState() {
    // TODO: implement initState
    // initPlatformState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _controller.forward();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  startTimer() async {
    var duration = const Duration(milliseconds: 2000);
    return Timer(duration, route);
  }

  Naviagate() => Get.to(() => Main_home());
  Naviagatelogin() => Get.to(() => const login());
  Naviagatemain() => Get.to(() => OnboardPage());

  var main = 3;
  var version;

  route() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var firstBrowse = prefs.getBool('ON_BOARDING');
    var token = prefs.getString('token');
    firstBrowse == null
        ? Naviagatemain()
        : token == null
            ? Naviagatelogin()
            : Naviagate();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.start_splash,
            AppColors.start_splash,
          ],
        )),
        child: Column(
          children: [
            SizedBox(
              height: height / 2.5,
            ),
            const Text(
              "Gosy",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 40),
            )
          ],
        ),
      ),
    ));
  }
}

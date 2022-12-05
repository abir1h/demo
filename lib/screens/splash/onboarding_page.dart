import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:learning_school_bd/screens/splash/loginScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardPage extends StatelessWidget {

  final List<PageViewModel> pages = [
    PageViewModel(
        title: 'Browse Your Menu\n & Order Directly',
        body: 'The best food delivery food app you have ever used!',
        image: Lottie.asset('assets/images/order.json'),
        decoration: const PageDecoration(
            bodyTextStyle: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ))),
    PageViewModel(
        title: 'Get Your Food Any Restaurants',
        body:
            'Select your location to see the wide range of your restaurants you can order from',
        image: Lottie.asset('assets/images/data.json'),
        decoration: const PageDecoration(
            bodyTextStyle: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ))),
    PageViewModel(
        title: 'The Fastest Food Delivery Service',
        body:
            'Select your location to see the wide range of your restaurants you can order from',
        image: Lottie.asset('assets/images/deliver.json'),
        decoration: const PageDecoration(
            bodyTextStyle: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: pages,
        dotsDecorator: DotsDecorator(
          size: const Size(15, 10),
          color: Colors.grey,
          activeSize: const Size(10, 10),
          activeColor: Colors.orange,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        showDoneButton: true,
        done: const Text(
          'Done',
          style: TextStyle(fontSize: 20),
        ),
        showSkipButton: true,
        skip: const Text(
          'Skip',
          style: TextStyle(fontSize: 20),
        ),
        showNextButton: true,
        next: const Icon(
          Icons.arrow_forward,
          size: 25,
        ),
        onDone: () => onDone(context),
        curve: Curves.bounceOut,
        onSkip: () => onskip(context),
      ),
    );
  }

  void onDone(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', true);
    Get.to(() => const login());
  }

  void onskip(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', true);
    Get.to(() => const login());
  }
}

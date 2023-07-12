import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/MainHome.dart';
import 'package:learning_school_bd/screens/auth/LogIn.dart';
import 'package:learning_school_bd/screens/auth/SplashScreen.dart';
import 'package:learning_school_bd/screens/auth/phone_login.dart';


import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setAppId('99ed0811-25a7-46ba-9298-d6a8bdd85305');
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 7));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.green,
        fontFamily: 'Inter'
      ),
      //home:Main_home(indexof: 0),
      home: SplashScreen(),
      // home:SplashScreen(),
    );
  }
}


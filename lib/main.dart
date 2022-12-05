import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/splash/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.shared.setAppId('99ed0811-25a7-46ba-9298-d6a8bdd85305');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(

        primarySwatch: Colors.orange,
        fontFamily: 'Poppins'
      ),
      home:SplashScreen(),
      // home:SplashScreen(),
    );
  }
}


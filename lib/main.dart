import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/Signup/sign-up.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return GetMaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SignUp(),
      );
    },

    );
  }
}


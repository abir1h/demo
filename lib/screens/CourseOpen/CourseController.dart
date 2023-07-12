import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart'as http;

import '../../utils/Appurl.dart';

class CourseController extends GetxController {
  TextEditingController otpEditingController = TextEditingController();
  var messageOtpCode = ''.obs;
  List imageList=['assets/images/1.png','assets/images/2.png','assets/images/3.jpg'].obs;
  List instructor=['assets/images/p1.jpg','assets/images/p2.jpg',].obs;
  List instructorname=['কে. এম. রাফসান রাব্বি','এ. এইচ. এম. আজিমুল হক',].obs;
  List instructorsubject=['সহকারী কমিশনার ও এক্সিকিউটিভ ম্যাজিস্ট্রেট, ৪০তম বিসিএস; সাবেক সহকারী পরিচালক, প্রধানমন্ত্রীর কার্যালয়','সহকারী কমিশনার ও এক্সিকিউটিভ ম্যাজিস্ট্রেট, ৪০তম বিসিএস',].obs;
  List title=['https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo'].obs;
  List price=['৳৩৫০০','৳৫৫০০','৳১৫০০'].obs;
  List learn=['Live classes based on the syllabus provided by PSC','Recorded classes on all the topics for BCS to build your basic',
  'The tips and tricks to face BCS standard questions',
    'Ways to solve hard BCS questions','How to take complete preparation for BCS Preliminary exam'
  ].obs;
  String caption='Take the complete preparation for 46th BCS preliminary exam with Live classes, lecture sheets, topic-wise exams, and weekly model tests, all based on the syllabus provided by PSC.';
  @override
  void onInit() async {
    super.onInit();


  }

  videoInitials(String id){

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId:id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

  }
}
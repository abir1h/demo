import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/Models/examlistmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import '../../utils/ApiClient.dart';
import '../../utils/Appurl.dart';

class ModuleController extends GetxController {
  RxString CourseName = ''.obs;
  RxString Courseid = ''.obs;
  RxString examid = ''.obs;
  RxString price = ''.obs;
  RxList leaderboardResults=[].obs;


  RxString Courseiamge =
      'https://lsb.bestaid.com.bd/img/extra/10.png'.obs;
  RxList LiveClass = [
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1789/1789302.png',
      'name': "Module 1 - Live Class",
      "Date": "May 9:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1789/1789302.png',
      'name': "Module 2 - Live Class",
      "Date": "May 10:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1789/1789302.png',
      'name': "Module 3 - Live Class",
      "Date": "May 11:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1789/1789302.png',
      'name': "Module 3 - Live Class",
      "Date": "May 11:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1789/1789302.png',
      'name': "Module 3 - Live Class",
      "Date": "May 11:00PM"
    },
  ].obs;

  RxList QuizList = [
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "Module 1 - Quiz",
      "Date": "May 9:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "Module 2 - Quiz",
      "Date": "May 10:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "Module 3 - Quiz",
      "Date": "May 11:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "Module 3 - Quiz",
      "Date": "May 11:00PM"
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "Module 3 - Quiz",
      "Date": "May 11:00PM"
    },
  ].obs;
  RxList SelectedOptionIndex=[].obs;

  RxList Qustions = [
    {
      'exam_id': '1',
      "qustion_no": '1',
      'option_selected':null,

      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "Is Partho a Great Engineer ?",
      'option': [
        {
          'option_id': '1',
          "option_1": "yes",
        },
        {
          'option_id': '2',
          "option_1": "No",
        },
        {
          'option_id': '3',
          "option_1": "Yes & No Both",
        },
        {
          'option_id': '4',
          "option_1": "Not Interested",
        },
      ],
      "answer_no": null
    },
    {
      'exam_id': '1',
      "qustion_no": '2',      'option_selected':null,

      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "What type of language is C++?",
      'option': [
        {
          'option_id': '1',

          "option_1": "A Programing Language",
        },
        {
          'option_id': '2',
          "option_1": "A scripting langugage",
        },
        {
          'option_id': '3',
          "option_1": "A scripting langugage",
        },
        {
          'option_id': '4',
          "option_1": "A & b Both",
        },
      ],
      "answer_no": null
    },
    {
      'exam_id': '1',
      "qustion_no": '3',      'option_selected':null,

      'image': 'https://cdn-icons-png.flaticon.com/512/2601/2601987.png',
      'name': "What is the defination of Vue.js",
      'option': [
        {
          'option_id': '1',
          "option_1": "A Programing Langage",
        },
        {
          'option_id': '2',
          "option_1": "A font-end javaScript Framework",
        },
        {
          'option_id': '3',
          "option_1": "A server-side Language",
        },
        {
          'option_id': '4',
          "option_1": "A database managemetn System",
        },
      ],
      "answer_no": null
    },

  ].obs;
  RxBool isLoading = false.obs;

  RxList<ExamListModel> Examlist = <ExamListModel>[].obs;


  RxString Selectedvalue=''.obs;
  @override
  void onInit() async {
    super.onInit();
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

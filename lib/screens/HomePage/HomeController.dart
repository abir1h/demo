import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/Models/HomeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:http/http.dart'as http;

import '../../utils/Appurl.dart';
class HomePageController extends GetxController {
  TextEditingController otpEditingController = TextEditingController();
  var messageOtpCode = ''.obs;
  List imageList=['assets/images/1.png','assets/images/2.png','assets/images/3.jpg'].obs;
  List recordclass2=[''].obs;
  List bundle=['assets/images/f1.jpg','assets/images/f2.jpg','assets/images/f3.jpg','assets/images/f4.jpg'].obs;
  List categoryList=['assets/images/l1.png','assets/images/l2.png','assets/images/l3.png','assets/images/l4.png'].obs;
  List CategoryName=['Language Learning','IT Courses & Skills','Freelancing Courses','Design & Creative'].obs;
  List title=['বিসিএস প্রিলি লাইভ কোর্স','ব্যাংক জবস কোর্স','সরকারী চাকরি কোর্স'].obs;
  List bundletitle=['Spoken English for Kids','ঘরে বসে Freelancing','Leadership Excellence','Negotiation skills'].obs;
  List price=['৳৩৫০০','৳৫৫০০','৳১৫০০'].obs;
  List link=['https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo'].obs;
  List bundlelinks=['https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo','https://youtu.be/F-7ZnFdhpEo'].obs;
  List bundelprice=['৳৩৫০০','৳৫৫০০','৳১৫০০','৳১৫০০'].obs;
  RxList recordclass =[].obs;
  RxBool isLoading = true.obs;
  RxBool isDetailsLoading = false.obs;
  RxString name=''.obs;
  RxString phone=''.obs;
  @override
  void onInit() async {
    super.onInit();
    GetUserData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

  }
  GetUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    name.value=prefs.getString('name')!;
    phone.value=prefs.getString('phone')!;

  }
  Rx<HomePageModel> home = HomePageModel().obs;
 /* getProfile() async {
    isLoading.value = true;
    final response = await ApiClient.instance.get(url: URL.profile);
    if (response != null) {
      user.value = UserModel.fromJson(response);
    }
    isLoading.value = false;
  }*/

  Future viewHome() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'authorization': "Bearer $token"
      };

      final response = await http.get(Uri.parse(AppUrl.homepage),
          headers: requestHeaders);
      if (response.statusCode==200) {
        print('tapp');


        return home.value = HomePageModel.fromJson(jsonDecode(response.toString()));

      } else {        isLoading.value=false;

      print("post have no Data${response.body}");
        var userData1 = jsonDecode(response.body)['data'];
        return userData1;
      }



    } catch (e) {
      print(e);
      isLoading.value = false;
    }
    isLoading.value = false;
  }

}
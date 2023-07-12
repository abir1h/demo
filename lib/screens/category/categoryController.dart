import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

class CategoryController extends GetxController {
  TextEditingController otpEditingController = TextEditingController();
  var messageOtpCode = ''.obs;
  List imageList=['assets/images/1.png','assets/images/2.png','assets/images/3.jpg'].obs;
  List bundle=['assets/images/f1.jpg','assets/images/f2.jpg','assets/images/f3.jpg','assets/images/f4.jpg','assets/images/f1.jpg','assets/images/f2.jpg','assets/images/f3.jpg','assets/images/f4.jpg'].obs;
  List categoryList=['assets/images/l1.png','assets/images/l2.png','assets/images/l3.png','assets/images/l4.png'].obs;
  List CategoryName=['Language Learning','IT Courses & Skills','Freelancing Courses','Design & Creative'].obs;
  List title=['বিসিএস প্রিলি লাইভ কোর্স','ব্যাংক জবস কোর্স','সরকারী চাকরি কোর্স'].obs;
  List bundletitle=['Spoken English for Kids','ঘরে বসে Freelancing','Leadership Excellence','Negotiation skills','বিসিএস প্রিলি লাইভ কোর্স','ব্যাংক জবস কোর্স','সরকারী চাকরি কোর্স','Negotiation skills'].obs;
  List price=['৳৩৫০০','৳৫৫০০','৳১৫০০'].obs;
  List link=['https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo','https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo'].obs;
  List bundlelinks=['https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo','https://youtu.be/F-7ZnFdhpEo','https://youtu.be/PO58e0Z4dbE','https://youtu.be/VH_zYosavDU','https://youtu.be/F-7ZnFdhpEo','https://youtu.be/F-7ZnFdhpEo'].obs;
  List bundelprice=['৳৩৫০০','৳৫৫০০','৳১৫০০','৳১৫০০','৳৩৫০০','৳৫৫০০','৳১৫০০','৳১৫০০'].obs;

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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import '../MainHome.dart';

class LoginController2 extends GetxController {
  RxBool isLoading = false.obs;
  RxBool _passwordVisible = false.obs;

  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Rx<TextEditingController> phone = TextEditingController().obs;
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> fullname = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;


  RxBool showPassword = true.obs;

  login() {
    print("start!");

    isLoading.value = true;
    loginApiCall(
      mobileController.value.text.toString(),
      passwordController.value.text.toString(),
    );
  }
  register() {
    print("start!");

    isLoading.value = true;
    signUpApiCall(
      phone.value.text.toString(),
      password.value.text.toString(),
      fullname.value.text.toString(),
      email.value.text.toString(),
    );
  }

  void togglePassword() {
    showPassword.value = !showPassword.value;
  }

  saveprefs(
      String token,
      String phone,
      String name,
      String email,
      String id
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('phone', phone);
    prefs.setString('email', email);
    prefs.setString('name', name);
    prefs.setString('id', id);
  }

  // This is not redundant. It is separated for using in other places.
  loginApiCall(String mobile, String password) async {
    print("Fail!");

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    request.fields.addAll({'phone': mobile, 'password': password});

    request.headers.addAll(requestHeaders);
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {

      if (response.statusCode == 200) {


        var data = jsonDecode(response.body);
          if (data['status_code'] == 200) {
            saveprefs(
              data['token']['plainTextToken'],
              data['data']['phone'],
              data['data']['name'],
              data['data']['email'],
              data['data']['id'].toString(),

            );
            isLoading.value = false;
            print("..........4");
            Get.offAll(() => Main_home(indexof: 0));
          } else {
            print("..........5");
            Fluttertoast.showToast(
              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            isLoading.value = false;
          }
        } else {    print("..........6");

        isLoading.value = false;
          print("Fail! ");
          print(response.body);
          return response.body;
        }
      });
    });
  }
  signUpApiCall(String phone, String password,String full_name, String email) async {
    print("Fail!");

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    request.fields.addAll({'phone': phone, 'password': password,'full_name':full_name,'email':email});

    request.headers.addAll(requestHeaders);
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {

      if (response.statusCode == 200) {


        var data = jsonDecode(response.body);
          if (data['status'] == 201) {

            isLoading.value = false;
            print("..........4");

            Get.offAll(() => Main_home(indexof: 0));
          } else {
            print("..........5");
            Fluttertoast.showToast(
              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            isLoading.value = false;
          }
        } else {    print("..........6");

        isLoading.value = false;
          print("Fail! ");
          print(response.body);
          return response.body;
        }
      });
    });
  }
}

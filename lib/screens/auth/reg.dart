import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../utils/Appurl.dart';
import 'otp.dart';

class reg extends StatefulWidget {
  const reg({Key? key}) : super(key: key);

  @override
  State<reg> createState() => _regState();
}

class _regState extends State<reg> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool submit = false;
  Future registerApi_(
    String name,
    String phone,
    String email,
    String password,
  ) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.reg),
    );
    var status = await OneSignal.shared.getDeviceState();

    var playerId = status!.userId;
    request.fields.addAll({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'player_id':playerId!
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 201) {
          setState(() {
            submit = false;
          });

          Fluttertoast.showToast(
              msg: "OTP sent Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Get.to(() => otp(
                phone: phone,
              ));
        } else {
          setState(() {
            submit = false;
          });
          var data = jsonDecode(response.body);

          Fluttertoast.showToast(
              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
  }

  final TextEditingController controller = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                SizedBox(
                  height: size.height / 10,
                ),
                const Text(
                  'Let’s Create Account!',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                ),
                const Text(
                  'Enter your detail below to create new account',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey),
                ),
                SizedBox(height: size.height / 12),
                Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white10, width: 5.0),
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                  ),
                ),
                SizedBox(height: size.height / 25),
                Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white10, width: 5.0),
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                  ),
                ),
                SizedBox(height: size.height / 25),
                Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                        hintText: "Phone",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white10, width: 5.0),
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                  ),
                ),
                SizedBox(height: size.height / 25),
                Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: pass,
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white10, width: 5.0),
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                submit == false
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                submit = true;
                              });
                              registerApi_(
                                  name.text, phone.text, email.text, pass.text);
                            }
                          },
                          child: Container(
                              height: size.height / 15,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              ))),
                        ),
                      )
                    : const SpinKitCircle(
                        color: Colors.orange,
                        size: 28,
                      )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

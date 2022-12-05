import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart'as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  Future login(String phone, String password) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    var status = await OneSignal.shared.getDeviceState();
    var playerId = status!.userId;

    request.fields.addAll({
      'phone': phone,
      'password': password,
      'player_id':playerId!

    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status_code'] == 200) {
            setState(() {
              islogin = false;
            });

            saveprefs(
              data['token']['plainTextToken'],
              data['data']['name'],
              data['data']['phone'],
              data['data']['email'],
            );
            Fluttertoast.showToast(
                msg: "Login Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
            Get.to(() => Main_home());
          } else {
            setState(() {
              islogin = false;
            });
            Fluttertoast.showToast(
                msg: "Unauthorized",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          setState(() {
            islogin = false;
          });

          print(response.statusCode);

          return response.body;
        }
      });
    });
  }

  bool islogin = false;
  saveprefs(String token, String first_name, String phone, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('name', first_name);
    prefs.setString('phone', phone);

    prefs.setString('email', email);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
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
                'Welcome back!',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
              ),
              const Text(
                'Enter your phone number to get start',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey),
              ),
              SizedBox(height: size.height / 12),
              // Container(
              //   height: size.height/15,
              //   width: size.width,
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(10)
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: InternationalPhoneNumberInput(
              //
              //
              //       onInputChanged: (PhoneNumber number) {
              //
              //         print(number.phoneNumber);
              //       },
              //       onInputValidated: (bool value) {
              //         print(value);
              //       },
              //       selectorConfig: SelectorConfig(
              //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              //       ),
              //       ignoreBlank: false,
              //
              //       autoValidateMode: AutovalidateMode.disabled,
              //       selectorTextStyle: TextStyle(color: Colors.black),
              //       initialValue: number,
              //       textFieldController: controller,
              //       formatInput: false,
              //       inputBorder: OutlineInputBorder(),
              //       keyboardType:
              //       TextInputType.numberWithOptions(signed: true, decimal: true),
              //       onSaved: (PhoneNumber number) {
              //         print('On Saved: $number');
              //       },
              //     ),
              //   ),
              // ),
              Container(
                height: size.height / 15,
                width: size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                      labelText: "Phone",
                      hintText: "Phone ",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder()),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              Container(
                height: size.height / 15,
                width: size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      prefix: Icon(Icons.vpn_key),
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              islogin == false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            islogin = true;
                          });
                          login(controller.text, password.text);
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
                      color: AppColors.orange,
                      size: 25,
                    )
            ],
          ),
        ),
      ),
    ));
  }
}

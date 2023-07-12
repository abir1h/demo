import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/auth/homeController.dart';
import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart'as http;/*
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
*/

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'CompleteProfile.dart';

class otp_new extends StatefulWidget {
  final String phone;

  const otp_new({Key? key, required this.phone}) : super(key: key);

  @override
  State<otp_new> createState() => _otp_newState();
}

class _otp_newState extends State<otp_new> with CodeAutoFill{
  bool submit = false;
  final homecontroller = Get.put(HomeController());

  String pass = '';
  bool islogin=false;
  TextEditingController codeController = TextEditingController();
  TextEditingController email = TextEditingController();
  CountdownController countdownController = CountdownController();
  var datasignature;
  get()async{
    datasignature= await SmsAutoFill().getAppSignature;
    print(datasignature);
  }
  var playerId='';
  Future login() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login2),
    );
    /*var status = await OneSignal.shared.getDeviceState();
     playerId = status!.userId!;*/


    request.fields.addAll({
      'phone': widget.phone,
      'ref':datasignature

    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status_code'] == 200) {

            setState(() {
              homecontroller.onInit();
              islogin = false;
            });

            /*saveprefs(
              data['token']['plainTextToken'],
              data['data']['name'],
              data['data']['phone'],
              data['data']['email'],
            );*/

            Fluttertoast.showToast(
                msg: "Submit OTP",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
/*
            Get.to(() => otp_new(phone: phone,));
*/
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

          print(response.body);

          return response.body;
        }
      });
    });
  }
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    codeController.clear();
    startTimer();
    get();

  }
  startTimer()async{
    Future.delayed(const Duration(milliseconds: 500), () {

// Here you can write your code

      setState(() {
        countdownController.start();
        // Here you can write your code for open new view
      });

    });
  }
  Future otp_Confirm(String otp) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.otp2),
    );

    request.fields.addAll({

      'phone': widget.phone,
      'otp': otp,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if(data['status_code']==200){
            setState(() {
              submit = false;
            });
            saveprefs(
              data['token']['plainTextToken'],
              data['data']['name'],
              data['data']['phone']??'',
              data['data']['email']??'',
            );

            Fluttertoast.showToast(
                msg: "OTP Verified Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
           /* data['data']['name']=="No Name"?Get.to(()=>completeProfile()): Get.to(() => Main_home(
              indexof: 0,
            ));*/
          }else{
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
          }

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
  saveprefs(String token, String first_name, String phone, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('name', first_name);
    prefs.setString('phone', phone);

    prefs.setString('email', email);
  }
  var pin;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool codecomplete=false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Get.back();

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
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
                const Center(
                    child: Text(
                      'Verify Your Account!',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                    )),
                Center(
                    child: Text(
                      'We send a code on your phone number ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey),
                    )), Center(
                    child: Text(
                      widget.phone,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey),
                    )),
                SizedBox(height: size.height / 12),
               /* Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: OtpTextField(
                    numberOfFields: 4,

                    focusedBorderColor: Colors.orange,
                    filled: true,
                    fieldWidth: 70,

                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    fillColor: Colors.white,
                    borderColor: AppColors.end_splash,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (verificationCode) {
                      setState(() {
                        pin=verificationCode;
                      });

                    }, // end onSubmit
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),*/

                Obx(
                      () => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,right: 20),
                            child: PinFieldAutoFill(
                              codeLength: 4,
                    textInputAction: TextInputAction.done,

                    controller: homecontroller.otpEditingController,
                    decoration: BoxLooseDecoration(
                          radius: Radius.circular(10),
                            textStyle: const TextStyle(fontSize: 16, color: Colors.black),

                            gapSpace: 25,

                            bgColorBuilder: FixedColorBuilder(
                              AppColors.white,
                            ), strokeColorBuilder:  FixedColorBuilder(
                          AppColors.orange,
                    ),
                    ),
                    currentCode: homecontroller.messageOtpCode.value,
                    onCodeSubmitted: (code) {},
                    onCodeChanged: (code) {
                            homecontroller.messageOtpCode.value = code!;
                            if (code.length == 4) {
                              setState(() {
                                codecomplete=true;
                              });
                              // To perform some operation
                            }
                    },
                  ),
                          ), const SizedBox(
                            height: 20,
                          ), submit == false
                              ? Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: InkWell(
                              onTap: () {
                                if(codecomplete==true){
                                  setState(() {
                                    submit=true;
                                  });
                                  otp_Confirm(homecontroller.messageOtpCode.value);
                                }
                              },
                              child: Container(
                                  height: size.height / 15,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: codecomplete==true?AppColors.orange:Colors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child:  Center(
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
                          ),
                        ],
                      ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Countdown(
                  controller: countdownController,
                  seconds: 15,
                  interval: const Duration(milliseconds: 1000),
                  build: (context, currentRemainingTime) {
                    if (currentRemainingTime == 0.0) {
                      return GestureDetector(
                        onTap: () {

                          setState(() {
                            startTimer();

                            homecontroller.messageOtpCode.value='';
                            codecomplete=false;

                          });
                          login();
                          // write logic here to resend OTP
                        },
                        child:Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20),
                          child: Container(
                              height: size.height / 15,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.orange),
                                  borderRadius: BorderRadius.circular(10)),
                              child:  Center(
                                  child: Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.orange),
                                  ))),
                        )
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Resend OTP in : ",style: TextStyle(
                              color: AppColors.orange,fontSize: 12,fontWeight: FontWeight.w700
                          ),),Text("${currentRemainingTime.toString().length == 4 ? " ${currentRemainingTime.toString().substring(0, 2)}" : " ${currentRemainingTime.toString().substring(0, 1)}"}",style: TextStyle(
                              color: Colors.black,fontSize: 12,fontWeight: FontWeight.w700
                          ),),

                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void codeUpdated() {
    // TODO: implement codeUpdated
  }
}

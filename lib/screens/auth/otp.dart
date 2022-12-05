import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart'as http;

class otp extends StatefulWidget {
  final String phone;

  const otp({Key? key, required this.phone}) : super(key: key);

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  bool submit = false;

  String pass = '';
  TextEditingController codeController = TextEditingController();
  TextEditingController email = TextEditingController();

  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    codeController.clear();
  }
  Future otp_Confirm(String otp) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.otp),
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

            Fluttertoast.showToast(
                msg: "OTP Verified Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
            Get.to(() => Main_home(
            ));
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
  var pin;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
            msg: "Can't go back at this stage!!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
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
                  'We send a code on your phone number ' + widget.phone,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey),
                )),
                SizedBox(height: size.height / 12),
                Container(
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
                ),
                submit == false
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if(pin!=null){
                              setState(() {
                                submit=true;
                              });
                              otp_Confirm(pin.toString());
                            }else{
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                headerAnimationLoop: false,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Data Missing',
                                desc: 'Please Enter OTP',
                                buttonsTextStyle: const TextStyle(color: Colors.black),
                                showCloseIcon: true,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();

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
                      ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

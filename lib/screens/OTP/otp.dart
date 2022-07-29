import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/login/login.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:learning_school_bd/widget/big-text.dart';
import 'package:learning_school_bd/widget/button.dart';
import 'package:sizer/sizer.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {

  @override
  void initState(){
    super.initState();
    startTimer();
  }
  //TODO: Timer count down sunction
  late Timer _timer;
  int _start = 60;
  var _reSend;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _reSend = "Resend Code";
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.only(left: 10, right: 10, ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Center(
                child: Image.asset("assets/images/logo.png", height: 100, width: 200, fit: BoxFit.cover,),
              ),


              SizedBox(height: 20,),

              Text("Code has been send to + ******99",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Nanu",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black
                ),
              ),
              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                padding: EdgeInsets.only(left: 30, right: 30),
                child: OtpTextField(
                  numberOfFields: 4,
                  filled: true,
                  fieldWidth: 50,
                  fillColor: AppColors.white,
                  borderColor: Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        }
                    );
                  }, // end onSubmit
                ),
              ),


              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Resend code in ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.black
                            )
                        ),
                        TextSpan(
                            text: _reSend == null ? "$_start":_reSend,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF597CF8)
                            )
                        ),
                        TextSpan(
                            text: " s",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.white
                            )
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Bounce(
                  child: const AppButton(text: "Continue"),
                  duration: Duration(milliseconds: 80),
                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()))
              )





            ],
          ),
        ),
      ),
    );
  }

  loginFun() {}
}

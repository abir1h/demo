import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:http/http.dart'as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../utils/Appurl.dart';
import '../../widget/big-text.dart';
import '../../widget/button.dart';
import '../MainHome.dart';
import 'OTPNEw.dart';
import 'homeController.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  var datasignature;
  late bool _passwordVisible;
  bool submit=false;
  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }
  TextEditingController pass=TextEditingController();
  var playerId='';
  Future login(String phone) async {
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
      'phone': phone,
      'ref':datasignature

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

            /*saveprefs(
              data['token']['plainTextToken'],
              data['data']['name'],
              data['data']['phone'],
              data['data']['email'],
            );*/
            Fluttertoast.showToast(
                msg: "Submit otp sent to your mobile",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);

            Get.to(() => otp_new(phone: phone,));
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
  bool islogin = false;
  saveprefs(String token, String first_name, String phone, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('name', first_name);
    prefs.setString('phone', phone);

    prefs.setString('email', email);
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("YES"),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  TextButton(
                    child: Text("NO"),
                    onPressed: () {
                    },
                  )
                ],
              );
            });
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding:  EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              /*  SizedBox(height: 100,),
                Center(
                  child: InkWell(
                      onTap: (){
                       *//* setState(() {
                          submit=false;
                        });*//*
                      },
                      child: Image.asset("assets/images/logo.png", fit: BoxFit.cover,)),
                ),
*/
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(left: 10,),
                  child: Align(alignment:Alignment.centerLeft, child: BigText(text: "SIGN IN")),
                ),

                SizedBox(height: 40,),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        //###############--- Email ---#########
                        TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.number,

                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              fontFamily: "Poppins",
                            ),
                            contentPadding: EdgeInsets.only(left: 20, right: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.mainColor.withOpacity(0.2), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200, width: 2.0),
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Phone Number Field much not be empty";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15,),
                        //###############--- Password ---#########
                        TextFormField(                          controller: pass,

                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontFamily: "Poppins",
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ?  Icons.visibility : Icons.visibility_off,
                                color: AppColors.mainColor,
                              ), onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            ),
                            contentPadding: EdgeInsets.only(left: 20, right: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.mainColor.withOpacity(0.2), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200, width: 2.0),
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Password Number Field much not be empty";
                            }
                            return null;
                          },
                        ),


                        SizedBox(height: 40,),

                        submit==false? Bounce(
                            duration: Duration(milliseconds: 80),
                            onPressed: (){
                              if(_formKey.currentState!.validate()){
                              /*  setState(() {
                                  submit=true;
                                });
*//*
                                login();
*/
                              }
                            },
                            child: AppButton(text: "Login",)
                        ):SpinKitCircle(color: AppColors.mainColor,size: 30,),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Or",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                              ),
                              InkWell(
                                onTap: () {

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account ?",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)), Text("Signup",
                                            style: TextStyle(
                                                color: AppColors.mainColor,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        ),

                      ],
                    ),
                  ),
                ),







              ],
            ),
          ),
        ),
      ),
    );
  }
}

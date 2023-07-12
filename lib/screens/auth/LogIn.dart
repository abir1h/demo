import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:learning_school_bd/widget/big-text.dart';
import 'package:learning_school_bd/widget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart'as http;

import 'SignUp.dart';
import 'loginController.dart';
import 'logincontroler2.dart';
GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();


class LoginView extends GetView<LoginController2> {

  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController2());

    var _passwordVisible;
    return Obx(() => SafeArea(
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Image.asset('assets/images/login.png'),

              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left: 10,),
                child: Align(alignment:Alignment.centerLeft, child: BigText(text: "SIGN IN")),
              ),

              SizedBox(height: 20,),
              Expanded(
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    children: [
                      //###############--- Email ---#########
                      TextFormField(
                        controller: controller.mobileController.value,
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
                  Obx(() =>  TextFormField(


                    obscureText: controller.showPassword.value,
                    controller: controller.passwordController.value,

                    decoration: InputDecoration(
                      hintText: "Password",



                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showPassword.value ?  Icons.visibility : Icons.visibility_off,
                          color: AppColors.mainColor,
                        ), onPressed: () {
                        controller.togglePassword();
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
                  )),



                    SizedBox(height: 40,),

                      controller.isLoading.value==false? Bounce(
                          duration: Duration(milliseconds: 80),
                          onPressed: (){
                            if(_loginFormKey.currentState!.validate()){

                              controller.login();
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
/*
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => SignUp()));
*/
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Don't have an account ?",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)), InkWell(
                                        onTap: (){
                                          Get.to(()=>SignUpView(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 100));
                                        },
                                                child: Text("Signup",
                                          style: TextStyle(
                                                color: AppColors.mainColor,
                                                fontSize: 16)),
                                              ),
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
    ));
  }
}


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late bool _passwordVisible;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  var datasignature;
  bool submit=false;
  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }
  TextEditingController pass=TextEditingController();

  saveprefs(String token, String phone, String name, String email,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('phone', phone);
    prefs.setString('email', email);
    prefs.setString('name', name);


  }
  Future login() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    request.fields.addAll({'phone':phone.text,
      'password':pass.text
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print('response.body ' + data.toString());
          if (data['status_code'] == 200) {
            saveprefs(data['token']['plainTextToken'],
              data['data']['phone'],
              data['data']['name'],
              data['data']['email'],

            );
            setState(() {
              submit=false;
            });

            Fluttertoast.showToast(
              msg: "LoggedIn Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            // Get.to(
            //       () => const SuccessScreen(),
            //   duration: const Duration(
            //     milliseconds: 500,
            //   ),
            //   transition: Transition.zoom,
            // );
            //
            // return user2.fromJson(data);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (_) => login_screen()));
          } else {
            print("Fail!");
            Fluttertoast.showToast(
              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            setState(() {
              submit=false;
            });
          }
        } else {
          setState(() {
            submit=false;
          });
          print("Fail! ");
          print(response.body);
          return response.body;
        }
      });
    });
  }  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
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
                      Navigator.of(context).pop();
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
                SizedBox(height: 20,),
                Center(
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          submit=false;
                        });
                      },
                      child: Image.asset("assets/images/logo.png", height: 200, width: 200, fit: BoxFit.cover,)),
                ),

                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(left: 10,),
                  child: Align(alignment:Alignment.centerLeft, child: BigText(text: "SIGN IN")),
                ),

                SizedBox(height: 20,),
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
                                setState(() {
                                  submit=true;
                                });
                                login();
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
/*
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => SignUp()));
*/
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

  loginFun() {}
}

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:learning_school_bd/widget/big-text.dart';
import 'package:learning_school_bd/widget/button.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late bool _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.only(left: 10, right: 10, top: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Center(
                child: Image.asset("assets/images/logo.png", height: 100, width: 200, fit: BoxFit.cover,),
              ),

              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left: 10,),
                child: Align(alignment:Alignment.centerLeft, child: BigText(text: "SIGN IN")),
              ),

              SizedBox(height: 20,),
              Expanded(
                child: Form(
                  child: ListView(
                    children: [
                      //###############--- Email ---#########
                      TextFormField(
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
                      TextFormField(
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

                      Bounce(
                          duration: Duration(milliseconds: 80),
                          onPressed: ()=>Get.to(Login()),
                          child: AppButton(text: "Login",)
                      )


                    ],
                  ),
                ),
              ),







            ],
          ),
        ),
      ),
    );
  }

  loginFun() {}
}

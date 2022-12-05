import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart'as http;
import 'package:learning_school_bd/screens/auth/phone_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
class changePassword extends StatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  getname()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name_ = prefs.getString('name');
    String? phone_ = prefs.getString('phone');
    setState(() {
      nametext.text=name_!;
      phonetext.text=phone_!;
    });
  }
  var name,phone;
  bool submit=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
  }
  Future changepass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.changePassword),
    );
    request.fields.addAll({
      'new_password':newPass.text,
      'password':currentPass.text

    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var userData1 = jsonDecode(response.body);
          if(userData1['status_code']==200){
            setState(() {
              submit = false;
            });
            var userData1 = jsonDecode(response.body)['data'];
            Fluttertoast.showToast(
                msg: "Password Change Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
            Get.to(() => login_screen());
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
            return response.body;
          }

        } else {
          setState(() {
            submit = false;
          });
          var data = jsonDecode(response.body);

          Fluttertoast.showToast(
              msg: "Something went wrong",
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

  TextEditingController nametext=TextEditingController();
  TextEditingController phonetext=TextEditingController();
  TextEditingController currentPass=TextEditingController();
  TextEditingController newPass=TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      appBar: AppBar(

        centerTitle: true,
        backgroundColor: AppColors.orange,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              radius: 5,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: nametext,
                    enabled: false,
                    decoration:  InputDecoration(
                        labelText: "Name",
                        // hintText: "Password",


                        border: OutlineInputBorder(borderRadius:BorderRadius.circular(15) )),
                  ),
                ),
              ),
              SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: phonetext,
                    enabled: false,
                    decoration:  InputDecoration(
                        labelText: "Phone",
                        // hintText: "Password",


                        border: OutlineInputBorder(borderRadius:BorderRadius.circular(15) )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: currentPass,
                    validator: (v)=>v!.isEmpty?"Please enter Current password":v.length<6?"password must be in 6 character":null,

                    decoration:  InputDecoration(
                        labelText: "Current Password",
                        // hintText: "Password",


                        border: OutlineInputBorder(borderRadius:BorderRadius.circular(15) )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height / 15,
                  width: size.width,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: newPass,
                    validator: (v)=>v!.isEmpty?"Please enter new password":v.length<6?"password must be in 6 character":null,
                    decoration:  InputDecoration(
                        labelText: "New Password",
                        // hintText: "Password",


                        border: OutlineInputBorder(borderRadius:BorderRadius.circular(15) )),
                  ),

                ),
              ),
              SizedBox(height: 15,),
        submit==false?  Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                if(formKey.currentState!.validate()){
                  setState(() {
                    submit=true;
                  });
                  changepass();
                }
              },
              child: Container(
                height: size.height/18,
                width: size.width,


                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.orange
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                  ],
                ),
              ),
            ),
          ):SpinKitCircle(
          color: AppColors.orange,
          size: 25,
        ),

            ],
          ),
        ),
      ),

    ));
  }
}

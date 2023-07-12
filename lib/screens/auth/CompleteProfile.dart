// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/route_manager.dart';
// import 'package:http/http.dart'as http;
// import 'package:learning_school_bd/utils/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../utils/Appurl.dart';
// import '../MainHome/Main-Home.dart';
// class completeProfile extends StatefulWidget {
//   const completeProfile({Key? key}) : super(key: key);
//
//   @override
//   State<completeProfile> createState() => _completeProfileState();
// }
//
// class _completeProfileState extends State<completeProfile> {
//   TextEditingController name=TextEditingController();
//   TextEditingController email=TextEditingController();
//   bool male=false;
//   bool female=false;
//   bool submit=false;
//   var selectedGender='';
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   Future otp_Confirm(String name,String email,String Gend) async {SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('token');
//     Map<String, String> requestHeaders = {
//       'Accept': 'application/json',      'authorization': "Bearer $token"
//
//     };
//     var request = await http.MultipartRequest(
//       'POST',
//       Uri.parse(AppUrl.completeProfile),
//     );
//
//     request.fields.addAll({
//
//       'name': name,
//       'email':email,
//       'gender':Gend
//     });
//
//     request.headers.addAll(requestHeaders);
//
//     request.send().then((result) async {
//       http.Response.fromStream(result).then((response) {
//         if (response.statusCode == 200) {
//           var data = jsonDecode(response.body);
//           if(data['status_code']==200){
//             setState(() {
//               submit = false;
//             });
//
//             Fluttertoast.showToast(
//                 msg: "Data Submitted Successfully",
//                 toastLength: Toast.LENGTH_LONG,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: Colors.black54,
//                 textColor: Colors.white,
//                 fontSize: 16.0);
//             Get.to(() => Main_home(
//               indexof: 0,
//             ));
//           }else{
//             setState(() {
//               submit = false;
//             });
//             var data = jsonDecode(response.body);
//
//             Fluttertoast.showToast(
//                 msg: data['message'],
//                 toastLength: Toast.LENGTH_LONG,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: Colors.red,
//                 textColor: Colors.white,
//                 fontSize: 16.0);
//           }
//
//         } else {
//           setState(() {
//             submit = false;
//           });
//           var data = jsonDecode(response.body);
//
//           Fluttertoast.showToast(
//               msg: data['message'],
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 16.0);
//           return response.body;
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size=MediaQuery.of(context).size;
//     return SafeArea(child: Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//           leadingWidth: 50,
//         leading: InkWell(
//           onTap: (){
//             Get.back();
//           },
//           child: CircleAvatar(
//             radius: 15,
//             backgroundColor: AppColors.gr,
//             child: Icon(Icons.arrow_back_ios,color: Colors.black,),
//           ),
//         ),
//         centerTitle: true,
//         title: Text("Complete Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16),),
//
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: formKey,
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: size.height/25,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0,right: 20),
//                 child: Container(
//                   height: size.height / 15,
//                   width: size.width,
//                   decoration:
//                   BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                   child: TextFormField(
//                     controller: name,
//                     validator: (v)=>v!.isEmpty?'Please enter your name':null,
//                     decoration: const InputDecoration(
//                         labelText: "Enter Your Name",
//                         border: OutlineInputBorder()),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 25,),
//
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0,right: 20),
//                 child: Container(
//                   height: size.height / 15,
//                   width: size.width,
//                   decoration:
//                   BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                   child: TextFormField(
//                     controller: email,
//                     decoration: const InputDecoration(
//                         labelText: "Enter your email",
//                         border: OutlineInputBorder()),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 35,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0,right: 20),
//                 child: Text("Select Gender"),
//               ),
//               SizedBox(height: 20,),
//
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0,right: 20),
//                 child: Container( height: size.height/15,
//                   width: size.width,
//                   child: Row(mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: InkWell(
//                           onTap:(){
//                             setState(() {
//
//                               selectedGender="Male";
//                             });
//                           },
//                           child: Container(
//                             height: size.height/15,
//                             width: size.width/3,
//                             decoration: BoxDecoration(
//                               color: selectedGender=="Male"?AppColors.orange:Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: selectedGender=="Male"?AppColors.orange:Colors.grey)
//
//                             ),child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//
//                               Image.asset('assets/images/male.png'),
//                               Text('Male',style: TextStyle(
//                                 color: Colors.black,fontWeight: FontWeight.w500
//                               ),)
//
//                             ],
//                           ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 35,),
//                       Expanded(
//                         child: InkWell(
//                           onTap:(){
//                             setState(() {
//
//                               selectedGender="Female";
//                             });
//                           },
//                           child: Container(
//                             height: size.height/15,
//                             width: size.width/3,
//                             decoration: BoxDecoration(
//                                 color: selectedGender=="Female"?AppColors.orange:Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(color: selectedGender=="Female"?AppColors.orange:Colors.grey)
//
//                             ),child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//
//                               Image.asset('assets/images/female.png'),
//                               Text('Female',style: TextStyle(
//                                   color: Colors.black,fontWeight: FontWeight.w500
//                               ),)
//
//                             ],
//                           ),
//                           ),
//                         ),
//                       ),
//
//
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: size.height/20,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0,right: 20),
//                 child: InkWell(
//                   onTap: (){
//                     if(selectedGender!='' && name.text.isNotEmpty){
//                       if(formKey.currentState!.validate()){
//
//                         otp_Confirm(name.text,email.text.isNotEmpty?email.text:'',selectedGender
//                         );
//                       }
//                     }else{
//                       Fluttertoast.showToast(
//                           msg: "Please enter all the required fields",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 1,
//                           backgroundColor: Colors.black54,
//                           textColor: Colors.white,
//                           fontSize: 16.0);
//                     }
//
//                   },
//                   child
//                       : Container(
//                       height: size.height / 15,
//                       width: size.width,
//                       decoration: BoxDecoration(
//                           color: selectedGender!='' && name.text.isNotEmpty?AppColors.orange:Colors.grey,
//                           borderRadius: BorderRadius.circular(10)),
//                       child:  Center(
//                           child: Text(
//                             'Submit',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                                 color: Colors.white),
//                           ))),
//                 ),
//               ),
//               SizedBox(height: 40,),
//           Center(child: Text("Or",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16),)),
//               SizedBox(height: 25,),
//
//               Padding(
//             padding: const EdgeInsets.only(left: 20.0,right: 20),
//             child: Container(
//                       height: size.height / 18,
//                       width: size.width ,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: AppColors.g),
//                         color: Colors.white,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/images/google.png',
//                             height: 25,
//                             width: 25,
//                           ),
//                           const Text(
//                             "   Complete with Google",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 12),
//                           )
//                         ],
//                       ),
//                     ),
//           ),              SizedBox(height: 25,),
//
//               Padding(
//             padding: const EdgeInsets.only(left: 20.0,right: 20),
//             child: Container(
//                       height: size.height / 18,
//                       width: size.width ,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: AppColors.g),
//                         color: Colors.white,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/images/fb.png',
//                             height: 25,
//                             width: 25,
//                           ),
//                           const Text(
//                             "   Complete with Facebook",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 12),
//                           )
//                         ],
//                       ),
//                     ),
//           ),
//
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }

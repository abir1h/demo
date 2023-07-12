/*
import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  // handleAuthState() {
  //   return StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (BuildContext context, snapshot) {
  //         if (snapshot.hasData) {
  //           return HomeScreen();
  //         } else {
  //           return const LoginPages();
  //         }
  //       });
  // }
  Future<http.Response> createFunction(String? name,String? email,String? uid) async{
    print('step1');

    var response=await http.post(
        Uri.parse('https://api.fooddoose.com/simple-user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "userInfo":{
            "displayName":name,
            "email": email,
            "uid": uid
          }
        },)
    );
    if(response.statusCode==200){
      print('loginsuccefull');
      print(response.body);
      var data = jsonDecode(response.body);
      if(data['success']==true){

        print(data['refreshtoken']);
        saveprefs(data['accessToken'],data['userData']['displayName'],data['userData']['email'],data['userData']['_id'],data['refreshtoken']);
*/
/*
        Get.to(()=>SelectNewAddress());
*//*

      }else{
        print(response.body);
      }


      return response;
    }else{
      print(response.body);
      print(response.statusCode);
      return response;

    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      print('done');
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn(scopes: <String>["email"]).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      print(googleUser);
      Map user = {
        "displayName": googleUser.displayName,
        "email": googleUser.email,
        "uid": googleUser.id
      };
      print(user);
     */
/* createFunction(googleUser.displayName,googleUser.email,googleUser.id);*//*



      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('done');
     */
/* var uid=FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(googleUser.email)
          .set({
        'name':googleUser.displayName,
        'email':googleUser.email,
        'google_id':googleUser.id,
        'uid':uid
      });
*//*


      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }
  saveprefs(String token,String name,String email,String uid,String ref_token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('id', uid);
    prefs.setString('ref_token', ref_token);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
*/

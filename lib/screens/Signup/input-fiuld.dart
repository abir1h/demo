import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LsbInput extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  const LsbInput({Key? key, required this.controller,  this.obscureText = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: "Full Name",
        hintStyle: TextStyle(
          fontFamily: "Poppins",
        ),
        contentPadding: EdgeInsets.zero,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2.0),
        ),
      ),
      validator: (value){
        if(value!.isEmpty){
          return "Name Field much not be empty";
        }
        return null;
      },
    );
  }
}

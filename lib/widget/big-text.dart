import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  String text;
  Color? color;
  String? FontFamily;
  BigText(
      {required this.text,
      this.color = Colors.black,
      this.FontFamily = "Ubuntu"});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: color,
        fontFamily: FontFamily,
      ),
    );
  }
}

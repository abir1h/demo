import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BigText extends StatelessWidget {
  String text;
  double? size;
  Color? color;
  String? FontFamily;
  BigText({required this.text, this.size = 16, this.color = Colors.black, this.FontFamily = "Ubuntu"});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size?.sp,
          color: color,
        fontFamily: FontFamily,
      ),
    );
  }
}
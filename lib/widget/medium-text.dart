import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MediunText extends StatelessWidget {
  String text;
  double? size;
  Color ? color;
  MediunText({required this.text, this.size = 10, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: size?.sp,
          color: color
      ),
    );
  }
}
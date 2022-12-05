import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/colors.dart';
import 'big-text.dart';

class AppButton extends StatelessWidget {
  final String text;
  const AppButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(left: width / 4, right: width / 4),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      decoration: BoxDecoration(
          color: AppColors.mainColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: BigText(
          text: text,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:learning_school_bd/utils/colors.dart';
class Instructors extends StatefulWidget {
  const Instructors({Key? key}) : super(key: key);

  @override
  State<Instructors> createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Container(
      height: size.height/1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [



        ],
      ),
    );
  }
}

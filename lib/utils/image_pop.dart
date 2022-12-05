import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class image_pop extends StatefulWidget {
  const image_pop(
      {Key? key,
      required this.height,
      required this.width,
      required this.image})
      : super(key: key);

  final double height;
  final double width;
  final String image;

  @override
  State<image_pop> createState() => _image_popState();
}

class _image_popState extends State<image_pop> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool reminderOn = false;
  List<bool> days = [false, false, false, false, false, false, false];
  List selected = [];
  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();
  String time = DateFormat.jm().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: widget.height * 0.7,
        width: widget.width * 0.98,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: widget.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/f1.png')),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(15)),
                  ),
                  // child: Column(
                  //   children: [
                  //     SizedBox(height: 20,),
                  //     Row(mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text("Flat",style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 24,fontWeight: FontWeight.w600
                  //             ),),
                  //             Row(
                  //               crossAxisAlignment: CrossAxisAlignment.end,
                  //               children: [
                  //                 SizedBox(width: widget.width/6,),
                  //                 Text("15%",style: TextStyle(
                  //                     color: AppColors.orange,
                  //                     fontSize: 36,fontWeight: FontWeight.w900
                  //                 ),),Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Text("off",style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontSize: 20,fontWeight: FontWeight.w600
                  //                   ),),
                  //                 ),
                  //               ],
                  //             )
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

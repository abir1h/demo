import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/utils/Appurl.dart';
import 'package:photo_view/photo_view.dart';

class test extends StatefulWidget {
  final List picture;
  const test({Key? key, required this.picture}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final GlobalKey formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(

        child: Scaffold(
          backgroundColor: Colors.black,
            body: SingleChildScrollView(
      child: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [


            Container(
              height: size.height,width: size.width,

              child: ListView.builder(
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,

                  itemCount: widget.picture.length,
                  itemBuilder: (_, index) {
                    return Container(
                        height: size.height,width: size.width,
                        child: PhotoView(
                            imageProvider: NetworkImage(AppUrl.pic_url1 +
                                widget.picture[index]['image'])));
                    /*Container(height: size.height,width: size.width,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     image: NetworkImage(
                       AppUrl.pic_url1+widget.picture[index]['image']
                     ),fit: BoxFit.cover
                   )
                 ),
                 );*/
                  }),
            ),
            Positioned(
                right: 10,top: 20,
                child:                 IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close,color: Colors.white,))
            ) ,Positioned(
                left: 20,top: 20,
                child:Text(widget.picture.length.toString()+ ' Images',style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    )));
  }
}

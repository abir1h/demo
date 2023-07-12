import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/category/categoryController.dart';

import '../../utils/colors.dart';
import '../CourseOpen/CourseView.dart';
import '../HomePage/HomeController.dart';
class cagtegoryOpen extends StatefulWidget {
  final String name;
  const cagtegoryOpen({Key? key, required this.name}) : super(key: key);

  @override
  State<cagtegoryOpen> createState() => _cagtegoryOpenState();
}

class _cagtegoryOpenState extends State<cagtegoryOpen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    var size = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Get.back();
        },),
        title: Text(widget.name,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_,index){
          return InkWell(
            onTap: (){
/*
              Get.to(()=>CoursView(CourseName: controller.bundletitle[index],link: controller.bundlelinks[index],price: controller.bundelprice[index],),transition: Transition.rightToLeft);
*/

            },
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width/2.1,

                          child: Text(controller.bundletitle[index],
                            softWrap: true,
                            style: const TextStyle(
                                color: Colors.black,fontWeight: FontWeight.w800
                            ),),
                        ),const SizedBox(height: 10,),SizedBox(
                          width: size.width/2.1,

                          child: Text(controller.bundelprice[index],
                            softWrap: true,
                            style: const TextStyle(
                                color: AppColors.mainColor,fontWeight: FontWeight.w800
                            ),),
                        ),
                      ],
                  ),
                   ),
                    Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height/8,
                        width: size.width/2.2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:AssetImage(controller.bundle[index],),fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(5)


                        ),
                      ),
                  ),
                    ),
                ],
              ),
            ),
          );
        },
        itemCount: controller.bundle.length,
      )
    ));
  }
}

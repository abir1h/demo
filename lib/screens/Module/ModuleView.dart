import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

import 'Leaderboard_list.dart';
import 'LiveClass.dart';
import 'ModuleController.dart';
import 'QuizView.dart';
class ModuleView extends StatefulWidget {
  const ModuleView({Key? key}) : super(key: key);

  @override
  State<ModuleView> createState() => _ModuleViewState();
}

class _ModuleViewState extends State<ModuleView> {
  final controller = Get.put(ModuleController());
  bool isImageCached = false;
  String? log;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button

          backgroundColor: Colors.white, elevation: 0,

          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Obx(()=>Text(
           controller.CourseName.value.toString(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16),
          ),)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25 ,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: size.height / 6,
                width: size.width,
                child: FastCachedImage(
                  url: controller.Courseiamge.value.toString(),
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(seconds: 1),
                  errorBuilder: (context, exception, stacktrace) {
                    return Text(stacktrace.toString());
                  },
                  loadingBuilder: (context, progress) {
                    debugPrint(
                        'Progress: ${progress.isDownloading} ${progress.downloadedBytes} / ${progress.totalBytes}');
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(.5),
                      highlightColor: Colors.white70,
                      child: Container(

                        height: size.height / 6,
                        width: size.width,

                      ),
                    );
                  },
                ),
              ),
            ),



            Divider(),
            SizedBox(height: 10 ,),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(

                children: [
                 Expanded(child:  InkWell (
                   onTap: (){
                     Get.to(()=>LiveClass(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 500));
                   },
                   child: Container(
                     height: size.height/7,
                    
                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey.withOpacity(.3)),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white
                     ),child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [SizedBox(height: 10,),
                         Center(child: Image.asset("assets/images/onlinecourse.png",height: 60,width: 60,)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Center(child: Text("Live Class",maxLines: 1,style: TextStyle(fontSize: 11),)),
                         ),

                       ],
                     ),
                   ),
                   ),
                 )),SizedBox(width: 15,),
                 Expanded(child:  InkWell(
                   onTap: (){
                     Get.snackbar("Comming Soon!!", "This features is comming soon",borderRadius:10,backgroundColor: Colors.black45,snackStyle: SnackStyle.FLOATING,colorText: Colors.white);
                   },
                   child: Container(
                     height: size.height/7,

                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey.withOpacity(.3)),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white
                     ),child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [SizedBox(height: 10,),
                         Center(child: Image.asset("assets/images/book.png",height: 60,width: 60,)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Center(child: Text("Books",maxLines: 1,style: TextStyle(fontSize: 11),)),
                         ),

                       ],
                     ),
                   ),
                   ),
                 )),SizedBox(width: 15,),
                 Expanded(child:  InkWell(
                   onTap: (){
                     Get.to(()=>QuizView(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 500));

                   },
                   child: Container(
                     height: size.height/7,
                    
                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey.withOpacity(.3)),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white
                     ),child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [SizedBox(height: 10,),
                         Center(child: Image.asset("assets/images/checklist.png",height: 60,width: 60,)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Center(child: Text("Assesments",maxLines: 1,style: TextStyle(fontSize: 11),)),
                         ),

                       ],
                     ),
                   ),
                   ),
                 )),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(

                children: [
                 Expanded(child:  InkWell(
                   onTap: (){
                     Get.to(()=>LeaderBoardList(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 500));
                   },
                   child: Container(
                     height: size.height/7,
                    
                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey.withOpacity(.3)),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white
                     ),child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [SizedBox(height: 10,),
                         Center(child: Image.asset("assets/images/podium.png",height: 60,width: 60,)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Center(child: Text("Leaderboard",maxLines: 1,style: TextStyle(fontSize: 11),)),
                         ),

                       ],
                     ),
                   ),
                   ),
                 )),SizedBox(width: 15,),
                 Expanded(child:  InkWell(
                   onTap: (){
                     Get.snackbar("Comming Soon!!", "This features is comming soon",borderRadius:10,backgroundColor: Colors.black45,snackStyle: SnackStyle.FLOATING,colorText: Colors.white);
                   },
                   child: Container(
                     height: size.height/7,

                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey.withOpacity(.3)),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white
                     ),child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [SizedBox(height: 10,),
                         Center(child: Image.asset("assets/images/certificate.png",height: 60,width: 60,)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Center(child: Text("Certificates",maxLines: 1,style: TextStyle(fontSize: 11),)),
                         ),

                       ],
                     ),
                   ),
                   ),
                 )),SizedBox(width: 15,),
                 Expanded(child:  Container(
                   height: size.height/7,
                  
                   decoration: BoxDecoration(
                       //border: Border.all(color: Colors.grey.withOpacity(.3)),
                       borderRadius: BorderRadius.circular(10),
                       color: Colors.white
                   ),/*child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     children: [SizedBox(height: 10,),
                       Center(child: Image.asset("assets/images/checklist.png",height: 60,width: 60,)),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Center(child: Text("Assesments")),
                       ),

                     ],
                   ),
                 ),*/
                 )),

                ],
              ),
            ),

          ],
        ),
      ),

    ));
  }
}

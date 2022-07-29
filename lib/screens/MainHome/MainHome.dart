import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_school_bd/utils/colors.dart';
class MainHome extends StatefulWidget {
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 50,right: 50),
              child: Container(
                height: height/18,
                decoration: BoxDecoration(
                  color:AppColors.light,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome to',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      Text('  Learning School BD',style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(                          mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width,
                      height: height/15,
                      decoration: BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Icon(Icons.search,color: AppColors.light,size: 40,),
                            Text('আপনার কাঙ্খিত প্রশ্ন খুজুন ',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0,right: 15),
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active,color: AppColors.mainColor,size: 50,)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      Container(
                        height: 40,
                        width: 15,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      Text('   কোর্স সমূহ ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Text('সব দেখুন',style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold,fontSize: 14),)

                ],
              ),
            ),            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: height/4.6,
                width: width,
                child: ListView.builder(itemBuilder: (_,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width/1.2,
                      height: height/4.6,
                      decoration: BoxDecoration(
                  gradient: LinearGradient( colors: [ AppColors.start_color,  AppColors.end_color, ],),
                  borderRadius: BorderRadius.circular(15)

                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 38,
                                    // child: Image.asset('assets/images/book.jpeg'),
                                  ),
                                ),Expanded(child: Text('বাংলা সাহিত্য, বাংলা ব্যাকারন ২, ৪৫ তম বিসিএস প্রস্তুতি। ',style: TextStyle(color: Colors.white),))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.group_outlined,color: Colors.white,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('৫৫১ জন',style: TextStyle(color: Colors.white,fontSize: 15),),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height:30,width:30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text('10',style: TextStyle(color: AppColors.text,fontSize: 15),),
                                      ),
                                    ),SizedBox(width: 5,),  Container(
                                      height:30,width:30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text('12',style: TextStyle(color: AppColors.text,fontSize: 15),),
                                      ),
                                    ),SizedBox(width: 5,),  Container(
                                      height:30,width:30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text('53',style: TextStyle(color: AppColors.text,fontSize: 15),),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  );

                },
                  scrollDirection: Axis.horizontal,
                itemCount: 5,shrinkWrap: true,)
              ),
            ) ,  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      Container(
                        height: 40,
                        width: 15,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      Text('   লাইভ এক্সাম ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Text('সব দেখুন',style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold,fontSize: 14),)

                ],
              ),
            ),            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: height/4.6,
                width: width,
                child: ListView.builder(itemBuilder: (_,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width/1.2,
                      height: height/4.6,
                      decoration: BoxDecoration(
                  gradient: LinearGradient( colors: [ AppColors.start_color,  AppColors.end_color, ],),
                  borderRadius: BorderRadius.circular(15)

                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 38,
                                  ),
                                ),Expanded(child: Text('বাংলা সাহিত্য, বাংলা ব্যাকারন ২, ৪৫ তম বিসিএস প্রস্তুতি। ',style: TextStyle(color: Colors.white),))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.group_outlined,color: Colors.white,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('৫৫১ জন',style: TextStyle(color: Colors.white,fontSize: 15),),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height:30,width:30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text('10',style: TextStyle(color: AppColors.text,fontSize: 15),),
                                      ),
                                    ),SizedBox(width: 5,),  Container(
                                      height:30,width:30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text('12',style: TextStyle(color: AppColors.text,fontSize: 15),),
                                      ),
                                    ),SizedBox(width: 5,),  Container(
                                      height:30,width:30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text('53',style: TextStyle(color: AppColors.text,fontSize: 15),),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  );

                },
                  scrollDirection: Axis.horizontal,
                itemCount: 5,shrinkWrap: true,)
              ),
            ),
            SizedBox(height: 15 ,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height/8,
                        width: width/3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                spreadRadius: 5,

                                blurRadius: 7,

                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),]    ,
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height/8,
                        width: width/3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                spreadRadius: 5,

                                blurRadius: 7,

                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),]    ,
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height/8,
                        width: width/3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                spreadRadius: 5,

                                blurRadius: 7,

                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),]    ,
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height/8,
                        width: width/3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                spreadRadius: 5,

                                blurRadius: 7,

                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),]    ,
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height/8,
                        width: width/3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                spreadRadius: 5,

                                blurRadius: 7,

                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),]    ,
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height/8,
                        width: width/3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                spreadRadius: 5,

                                blurRadius: 7,

                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),]    ,
                            color: Colors.white,
                            borderRadius:BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      Container(
                        height: 40,
                        width: 15,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      Text('   ভিডিও লেশন ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Text('সব দেখুন',style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold,fontSize: 14),)

                ],
              ),
            ),            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                  height: height/3.2,
                  width: width,
                  child: ListView.builder(itemBuilder: (_,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: width/2.2,
                          height: height/3.5,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),

                                  spreadRadius: 5,

                                  blurRadius: 7,

                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),]    ,
                              color: Colors.white,
                              borderRadius:BorderRadius.circular(10)
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: width/2,
                                  height: height/5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/video_lesson.jpeg',),
                                      fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('English Spoken...',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                              ),Padding(
                                padding: const EdgeInsets.only(left: 8.0,),
                                child: Text('Noyon Talukder',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15),),
                              ),



                            ],
                          )
                      ),
                    );

                  },
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,shrinkWrap: true,)
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      Container(
                        height: 40,
                        width: 15,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      Text('    লাইব্রেরী ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Text('সব দেখুন',style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold,fontSize: 14),)

                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                  height: height/3.2,
                  width: width,
                  child: ListView.builder(itemBuilder: (_,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: width/2.2,
                          height: height/3.5,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),

                                  spreadRadius: 5,

                                  blurRadius: 7,

                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),]    ,
                              color: Colors.white,
                              borderRadius:BorderRadius.circular(10)
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: width/2,
                                  height: height/5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/video_lesson.jpeg',),
                                      fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('English Spoken...',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                              ),Padding(
                                padding: const EdgeInsets.only(left: 8.0,),
                                child: Text('Noyon Talukder',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15),),
                              ),



                            ],
                          )
                      ),
                    );

                  },
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,shrinkWrap: true,)
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      Container(
                        height: 40,
                        width: 15,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      Text('    ল্যাকচার এন্ড নোটস  ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Text('সব দেখুন',style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold,fontSize: 14),)

                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                  height: height/3.24,
                  width: width,
                  child: ListView.builder(itemBuilder: (_,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: width/2.2,
                          height: height/4,
                          decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.2),
                              //
                              //     spreadRadius: 5,
                              //
                              //     blurRadius: 7,
                              //
                              //     offset: Offset(
                              //         0, 3), // changes position of shadow
                              //   ),]    ,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/notes.jpeg',),
                                  fit: BoxFit.fitHeight
                              ),
                              borderRadius:BorderRadius.circular(10)
                          ),
                          // child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Container(
                          //         width: width/2,
                          //         height: height/5,
                          //         decoration: BoxDecoration(
                          //           image: DecorationImage(
                          //             image: AssetImage('assets/images/video_lesson.jpeg',),
                          //             fit: BoxFit.cover
                          //           ),
                          //           borderRadius: BorderRadius.circular(10)
                          //         ),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text('English Spoken...',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                          //     ),Padding(
                          //       padding: const EdgeInsets.only(left: 8.0,),
                          //       child: Text('Noyon Talukder',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15),),
                          //     ),
                          //
                          //
                          //
                          //   ],
                          // )
                      ),
                    );

                  },
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,shrinkWrap: true,)
              ),
            ),
            SizedBox(height: 20,),



          ],
        ),
      ),

    ));
  }
}

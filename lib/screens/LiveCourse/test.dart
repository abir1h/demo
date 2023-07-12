import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/LiveCourse/TabbarView/instructors.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../utils/colors.dart';


class test extends StatefulWidget {
  final String id;
  const test({Key? key, required this.id}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test>
    with TickerProviderStateMixin {
  List imageList = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg',
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg'
  ];
  late TabController _tabController;

  final _selectedColor = Color(0xff1a73e8);
  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [


  ];


  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }
  var selected_tab=0;

  //Tab Header
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  ScrollController? controller2;

  int counter = 0;
  ScrollController? controllersc = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(backgroundColor: Colors.white,
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
                color: Colors.white,
              ),
              height: size.height / 6.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "৳" + '15000',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.primaryOrange,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              " ৳" + '8000',
                              style: TextStyle(
                                  color: AppColors.primaryprice_text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Promo Code",
                          style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.height / 18,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryyeollo),
                      child: Center(
                        child: Text(
                          "Join Live batch",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(140.0), // here the desired height
              child: Column(
                children: [
                  AppBar(
                    automaticallyImplyLeading:
                    false, // Don't show the leading button

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
                    title: Text(
                      "Web Development with PHP & laravel",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                  ),
                  Container(
                      height: size.height / 11,
                      width: size.width,
                      decoration: BoxDecoration(color: AppColors.primarg),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: size.height / 12,
                                width: size.width / 1.8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Apply promo LARAVEL and get 2200 Taka Discount only for",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: AppColors.primarg,
                                      ),
                                      Text(
                                        " 8 Days",
                                        style: TextStyle(
                                            color: AppColors.primarg,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Apply Now',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Web Development with PHP & Laravel",
                          style: TextStyle(
                              color: AppColors.primaryprice_text,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'হাসিন হায়দার ও রাব্বিল হাসান- বাংলাদেশের বেস্ট ২ জন মেন্টর আছেন আপনার PHP Laravel সেক্টরে ক্যারিয়ার গড়তে, তাও আবার লাইভে।'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset('assets/images/mentor.jpeg'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 45.0),
                            child: Container(
                              height: size.height / 11,
                              width: size.width / 2.9,
                              decoration: BoxDecoration(
                                  color: AppColors.c1,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    Icons.access_time_outlined,
                                    color: AppColors.primaryOrange,
                                  ),
                                  Text(
                                    " 109 Days Remaining ",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 48.0),
                            child: Container(
                              height: size.height / 11,
                              width: size.width / 3,
                              decoration: BoxDecoration(
                                  color: AppColors.c2,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    Icons.person_add_outlined,
                                    color: AppColors.primaryGreen,
                                  ),
                                  Text(
                                    "94 Seats left",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(
                              "You're getting in this course",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('৬ মাসের স্টাডি প্ল্যান')
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('৫০টি লাইভ ক্লাস')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('২৪টি অ্যাসাইনমেন্ট')
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('ডেইলি প্রবলেম সলভিং ')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('কমিউনিটি সাপোর্ট')
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('জব/ ইন্টার্নশিপের সুযোগ')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.book,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/class.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Free Orientation Class"),
                                            Row(
                                              children: [
                                                Icon(Icons.date_range),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "15 Aug Tue,9:00 PM",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  height: size.height / 18,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: AppColors.blackpanther,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Book Your Seat",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height / 3.5,
                          width: size.width,
                          child: Row(
                            children: [
                              VerticalDivider(
                                color: AppColors.div,
                                width: 10,
                                thickness: 2,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.div,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Batch 4',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 1,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.2)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,color: AppColors.div,),
                                        Text('Starting Time: ',style: TextStyle(color: Colors.grey),),
                                        Text('Satureday,22 Jul',style: TextStyle(color: Colors.black),)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 1,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.2)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,color: AppColors.div,),
                                        Text('Class Days: ',style: TextStyle(color: Colors.grey),),
                                        Text('Sat,Thu',style: TextStyle(color: Colors.black),)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 1,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.2)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,color: AppColors.div,),
                                        Text('Class Time: ',style: TextStyle(color: Colors.grey),),
                                        Text('9:00 PM - 10.30 PM',style: TextStyle(color: Colors.black),)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height / 10,
                          width: size.width,
                          child: Row(
                            children: [
                              VerticalDivider(
                                color: AppColors.primaryGreen,
                                width: 10,
                                thickness: 2,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset('assets/images/play.png',height: 70,width: 70,),
                                            SizedBox(width: 10,),
                                            Text(
                                              'Free Demo Class',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),SizedBox(width: 10,),
                                        Expanded(
                                          child: Container(
                                            height: size.height / 18,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(.2),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.play_circle_outline_outlined,color: Colors.black,size: 20,),
                                                  Text(
                                                    "Watch Video",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/stat.jpeg'),
                      ),

                      /* Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
          child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandablePanel(
                    header: Text("Test"),
                    collapsed: Text('adfadfadfadfadfadfadf', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    expanded: Text('adfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadfadf', softWrap: true, ),


                  ),
          ),
      ),
        ),*/
                      StickyHeader(
                          controller: controller2, // Optional
                          header:Container(
                            decoration: BoxDecoration(color: Colors.white,

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    offset: const Offset(
                                      0.0,
                                      0.0,
                                    ),
                                    blurRadius: 7.0,
                                    spreadRadius: 1.0,
                                  ),]
                            ),
                            child: TabBar(

                              controller: _tabController,
                              onTap: (value) => {
                                setState((){
                                  selected_tab=value;
                                })

                              },
                              tabs: [
                                Tab(child: Row(
                                  children: [
                                    Image.asset("assets/images/list.png",height: 15,width: 15,color:selected_tab==0?Colors.black:Colors.grey,),
                                    SizedBox(width: 10,),
                                    Text("Study plan",style: TextStyle(fontSize: 12),)
                                  ],
                                ),),
                                Tab(child: Row(
                                  children: [
                                    Image.asset("assets/images/user.png",height: 15,width: 15,),
                                    SizedBox(width: 10,),
                                    Text("Instructor",style: TextStyle(fontSize: 12),)
                                  ],
                                ),),
                                Tab(child: Row(
                                  children: [
                                    Image.asset("assets/images/document.png",height: 20,width: 20,),
                                    SizedBox(width: 10,),
                                    Text("About This Course",style: TextStyle(fontSize: 12),)
                                  ],
                                ),),
                                Tab(child: Row(
                                  children: [
                                    Image.asset("assets/images/telephone.png",height: 15,width: 15,),
                                    SizedBox(width: 10,),
                                    Text("Help Line",style: TextStyle(fontSize: 12),)
                                  ],
                                ),),
                              ],
                              labelColor: Colors.black,
                              indicatorColor: AppColors.primaryOrange,

                              isScrollable: true,

                            ),
                          ),
                          content:  Container(
                            height: size.height*2,
                            child: TabBarView(
                              controller: _tabController,

                              children: [

                              ],
                            ),
                          )
                      ),
                      SizedBox(height: size.height/5,)
                    ],
                  ),

                ],
              ),
            )));
  }
}

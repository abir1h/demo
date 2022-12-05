import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/image_pop.dart';

class All_photos extends StatefulWidget {
  const All_photos({Key? key}) : super(key: key);

  @override
  State<All_photos> createState() => _All_photosState();
}

class _All_photosState extends State<All_photos>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.orange,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              radius: 5,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "All Photos & Videos",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.grey,
                      labelColor: AppColors.orange,
                      controller: _tabController,
                      tabs: const [
                        Text(
                          'Ambiance',
                          style: TextStyle(),
                        ),
                        Text('Food'),
                        Text('Drinks'),
                        Text('Msoments'),
                      ]),
                ),
              ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: TabBarView(controller: _tabController, children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height / 5,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage('assets/images/f2.png'),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          },
                          itemCount: 10,
                          shrinkWrap: true,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height / 5,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage('assets/images/f2.png'),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          },
                          itemCount: 10,
                          shrinkWrap: true,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height / 5,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage('assets/images/f2.png'),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          },
                          itemCount: 10,
                          shrinkWrap: true,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height / 5,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage('assets/images/f2.png'),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          },
                          itemCount: 10,
                          shrinkWrap: true,
                        ),
                      )
                    ],
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
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
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: widget.height / 7,
                    width: widget.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      color: AppColors.offers,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Flat",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: widget.width / 6,
                                    ),
                                    const Text(
                                      "5%",
                                      style: TextStyle(
                                          color: AppColors.orange,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "off",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Offer Available : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "From ",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "01/02/2022",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "To ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "01/02/2022",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Details :",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nunc nec ultricies dictum blandit nisi netus posuere in. Tortor nibh dignissim in ipsum, scelerisque. Ut est pellentesque tortor ut amet. Dictum nibh ornare hac nisl volutpat id sit feugiat.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Terms & Conditions : lorem ipsum dolor tiamat amor ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: AppColors.orange,
                        ),
                        Text(
                          "Previous Offer",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          "View Next Offer",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
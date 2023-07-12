import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import 'Complete_Quiz.dart';
import 'ModuleController.dart';

class QuizDetails extends StatefulWidget {
  const QuizDetails({Key? key}) : super(key: key);

  @override
  State<QuizDetails> createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  final controller = Get.put(ModuleController());
  List select = [];
  List<bool> selected = <bool>[];
  getindex(int itemCount) {
    for (var i = 0; i < itemCount; i++) {
      selected.add(false);
    }
  }

  Future? ExamDetails;
  Future allExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(AppUrl.QuizDetails + controller.examid.value),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['resultList'];

      setState(() {
        right_ans = jsonDecode(response.body)['rightAnswer'];
        wrong_ans = jsonDecode(response.body)['wrongAnswer'];
        positive_ans = jsonDecode(response.body)['positiveMarks'];
        Negative_ans = jsonDecode(response.body)['negativeMarks'];
        Total_marks = jsonDecode(response.body)['totalMarks'].toString();
      });
      print(jsonDecode(response.body));
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  List user_answered = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ExamDetails = allExperience();
  }

  bool submitted = false;
  var right_ans;
  var wrong_ans;
  var Total_marks;
  var positive_ans;
  var Negative_ans;

  submit() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'authorization': "Bearer $token"
      };
      var request = await http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.submit),
      );

      request.fields.addAll({
        "exam": json.encode(answer),
      });

      request.headers.addAll(requestHeaders);
      request.send().then((result) async {
        http.Response.fromStream(result).then((response) {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == 200) {
              setState(() {
                submitted = false;
              });
              Get.to(() => const CompleteQuiz());
              print(response.body);
            } else {
              setState(() {
                submitted = false;
              });
              print(response.body);
            }
          } else {
            setState(() {
              submitted = false;
            });

            print(response.body);
            return response.body;
          }
        });
      });
    } catch (r) {
      print(r);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<Map<String, dynamic>> answer = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.gbg,
      appBar: AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button

          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
              print(json.encode(answer));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Quiz Details",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
          )),
      body: FutureBuilder(
        future: ExamDetails,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: size.height / 3,
                ),
                const SpinKitCircle(
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
                const Center(
                  child: Text(
                    " Please wait while Loading..",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        minimum:-200,
                        radiusFactor: .7,
                        maximum: Total_marks=='0'?0.0:double.parse(Total_marks),
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                              enableAnimation: true,
                              value: double.parse(right_ans.toString()),
                              width: 0.2,
                              sizeUnit: GaugeSizeUnit.factor,
                              cornerStyle: CornerStyle.startCurve,
                              gradient: const SweepGradient(colors: <Color>[
                                Color(0xFF00a9b5),
                                Color(0xFF87e8e8),
                              ], stops: <double>[
                                0.25,
                                0.75
                              ])),
                          MarkerPointer(
                            enableAnimation: true,
                            animationDuration: 1000.0,
                            value: double.parse(right_ans.toString()),
                            markerType: MarkerType.circle,
                            markerWidth: 30,
                            elevation: 2.0,
                            markerHeight: 30,
                            color: const Color(0xFF87e8e8),
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(Total_marks.toString(),
                                      style: const TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold)),
                                  const Text('Total Marks',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal)),
                                ],
                              )),
                              angle: 90,
                              positionFactor: 0.0)
                        ])
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Positive Marks  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      positive_ans.toString() + " Marks",
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Negative Marks  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Negative_ans.toString() + " Marks",
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Scored Marks  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      right_ans.toString() + " Marks",
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            (index + 1).toString() +
                                                ". " +
                                                snapshot.data[index]
                                                    ['question_name'],
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: snapshot.data[index]
                                                          ['user_answer'] ==
                                                      snapshot.data[index]
                                                          ['option_1']
                                                  ? AppColors.ansbg
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: snapshot.data[index]
                                                              ['user_answer'] ==
                                                          snapshot.data[index]
                                                              ['option_1']
                                                      ? AppColors.ansbrder
                                                      : Colors.grey
                                                          .withOpacity(.2))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: snapshot
                                                                          .data[
                                                                      index][
                                                                  'user_answer'] ==
                                                              snapshot.data[
                                                                      index]
                                                                  ['option_1']
                                                          ? Colors.black
                                                          : AppColors.greybg,
                                                      radius: 18,
                                                      child: Center(
                                                        child: Text(
                                                          'A',
                                                          style: TextStyle(
                                                              color: snapshot.data[
                                                                              index]
                                                                          [
                                                                          'user_answer'] ==
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'option_1']
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          ['option_1'],
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: snapshot.data[index]
                                                          ['user_answer'] ==
                                                      snapshot.data[index]
                                                          ['option_2']
                                                  ? AppColors.ansbg
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: snapshot.data[index]
                                                              ['user_answer'] ==
                                                          snapshot.data[index]
                                                              ['option_2']
                                                      ? AppColors.ansbrder
                                                      : Colors.grey
                                                          .withOpacity(.2))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: snapshot
                                                                          .data[
                                                                      index][
                                                                  'user_answer'] ==
                                                              snapshot.data[
                                                                      index]
                                                                  ['option_2']
                                                          ? Colors.black
                                                          : AppColors.greybg,
                                                      radius: 18,
                                                      child: Center(
                                                        child: Text(
                                                          'B',
                                                          style: TextStyle(
                                                              color: snapshot.data[
                                                                              index]
                                                                          [
                                                                          'user_answer'] ==
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'option_2']
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          ['option_2'],
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: snapshot.data[index]
                                                          ['user_answer'] ==
                                                      snapshot.data[index]
                                                          ['option_3']
                                                  ? AppColors.ansbg
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: snapshot.data[index]
                                                              ['user_answer'] ==
                                                          snapshot.data[index]
                                                              ['option_3']
                                                      ? AppColors.ansbrder
                                                      : Colors.grey
                                                          .withOpacity(.2))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: snapshot
                                                                          .data[
                                                                      index][
                                                                  'user_answer'] ==
                                                              snapshot.data[
                                                                      index]
                                                                  ['option_3']
                                                          ? Colors.black
                                                          : AppColors.greybg,
                                                      radius: 18,
                                                      child: Center(
                                                        child: Text(
                                                          'C',
                                                          style: TextStyle(
                                                              color: snapshot.data[
                                                                              index]
                                                                          [
                                                                          'user_answer'] ==
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'option_3']
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          ['option_3'],
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: snapshot.data[index]
                                                          ['user_answer'] ==
                                                      snapshot.data[index]
                                                          ['option_4']
                                                  ? AppColors.ansbg
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: snapshot.data[index]
                                                              ['user_answer'] ==
                                                          snapshot.data[index]
                                                              ['option_4']
                                                      ? AppColors.ansbrder
                                                      : Colors.grey
                                                          .withOpacity(.2))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: snapshot
                                                                          .data[
                                                                      index][
                                                                  'user_answer'] ==
                                                              snapshot.data[
                                                                      index]
                                                                  ['option_4']
                                                          ? Colors.black
                                                          : AppColors.greybg,
                                                      radius: 18,
                                                      child: Center(
                                                        child: Text(
                                                          'D',
                                                          style: TextStyle(
                                                              color: snapshot.data[
                                                                              index]
                                                                          [
                                                                          'user_answer'] ==
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'option_4']
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          ['option_4'],
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('Answer :  ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16),),
                                          Text(snapshot.data[index]['answer'],style: TextStyle(color: Colors.black87,fontWeight: FontWeight.normal,fontSize: 16),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text("No Data Found"),
                ),
                // Center(child: TextButton(
                //   // onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectNewAddress())),
                //   child: Text("Try anotother location"),
                // ),)
              ],
            );
          }
        },
      ),
    ));
  }
}

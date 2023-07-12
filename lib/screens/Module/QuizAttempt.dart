import 'dart:async';
import 'dart:convert';

import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import 'Complete_Quiz.dart';
import 'ModuleController.dart';

class QuizAttempt extends StatefulWidget {
  final String time;
  const QuizAttempt({Key? key, required this.time}) : super(key: key);

  @override
  State<QuizAttempt> createState() => _QuizAttemptState();
}

class _QuizAttemptState extends State<QuizAttempt> {
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
        Uri.parse(AppUrl.examDetails + controller.examid.value),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['questionList'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  List user_answered = [];
  showbottom() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,isDismissible: false,

        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   /* Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(.3),
                              radius: 15,
                              child: Icon(
                                Icons.close,
                                color: Colors.black87,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),*/
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Exam Instruction",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          _controller.start();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Agree',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ExamDetails = allExperience();
    Timer(Duration(milliseconds: 100), () {
      showbottom();
    });
  }

  bool submitted = false;

  submit() async {

    try {
      if(answer.isNotEmpty){
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
          "exam":json.encode(answer),
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
                Get.to(()=>CompleteQuiz());
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
      }else{
        List<Map<String,dynamic>> answer2 = [];
        answer2.add({
          "module_exam_id":controller.examid.value,
          "question_answers_id": '0',
          "user_answer": '-',


        });
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
          "exam":json.encode(answer2),
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
                Get.to(()=>CompleteQuiz());
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

      }
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
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {submit(); },
    );Widget no = TextButton(
      child: Text("No"),
      onPressed: () {Get.back();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure"),
      content: Text("If you go back your answer will be submitted"),
      actions: [
        no,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  List<Map<String,dynamic>> answer = [];
  final _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    return WillPopScope(
      onWillPop: ()async{
        showAlertDialog(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppColors.gbg,
      /*  floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton:    Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 150,
            width: 150,
            child: CountDownProgressIndicator(
              controller: _controller,
              valueColor: Colors.transparent
              ,
              autostart: false,
              labelTextStyle: TextStyle(fontSize: 10),
              strokeWidth: 10,
              backgroundColor: Colors.transparent,
              initialPosition: 0,
              duration: int.parse(widget.time),
              timeFormatter: (seconds) {
                return Duration(seconds: seconds)
                    .toString()
                    .split('.')[0]
                    .padLeft(8, '0');
              },
              text: '',
              onComplete: () {

                //submitted = true;
                submit();

              },
            ),
          ),
        ),*/
        appBar:AppBar(

            automaticallyImplyLeading: false,
            toolbarHeight: 90,// Don't show the leading button

            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    SizedBox(
                      height: 100,
                      width: 130,

                      child:      CountDownProgressIndicator(
                        controller: _controller,
                        valueColor: Colors.transparent
                        ,
                        autostart: false,
                        labelTextStyle: TextStyle(fontSize: 10),
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        initialPosition: 0,
                        duration: int.parse(widget.time),
                        timeFormatter: (seconds) {
                          return Duration(seconds: seconds)
                              .toString()
                              .split('.')[0]
                              .padLeft(8, '0');
                        },
                        text: '',
                        onComplete: () {

                          //submitted = true;
                          submit();

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            title: Text(
              "Quiz",
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
                  SpinKitCircle(
                    color: AppColors.primaryGreen,
                    size: 30,
                  ),
                  Center(
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
                    SizedBox(
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
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (index+1).toString() +
                                                  ". " +
                                                  snapshot.data[index]
                                                      ['question_name'],
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            user_answered.contains( snapshot.data[index]['id'].toString())?null:  setState(() {




                                                  snapshot.data[index]['user_answer']=snapshot.data[index]['option_1'];

                                                  user_answered.add(  snapshot.data[index]['id'].toString());
                                                  answer.add({
                                                    "module_exam_id":controller.examid.value,
                                                    "question_answers_id": snapshot.data[index]['id'].toString(),
                                                    "user_answer": snapshot.data[index]['option_1'],


                                                  });
                                                });
                                          },
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
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data[index]
                                                            ['option_1'],
                                                        style: TextStyle(
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
                                          onTap: () {
                                            user_answered.contains(snapshot
                                                    .data[index]['id']
                                                    .toString())
                                                ? null
                                                : setState(() {
                                                    snapshot.data[index]
                                                            ['user_answer'] =
                                                        snapshot.data[index]
                                                            ['option_2'];

                                                    user_answered.add(snapshot
                                                        .data[index]['id']
                                                        .toString());
                                                    answer.add({
                                                      "module_exam_id":
                                                          controller.examid.value,
                                                      "question_answers_id": snapshot.data[index]['id'].toString(),

                                                      "user_answer":
                                                          snapshot.data[index]
                                                              ['option_2'],
                                                    });
                                                  });
                                          },
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
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data[index]
                                                            ['option_2'],
                                                        style: TextStyle(
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
                                          onTap: () {
                                            user_answered.contains(snapshot
                                                    .data[index]['id']
                                                    .toString())
                                                ? null
                                                : setState(() {
                                                    snapshot.data[index]
                                                            ['user_answer'] =
                                                        snapshot.data[index]
                                                            ['option_3'];

                                                    user_answered.add(snapshot
                                                        .data[index]['id']
                                                        .toString());
                                                    answer.add({
                                                      "module_exam_id":
                                                          controller.examid.value,
                                                      "question_answers_id": snapshot.data[index]['id'].toString(),

                                                      "user_answer":
                                                          snapshot.data[index]
                                                              ['option_3'],
                                                    });
                                                  });
                                          },
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
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data[index]
                                                            ['option_3'],
                                                        style: TextStyle(
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
                                          onTap: () {
                                            user_answered.contains(snapshot
                                                    .data[index]['id']
                                                    .toString())
                                                ? null
                                                : setState(() {
                                                    snapshot.data[index]
                                                            ['user_answer'] =
                                                        snapshot.data[index]
                                                            ['option_4'];

                                                    user_answered.add(snapshot
                                                        .data[index]['id']
                                                        .toString());
                                                    answer.add({
                                                      "module_exam_id":
                                                          controller.examid.value,
                                                      "question_answers_id": snapshot.data[index]['id'].toString(),

                                                      "user_answer":
                                                          snapshot.data[index]
                                                              ['option_4'],
                                                    });
                                                  });
                                          },
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
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data[index]
                                                            ['option_4'],
                                                        style: TextStyle(
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
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                    submitted == false
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            submitted = true;
                            submit();
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.green,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,fontSize: 16,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : SpinKitCircle(
                      color: AppColors.green,
                      size: 35,
                    )

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
      )),
    );
  }
}

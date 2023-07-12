// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

HomePageModel homePageModelFromJson(String str) => HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  String? message;
  List<LiveLessaon>? liveLessaon;
  List<dynamic>? videoLesson;
  bool? success;
  int? status;

  HomePageModel({
     this.message,
     this.liveLessaon,
     this.videoLesson,
     this.success,
     this.status,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
    message: json["message"],
    liveLessaon: List<LiveLessaon>.from(json["liveLessaon"].map((x) => LiveLessaon.fromJson(x))),
    videoLesson: List<dynamic>.from(json["videoLesson"].map((x) => x)),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "liveLessaon": List<dynamic>.from(liveLessaon!.map((x) => x.toJson())),
    "videoLesson": List<dynamic>.from(videoLesson!.map((x) => x)),
    "success": success,
    "status": status,
  };
}

class LiveLessaon {
  int id;
  String courseName;
  String courseImage;
  String courseBatchName;
  String totalSeat;
  DateTime startDate;
  String coursePrice;

  LiveLessaon({
    required this.id,
    required this.courseName,
    required this.courseImage,
    required this.courseBatchName,
    required this.totalSeat,
    required this.startDate,
    required this.coursePrice,
  });

  factory LiveLessaon.fromJson(Map<String, dynamic> json) => LiveLessaon(
    id: json["id"],
    courseName: json["course_name"],
    courseImage: json["course_image"],
    courseBatchName: json["course_batch_name"],
    totalSeat: json["total_seat"],
    startDate: DateTime.parse(json["start_date"]),
    coursePrice: json["course_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_name": courseName,
    "course_image": courseImage,
    "course_batch_name": courseBatchName,
    "total_seat": totalSeat,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "course_price": coursePrice,
  };
}

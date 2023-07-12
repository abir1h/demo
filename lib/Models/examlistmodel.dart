// To parse this JSON data, do
//
//     final examListModel = examListModelFromJson(jsonString);

import 'dart:convert';

ExamListModel examListModelFromJson(String str) => ExamListModel.fromJson(json.decode(str));

String examListModelToJson(ExamListModel data) => json.encode(data.toJson());

class ExamListModel {
  final String message;
  final List<ExamList> examList;
  final bool success;
  final int status;

  ExamListModel({
    required this.message,
    required this.examList,
    required this.success,
    required this.status,
  });

  factory ExamListModel.fromJson(Map<String, dynamic> json) => ExamListModel(
    message: json["message"],
    examList: List<ExamList>.from(json["examList"].map((x) => ExamList.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "examList": List<dynamic>.from(examList.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class ExamList {
  final int id;
  final String name;
  final String description;
  final String status;

  ExamList({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  factory ExamList.fromJson(Map<String, dynamic> json) => ExamList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "status": status,
  };
}

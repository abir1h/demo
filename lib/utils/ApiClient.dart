import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:get/get.dart' as getx;
import 'package:learning_school_bd/utils/Appurl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer show log;

const String baseUrl = AppUrl.baseURL;

class ApiClient {
  static final Dio dio = Dio();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.receiveDataWhenStatusError = true;
    dio.options.headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
      if (prefs.getString("token") != null) "token": "${prefs.getString("token")}",
    };

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        error: true,
        responseBody: true,
        queryParameters: true,
        logPrint: (v) => developer.log(v),
      ),
    );
  }

  Future get({required String url, Map<String, dynamic>? params}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await dio.get(
        url,
        queryParameters: params,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
            "token": "${prefs.getString("token")}"
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      // errorMessage(getx.Get.context!);
      return null;
    }
  }
  Future post2({required String url, Object? body}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
            "token": "${prefs.getString("token")}"
          },
        ),
      );

      if (response.data['success']) {
        // successMessage(getx.Get.context!);
      } else {
        // errorMessage(getx.Get.context!);
      }
      return response.data;
    } catch (e) {

    }
  }
  Future post({required String url, Object? body}) async {

    try {
      final response = await dio.post(url, data: body);

      if (response.data['success']) {
        // successMessage(getx.Get.context!);
      } else {
        // errorMessage(getx.Get.context!);
      }
      return response.data;
    } catch (e) {
    }
  }

  Future patch({required String url, Map<String, dynamic>? body}) async {

    try {
      final response = await dio.patch(url, data: body);
      return response.data;
    } on DioError catch (e) {
      // errorMessage(getx.Get.context!);
      developer.log(e.response?.data.toString() ?? 'response is null');
      developer.log(e.response?.statusCode.toString() ?? 'statusCode is null');
      developer.log(e.toString());
      developer.log(e.message.toString());
      developer.log(e.requestOptions.uri.path.toString());
      return null;
    }
  }

  Future put({required String url, Map<String, dynamic>? body}) async {

    try {
      final response = await dio.put(url, data: body);
      return response.data;
    } on DioError catch (e) {
      // errorMessage(getx.Get.context!);
      return null;
    }
  }

  Future delete({required String url, Map<String, dynamic>? body}) async {

    try {
      final response = await dio.delete(url, data: body);
      return response.data;
    } on DioError catch (e) {
      return null;
    }
  }

  Future requestWithFile({
    required String url,
    Map<String, dynamic>? body,
    required List<MapEntry<String, File>> files,
  }) async {
    try {

      FormData formData = FormData.fromMap(body ?? {});
      for (var fileEntry in files) {
        formData.files.add(
          MapEntry(
            fileEntry.key,
            MultipartFile.fromFileSync(fileEntry.value.path, filename: fileEntry.value.path.split("/").last),
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 1));

      final response = await dio.post(url, data: formData);
      return response.data;
    } on DioError catch (e) {

      return null;
    }
  }
}

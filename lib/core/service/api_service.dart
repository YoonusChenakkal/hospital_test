import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hospital_app/core/constants/app_constans.dart';
import 'package:hospital_app/core/constants/app_storage_const.dart';
import 'package:hospital_app/core/service/local_storage.dart';

enum Method { get, post, patch, delete }

class ApiDio {
  static final Dio dio = Dio();

  // Get headers dynamically from SharedPreferences
  static Future<Map<String, String>> _getHeaders() async {
    final token = LocalStorage.read(AppStorageConst.accesstoken) ?? '';
    log("Access Token: $token");

    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>>? call({
    required String endPoint,
    required Method method,
    Map<String, dynamic>? queryParameters,
    Object? body,
    int expectedStatusCode = 200,
    Map<String, String>? headers,
    bool isAuthFunction = false,
  }) async {
    try {
      final url = '${AppConstants.apiBaseUrl}$endPoint';
      final mergedHeaders = headers ?? await _getHeaders();

      log("$url (${method.name.toUpperCase()})\n$body");

      final response = await dio.request(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          method: method.name.toUpperCase(),
          headers: mergedHeaders,
        ),
      );

      log("Response: ${response.data}");
      log("Status Code: ${response.statusCode}");

      if (response.statusCode == expectedStatusCode) {
        return {"error": false, "data": response.data};
      } else {
        return {
          "error": true,
          "msg": "Unexpected status code: ${response.statusCode}",
        };
      }
    } on SocketException {
      return {"error": true, "msg": "No Internet Connection"};
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("DioException Response: ${e.response?.data}");
      log("DioException Status Code: ${e.response?.statusCode}");
      String errorMsg = "Something went wrong";
      if (e.response?.data is Map &&
          (e.response?.data as Map).containsKey('message')) {
        errorMsg = e.response?.data['message'];
      }
      // if (e.response?.statusCode == 401 && !isAuthFunction) {
      //   Get.offAll(() => SessionExpiredScreen());
      // }
      return {"error": true, "msg": errorMsg};
    } catch (e) {
      return {"error": true, "msg": "Unexpected error: $e"};
    }
  }
}

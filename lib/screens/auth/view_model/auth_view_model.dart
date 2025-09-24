import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/core/constants/app_storage_const.dart';
import 'package:hospital_app/core/helper/helper_routes.dart';
import 'package:hospital_app/core/service/api_service.dart';
import 'package:hospital_app/core/service/local_storage.dart';
import 'package:hospital_app/screens/patients/view/patients_screen.dart';
import 'package:hospital_app/screens/widgets/custom_snackbar.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// User login function
  Future<void> login({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;

    try {
      final response = await ApiDio.call(
        endPoint: 'Login',
        method: Method.post,
        body: FormData.fromMap({'username': username, 'password': password}),
        expectedStatusCode: 200,
        isAuthFunction: true,
      );

      if (response != null &&
          response['error'] != true &&
          response['data']['token'] != null) {
        // Save to LocalStorage
        final accessToken = response['data']['token'];
        final userId = response['data']['user_details']['id'];

        await LocalStorage.write(
          key: AppStorageConst.userid,
          value: userId.toString(),
        );
        await LocalStorage.write(
          key: AppStorageConst.accesstoken,
          value: accessToken,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigate(
            context: context,
            screen: PatientsScreen(),
            type: NavigationType.pushReplacement,
          );
        });
      } else {
        customSnackBar(message: 'Sign In failed', context: context);
      }
    } catch (e) {
      customSnackBar(message: 'An error occurred: $e', context: context);
    } finally {
      isLoading = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hospital_app/core/service/api_service.dart';
import 'package:hospital_app/screens/patients/model/patients_model.dart';
import 'package:hospital_app/screens/widgets/custom_snackbar.dart';

class PatientsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<Patient> patients = [];

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch the patients list from the API
  Future<void> fetchPatients(context) async {
    isLoading = true;

    try {
      final response = await ApiDio.call(
        endPoint: 'PatientList',
        method: Method.get,
        expectedStatusCode: 200,
      );

      if (response != null && response['error'] != true) {
        patients = (response['data']['patient'] as List)
            .map((item) => Patient.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        customSnackBar(
          message: 'Failed to get patients list',
          context: context,
        );
        clearPatients();
      }
    } catch (e) {
      clearPatients();
      customSnackBar(message: 'An error occurred: $e', context: context);
      print(e);
    } finally {
      isLoading = false;
    }
  }

  /// Optional: Clear current data
  void clearPatients() {
    patients = [];
    notifyListeners();
  }
}

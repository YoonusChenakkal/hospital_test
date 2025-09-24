import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/core/helper/helper_routes.dart';
import 'package:hospital_app/core/service/api_service.dart';
import 'package:hospital_app/screens/register/model/branches_model.dart';
import 'package:hospital_app/screens/register/model/treatment_model.dart';
import 'package:hospital_app/screens/register/view/pdf_screen.dart';
import 'package:hospital_app/screens/widgets/custom_snackbar.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoadingBranches = false;
  bool _isLoadingTreatments = false;
  bool _isLoadingRegister = false;

  bool get isLoadingBranches => _isLoadingBranches;
  bool get isLoadingTreatments => _isLoadingTreatments;
  bool get isLoadingRegister => _isLoadingRegister;

  List<Map<String, dynamic>> treatmentDetails = [];

  // Dropdown data
  List<BranchesModel> branches = [];
  List<Treatment> treatments = [];

  // list of locations
  List<Map<String, String>> locations = [
    {'id': '1', 'name': 'Calicut'},
    {'id': '2', 'name': 'Kochi'},
    {'id': '3', 'name': 'Thrissur'},
    {'id': '4', 'name': 'Kozhikode'},
    {'id': '5', 'name': 'Trivandrum'},
  ];

  // Hours (01–12)
  List<Map<String, String>> timeHours = List.generate(
    12,
    (index) => {
      'id': (index + 1).toString().padLeft(2, '0'),
      'name': (index + 1).toString().padLeft(2, '0'),
    },
  );

  // Minutes (00–59)
  List<Map<String, String>> timeMinutes = List.generate(
    60,
    (index) => {
      'id': index.toString().padLeft(2, '0'),
      'name': index.toString().padLeft(2, '0'),
    },
  );

  // Selected values
  String? selectedBranch;
  String? selectedTreatment;

  // Fetch branches from API
  Future<void> fetchBranches() async {
    _isLoadingBranches = true;
    notifyListeners();

    try {
      final response = await ApiDio.call(
        endPoint: 'BranchList',
        method: Method.get,
        expectedStatusCode: 200,
      );

      if (response != null && response['error'] != true) {
        BranchResponse branchResponse = BranchResponse.fromJson(
          response['data'],
        );
        branches = branchResponse.branches;
      }
    } catch (e) {
      debugPrint('Error fetching branches: $e');
    } finally {
      _isLoadingBranches = false;
      notifyListeners();
    }
  }

  // Fetch treatments from API
  Future<void> fetchTreatments() async {
    _isLoadingTreatments = true;
    notifyListeners();

    try {
      final response = await ApiDio.call(
        endPoint: 'TreatmentList',
        method: Method.get,
        expectedStatusCode: 200,
      );
      final dataMap = response?['data'] as Map<String, dynamic>?;
      final dataList =
          dataMap?['treatments'] as List<dynamic>?; // get treatments list

      if (dataList != null) {
        treatments = dataList
            .map((e) => Treatment.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        treatments = []; // empty list if data is null
      }
    } catch (e) {
      debugPrint('Error fetching treatments: $e');
    } finally {
      _isLoadingTreatments = false;
      notifyListeners();
    }
  }

  /// User login function
  Future<void> registerPatient({required BuildContext context, data}) async {
    _isLoadingRegister = true;
    notifyListeners();

    try {
      final response = await ApiDio.call(
        endPoint: 'PatientUpdate',
        method: Method.post,
        body: FormData.fromMap(data),
        expectedStatusCode: 200,
        isAuthFunction: true,
      );

      if (response != null && response['error'] != true) {
        Navigator.pop(context);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigate(
            context: context,
            screen: PatientInvoicePdfScreen(
              patientName: data['name'].toString(),
              patientDetailsSet: treatmentDetails,
              advanceAmount: data['advance_amount'].toStringAsFixed(0),
              balanceAmount: data['balance_amount'].toStringAsFixed(0),
              dateNdTime: data['date_nd_time'].toString(),
              discountAmount: data['discount_amount'].toStringAsFixed(0),
              patientAddress: data['address'].toString(),
              patientPhone: data['phone'].toString(),
              totalAmount: data['total_amount'].toStringAsFixed(0),
            ),
            type: NavigationType.push,
          );
        });
        customSnackBar(message: 'Registered Successfully', context: context);
      } else {
        customSnackBar(message: 'Registration failed', context: context);
      }
    } catch (e) {
      customSnackBar(message: 'An error occurred: $e', context: context);
    } finally {
      _isLoadingRegister = false;
      notifyListeners();
    }
  }

  void setSelectedBranch(String? value) {
    selectedBranch = value;
    print(selectedBranch);
    notifyListeners();
  }

  void setSelectedTreatment(String? value) {
    selectedTreatment = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hospital_app/core/constants/app_colors.dart';
import 'package:hospital_app/core/constants/app_styles.dart';
import 'package:hospital_app/core/extension/space_ext.dart';
import 'package:hospital_app/core/helper/helper_routes.dart';
import 'package:hospital_app/screens/register/view/pdf_screen.dart';
import 'package:intl/intl.dart';
import 'package:hospital_app/screens/patients/view/widget/patient_card.dart';
import 'package:hospital_app/screens/patients/view_model/patients_view_model.dart';
import 'package:hospital_app/screens/register/view/register_screen.dart';
import 'package:hospital_app/screens/widgets/custom_appbar.dart';
import 'package:hospital_app/screens/widgets/custom_button.dart';
import 'package:hospital_app/screens/widgets/custom_searchbar.dart';
import 'package:provider/provider.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  void initState() {
    super.initState();
    final patientVm = Provider.of<PatientsViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patientVm.fetchPatients(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientVm = Provider.of<PatientsViewModel>(context);
    return Scaffold(
      appBar: CustomAppBar(backButton: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.h.hBox,
          // Custom hint and button text
          CustomSearchBar(
            hintText: 'Search for treatments',
            buttonText: 'Search',
            onSearch: () {},
          ),
          20.h.hBox,
          _buildSortBySection(),
          10.h.hBox,
          thinDivider(),
          _buildPatientList(patientVm),
          registerbutton(context),
        ],
      ),
    );
  }

  Widget _buildSortBySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sort by :',
            style: AppStyles.bodyText1.copyWith(
              color: AppColors.darkText,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: 160.w,
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: 'Date',
                items: ['Date', 'Name', 'Status']
                    .map(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppStyles.bodyText1),
                      ),
                    )
                    .toList(),
                onChanged: (_) {},
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.primaryGreen,
                ),
                style: AppStyles.bodyText1.copyWith(
                  color: AppColors.darkText,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList(PatientsViewModel patientVm) {
    return Expanded(
      child: patientVm.isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : patientVm.patients.isEmpty
          ? Center(child: Text('No patients found', style: AppStyles.bodyText1))
          : RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: () => patientVm.fetchPatients(context),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
                itemCount: patientVm.patients.length,
                itemBuilder: (context, index) {
                  final patient = patientVm.patients[index];
                  return PatientCard(
                    indexNum: index + 1,
                    name: patient.name ?? '',
                    treatment:
                        patient.patientDetailsSet
                            ?.map((e) => e.treatmentName)
                            .whereType<String>()
                            .join(', ') ??
                        'No treatment found',
                    date: formatDate(patient.dateNdTime),
                    person: patient.user.toString().isEmpty
                        ? 'No person found'
                        : patient.user ?? '',
                    onTap: () {},
                  );
                },
              ),
            ),
    );
  }

  // bottom  button
  registerbutton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 16.w, right: 16.w),
      child: CustomButton(
        text: 'Register Now',
        onPressed: () {
          navigate(context: context, screen: RegisterScreen());
        },
      ),
    );
  }

  Widget thinDivider({Color color = const Color(0xFFE0E0E0)}) {
    return Container(
      height: 1, // thin line
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // shadow color
            offset: const Offset(0, 1), // horizontal, vertical
            blurRadius: 2, // spread
          ),
        ],
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';

    try {
      DateTime dateTime = DateTime.parse(dateStr);
      // Format: dd-MM-yyyy
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      // In case parsing fails
      return 'no date found';
    }
  }
}

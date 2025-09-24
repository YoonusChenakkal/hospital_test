import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hospital_app/core/constants/app_colors.dart';
import 'package:hospital_app/core/constants/app_styles.dart';
import 'package:hospital_app/core/constants/app_validator.dart';
import 'package:hospital_app/core/extension/space_ext.dart';
import 'package:hospital_app/screens/register/view_model/register_view_model.dart';
import 'package:hospital_app/screens/widgets/custom_appbar.dart';
import 'package:hospital_app/screens/widgets/custom_button.dart';
import 'package:hospital_app/screens/widgets/custom_snackbar.dart';
import 'package:hospital_app/screens/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final whatsappController = TextEditingController();
  final addressController = TextEditingController();
  final totalAmountController = TextEditingController();
  final discountAmountController = TextEditingController();
  final advanceAmountController = TextEditingController();
  final balanceAmountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? selectedLocation;
  String? selectedHour;
  String? selectedMinute;
  String? selectedPaymentOption = "Cash";

  List<Map<String, dynamic>> selectedTreatments = [];

  @override
  void initState() {
    super.initState();
    final vm = context.read<RegisterViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchBranches();
      vm.fetchTreatments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text('Register', style: AppStyles.heading1),
                ),
              ),
              15.h.hBox,
              thinDivider(),
              20.h.hBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFieldLabel('Name'),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Enter your full name',
                      validator: AppValidator.validateName,
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Whatsapp Number'),
                    CustomTextField(
                      controller: whatsappController,
                      hintText: 'Enter your Whatsapp number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: AppValidator.validateMobile,
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Address'),
                    CustomTextField(
                      controller: addressController,
                      hintText: 'Enter your full address',
                      keyboardType: TextInputType.streetAddress,
                      validator: AppValidator.requiredField,
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Location'),
                    _buildDropdownField(
                      hintText: 'Select Location',
                      items: vm.locations
                          .map(
                            (loc) => DropdownMenuItem(
                              value: loc['id'],
                              child: Text(loc['name']!),
                            ),
                          )
                          .toList(),
                      value: selectedLocation,
                      onChanged: (val) {
                        setState(() {
                          selectedLocation = val;
                        });
                      },
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Branch'),
                    vm.isLoadingBranches
                        ? CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          )
                        : _buildDropdownField(
                            hintText: 'Select Branch',
                            items: vm.branches
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text(e.name.toString()),
                                  ),
                                )
                                .toList(),
                            value: vm.selectedBranch,
                            onChanged: vm.setSelectedBranch,
                          ),
                    16.h.hBox,
                    _buildTreatmentSection(vm),
                    16.h.hBox,
                    _buildTextFieldLabel('Total Amount'),
                    CustomTextField(
                      hintText: 'Enter total amount',
                      controller: totalAmountController,
                      validator: AppValidator.requiredField,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Discount Amount'),
                    CustomTextField(
                      hintText: 'Enter discount amount',
                      controller: discountAmountController,
                      validator: AppValidator.requiredField,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    16.h.hBox,
                    _buildPaymentOptionSection(),
                    8.h.hBox,
                    _buildTextFieldLabel('Advance Amount'),
                    CustomTextField(
                      hintText: 'Enter advance amount',
                      controller: advanceAmountController,
                      validator: AppValidator.requiredField,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Balance Amount'),
                    CustomTextField(
                      hintText: 'Enter balance amount',
                      controller: balanceAmountController,
                      validator: AppValidator.requiredField,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    16.h.hBox,
                    _buildTextFieldLabel('Treatment Date'),
                    _buildDateInputField(),
                    16.h.hBox,
                    _buildTextFieldLabel('Treatment Time'),
                    _buildTimeFields(vm),
                    40.h.hBox,
                    CustomButton(text: 'Save', onPressed: _handleOnPressed(vm)),
                    20.h.hBox,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 5),
      child: Text(
        label,
        style: AppStyles.bodyText1.copyWith(
          color: AppColors.darkText,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTreatmentSection(RegisterViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldLabel('Treatments'),
        ...selectedTreatments.asMap().entries.map((entry) {
          final index = entry.key;
          final treatment = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.lightGreyBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}.  ${treatment['name']}',
                              style: AppStyles.bodyText1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      16.h.hBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Male',
                            style: AppStyles.bodyText2.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 13.5.sp,
                            ),
                          ),
                          6.w.wBox,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Text(
                              treatment['male'].toString(),
                              style: AppStyles.bodyText2.copyWith(
                                color: AppColors.primaryGreen,
                                fontSize: 13.5.sp,
                              ),
                            ),
                          ),
                          20.w.wBox,
                          Text(
                            'Female',
                            style: AppStyles.bodyText2.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 13.5.sp,
                            ),
                          ),
                          6.w.wBox,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Text(
                              treatment['female'].toString(),
                              style: AppStyles.bodyText2.copyWith(
                                color: AppColors.primaryGreen,
                                fontSize: 13.5.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                4.w.wBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red[300]),
                      onPressed: () {
                        setState(() {
                          selectedTreatments.remove(treatment);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        10.h.hBox,

        CustomButton(
          height: 50.h,
          text: '+ Add Treatment',
          onPressed: () async {
            final result = await showTreatmentDialog(context, vm.treatments);
            if (result != null) {
              setState(() {
                selectedTreatments.add(result);
              });
            }
          },
          backgroundColor: AppColors.primaryGreen.withOpacity(.2),
          textStyle: AppStyles.bodyText1.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldLabel('Payment Option'),
        Row(
          children: [
            _buildPaymentRadio('Cash'),
            _buildPaymentRadio('Card'),
            _buildPaymentRadio('UPI'),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentRadio(String text) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: text,
            groupValue: selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                selectedPaymentOption = value;
              });
            },
            activeColor: AppColors.primaryGreen,
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildDateInputField() {
    return TextFormField(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primaryGreen,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
          setState(() {
            _dateController.text = formattedDate;
          });
        }
      },
      controller: _dateController,
      readOnly: true,
      validator: AppValidator.requiredField,
      decoration: InputDecoration(
        hintText: 'Select Date',
        hintStyle: AppStyles.bodyText1.copyWith(
          color: Colors.grey,
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        filled: true,
        fillColor: AppColors.lightGreyBackground,
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: AppColors.primaryGreen,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTimeFields(RegisterViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField(
            hintText: 'Hour',
            items: vm.timeHours
                .map(
                  (hour) => DropdownMenuItem(
                    value: hour['id'],
                    child: Text(hour['name']!),
                  ),
                )
                .toList(),
            value: selectedHour,
            onChanged: (val) => setState(() => selectedHour = val),
          ),
        ),
        10.w.wBox,
        Expanded(
          child: _buildDropdownField(
            hintText: 'Minutes',
            items: vm.timeMinutes
                .map(
                  (minute) => DropdownMenuItem(
                    value: minute['id'],
                    child: Text(minute['name']!),
                  ),
                )
                .toList(),
            value: selectedMinute,
            onChanged: (val) => setState(() => selectedMinute = val),
          ),
        ),
      ],
    );
  }

  Widget thinDivider({Color color = const Color(0xFFE0E0E0)}) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  _handleOnPressed(RegisterViewModel vm) => () async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": nameController.text.trim(),
        "excecutive": "",
        "payment": selectedPaymentOption,
        "phone": whatsappController.text.trim(),
        "address": addressController.text.trim(),
        "total_amount": double.tryParse(totalAmountController.text.trim()),
        "discount_amount": double.tryParse(
          discountAmountController.text.trim(),
        ),
        "advance_amount": double.tryParse(advanceAmountController.text.trim()),
        "balance_amount": double.tryParse(balanceAmountController.text.trim()),
        "date_nd_time": formatDateTime(
          dateText: _dateController.text,
          hour: selectedHour ?? "",
          minute: selectedMinute ?? "",
          amPm: "AM",
        ),
        "id": 0,
        "male": selectedTreatments.fold<int>(
          0,
          (sum, t) => sum + (t['male'] as int),
        ),
        "female": selectedTreatments.fold<int>(
          0,
          (sum, t) => sum + (t['female'] as int),
        ),
        "branch": vm.selectedBranch,
        "treatments": selectedTreatments
            .map((t) => t['id'].toString())
            .join(','),
      };
      vm.treatmentDetails = selectedTreatments.map((t) {
        return {
          'male': t['male'].toString(),
          'female': t['female'].toString(),
          'treatmentName': t['name'],
        };
      }).toList();
      await vm.registerPatient(context: context, data: data);
    } else {
      customSnackBar(
        message: 'Fill all the fields correctly',
        context: context,
      );
    }
  };

  String formatDateTime({
    required String dateText,
    required String hour,
    required String minute,
    String amPm = "AM",
  }) {
    try {
      final date = DateFormat("dd-MM-yyyy").parse(dateText);
      int parsedHour = int.parse(hour);
      int parsedMinute = int.parse(minute);

      if (amPm.toUpperCase() == "PM" && parsedHour != 12) parsedHour += 12;
      if (amPm.toUpperCase() == "AM" && parsedHour == 12) parsedHour = 0;

      final fullDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        parsedHour,
        parsedMinute,
      );
      return DateFormat("dd/MM/yyyy hh:mm a").format(fullDateTime);
    } catch (e) {
      return "";
    }
  }
}

// ------------------- TREATMENT DIALOG ----------------------

Future<Map<String, dynamic>?> showTreatmentDialog(
  BuildContext context,
  List treatments,
) {
  int maleCount = 0;
  int femaleCount = 0;
  String? selectedTreatmentId;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Treatment',
                    style: AppStyles.bodyText2.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.h.hBox,
                  _buildDropdownField(
                    hintText: 'Choose preferred treatment',
                    value: selectedTreatmentId,

                    items: treatments
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id.toString(),
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedTreatmentId = val),
                  ),

                  20.h.hBox,
                  Text(
                    'Add Patients',
                    style: AppStyles.bodyText2.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.h.hBox,
                  _buildPatientCounter(
                    'Male',
                    maleCount,
                    () => setState(
                      () => maleCount = (maleCount > 0 ? maleCount - 1 : 0),
                    ),
                    () => setState(() => maleCount++),
                  ),
                  10.h.hBox,
                  _buildPatientCounter(
                    'Female',
                    femaleCount,
                    () => setState(
                      () =>
                          femaleCount = (femaleCount > 0 ? femaleCount - 1 : 0),
                    ),
                    () => setState(() => femaleCount++),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedTreatmentId == null) {
                          customSnackBar(
                            message: 'Select a treatment',
                            context: context,
                          );
                        }
                        ;
                        final selected = treatments.firstWhere(
                          (t) => t.id.toString() == selectedTreatmentId,
                        );
                        Navigator.of(context).pop({
                          "id": selected.id,
                          "name": selected.name,
                          "male": maleCount,
                          "female": femaleCount,
                        });
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E8830),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildPatientCounter(
  String gender,
  int count,
  VoidCallback onDecrease,
  VoidCallback onIncrease,
) {
  return Row(
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(gender),
        ),
      ),
      SizedBox(width: 10.0),
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1E8830),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.remove, color: Colors.white),
              onPressed: onDecrease,
            ),
          ),
          SizedBox(width: 5.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text('$count', style: TextStyle(fontSize: 16.0)),
          ),
          SizedBox(width: 5.0),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1E8830),
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: onIncrease,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildDropdownField({
  required String hintText,
  required List<DropdownMenuItem<String>> items,
  String? value,
  Function(String?)? onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    items: items,
    onChanged: onChanged,
    validator: AppValidator.requiredField,
    isExpanded: true,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.lightGreyBackground,
      hintText: hintText,
      hintStyle: AppStyles.bodyText1.copyWith(
        color: Colors.grey,
        fontSize: 13.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
    ),
    icon: Icon(
      Icons.keyboard_arrow_down_outlined,
      color: AppColors.primaryGreen,
    ),
    style: AppStyles.bodyText1.copyWith(color: Colors.black),
  );
}

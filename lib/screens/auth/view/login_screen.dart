import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_app/core/constants/app_colors.dart';
import 'package:hospital_app/core/constants/app_styles.dart';
import 'package:hospital_app/core/constants/app_validator.dart';
import 'package:hospital_app/core/extension/space_ext.dart';
import 'package:hospital_app/screens/auth/view_model/auth_view_model.dart';
import 'package:hospital_app/screens/widgets/custom_button.dart';
import 'package:hospital_app/screens/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopImageWithLogo(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.h.hBox,
                    Text(
                      'Login Or Register To Book Your Appointments',
                      style: AppStyles.heading1,
                    ),
                    30.h.hBox,
                    _buildTextFieldLabel('Email'),
                    6.h.hBox,
                    CustomTextField(
                      hintText: 'Enter Your Email',
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidator.requiredField,
                    ),
                    20.h.hBox,
                    _buildTextFieldLabel('Password'),
                    6.h.hBox,
                    CustomTextField(
                      hintText: 'Enter password',
                      obscureText: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: AppValidator.requiredField,
                    ),
                    50.h.hBox,
                    CustomButton(
                      isLoading: authVM.isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authVM.login(
                            username: usernameController.text.trim(),
                            password: passwordController.text.trim(),
                            context: context,
                          );
                        }
                      },
                      text: 'Login',
                    ),
                    120.h.hBox,
                    _buildLegalText(),
                    20.h.hBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTopImageWithLogo() {
  return SizedBox(
    height: 250.h,
    width: double.infinity,
    child: Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset('assets/images/hospital.jpg', fit: BoxFit.cover),

        // Blur Layer
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // adjust blur
          child: Container(
            color: Colors.black.withOpacity(0.1), // dark overlay
          ),
        ),

        Center(
          child: SvgPicture.asset(
            'assets/logo/app_logo.svg',
            height: 100.w,
            width: 100.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}

// text field label
Widget _buildTextFieldLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Text(
      label,
      style: AppStyles.bodyText1.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
      ),
    ),
  );
}

Widget _buildLegalText() {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: AppStyles.bodyText2.copyWith(color: Colors.grey[600]),
      children: <TextSpan>[
        const TextSpan(
          text:
              'By creating or logging into an account you are agreeing with our ',
        ),
        TextSpan(
          text: 'Terms and Conditions',
          style: AppStyles.bodyText2.copyWith(
            color: AppColors.linkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const TextSpan(text: ' and '),
        TextSpan(
          text: 'Privacy Policy.',
          style: AppStyles.bodyText2.copyWith(
            color: AppColors.linkBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

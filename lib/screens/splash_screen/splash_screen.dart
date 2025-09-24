import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_app/core/constants/app_storage_const.dart';
import 'package:hospital_app/core/helper/helper_routes.dart';
import 'package:hospital_app/core/service/local_storage.dart';
import 'package:hospital_app/screens/patients/view/patients_screen.dart';
import 'package:hospital_app/screens/auth/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay

    // Read token from SharedPreferences
    final accessToken = LocalStorage.read(AppStorageConst.accesstoken);

    if (accessToken != null && accessToken.toString().isNotEmpty) {
      navigate(context: context, screen: const PatientsScreen());
    } else {
      navigate(context: context, screen: LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/hospital.jpg', fit: BoxFit.cover),

          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // Centered Logo
          Center(
            child: SvgPicture.asset(
              'assets/logo/app_logo.svg',
              width: 140.w,
              height: 140.w,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hospital_app/core/constants/app_colors.dart';
import 'package:hospital_app/core/constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final double? width;
  final double elevation;

  const CustomButton({
    Key? key,
    this.isLoading = false,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.height = 50,
    this.borderRadius = 10,
    this.textStyle,
    this.width,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          elevation: elevation,
        ),
        child: isLoading
            ? SizedBox(
                height: 25.w,
                width: 25.w,
                child: const CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                text,
                style:
                    textStyle ??
                    AppStyles.heading1.copyWith(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
              ),
      ),
    );
  }
}

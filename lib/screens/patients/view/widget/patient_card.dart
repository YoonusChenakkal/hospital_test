import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hospital_app/core/constants/app_colors.dart';
import 'package:hospital_app/core/constants/app_styles.dart';
import 'package:hospital_app/core/extension/space_ext.dart';

class PatientCard extends StatelessWidget {
  final int indexNum;
  final String name;
  final String treatment;
  final String date;
  final String person;
  final VoidCallback? onTap;

  const PatientCard({
    Key? key,
    required this.indexNum,
    required this.name,
    required this.treatment,
    required this.date,
    required this.person,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.w,
              bottom: 10.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  '${indexNum}.',
                  style: AppStyles.bodyText1.copyWith(
                    color: AppColors.darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                15.w.wBox,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: AppStyles.bodyText1.copyWith(
                              color: AppColors.darkText,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      5.h.hBox,
                      Text(
                        treatment,
                        style: AppStyles.bodyText2.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      10.h.hBox,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16.sp,
                            color: Colors.deepOrangeAccent,
                          ),
                          5.w.wBox,
                          Text(
                            date,
                            style: AppStyles.bodyText2.copyWith(
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          15.w.wBox,
                          Icon(
                            Icons.group_outlined,
                            size: 16.sp,
                            color: Colors.deepOrangeAccent,
                          ),
                          5.w.wBox,
                          Text(
                            person,
                            style: AppStyles.bodyText2.copyWith(
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(
                bottom: 15.w,
                left: 50.w,
                right: 20.w,
                top: 5.w,
              ),
              child: Row(
                children: [
                  Text(
                    'View Booking details',
                    style: AppStyles.bodyText1.copyWith(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: AppColors.primaryGreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

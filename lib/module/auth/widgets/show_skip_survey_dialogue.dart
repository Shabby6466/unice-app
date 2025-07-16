import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/module/calling/navigation_data/navigation_data.dart';

void showSkipSurveyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Should I skip the survey?',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp, height: 24.sp / 20.sp),
        ),
        content: Text(
          'If you skip, you will not be able to receive rewards in the future.\nShould I skip?',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 20.sp / 16.sp,
                color: R.palette.textColor2,
              ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: R.palette.lightBorder,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'CANCEL',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: R.palette.disabledColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              height: 20.sp / 16.sp,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.microtask(() {
                      sl<Navigation>().pushNamedWithExtra(path: Routes.recommenderEmail, navigationData: OnboardingNavigationData(page: 1));
                    });
                  },
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: R.palette.primaryLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'SKIP',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: R.palette.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              height: 20.sp / 16.sp,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/module/auth/bloc/onboarding_bloc.dart';

class SelectAgeScreen extends StatefulWidget {
  const SelectAgeScreen({super.key});

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  final List<String> ageGroups = <String>['14 ~ 19', '20 ~ 24', '25 ~ 29', '30 ~ 34', '35 ~ 39', '40 ~ 44', '45 ~ 50', '51 ~ 54', '55 ~ 59', 'over 60'];

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.h),
        Container(
          padding: EdgeInsets.all(1.r),
          decoration: BoxDecoration(
            color: R.palette.primaryLight,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: CircleAvatar(
            radius: 28.r,
            backgroundImage: AssetImage(R.assets.graphics.pngIcons.areumAvatar),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          tr.select_age,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                height: 24.sp / 20.sp,
              ),
        ),
        SizedBox(height: 4.h),
        Text(
          tr.provides_age_appropriate_information,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: R.palette.textColor2,
                height: 16.41.sp / 14.sp,
              ),
        ),
        SizedBox(height: 24.h),
        const Spacer(),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 9.w,
          childAspectRatio: 3.39,
          children: ageGroups.map((age) => _buildSelectableButton(age)).toList(),
        ),
        SizedBox(height: 130.h),
      ],
    );
  }

  Widget _buildSelectableButton(String age) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            var isSelected = state.age == age;
            if (!isSelected) {
              context.read<OnboardingBloc>().add(SelectAge(age: age));
            }
          },
          child: Container(
            height: 48.h,
            width: 163.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: state.age == age ? R.palette.primaryLight : Colors.transparent,
                width: 2.w,
              ),
              color: R.palette.scBtn,
            ),
            child: Text(
              age,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 16.sp,
                    height: 1.2, // Ensures proper line height
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        );
      },
    );
  }
}

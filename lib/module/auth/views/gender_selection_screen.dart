import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/module/auth/bloc/onboarding_bloc.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {

  final List<String> genders = ['Male', 'Neutral', 'Female'];

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
          tr.gender_selection,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                height: 24.sp / 20.sp,
              ),
        ),
        SizedBox(height: 4.h),
        Text(
          tr.we_provide_gender_specific_information,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: R.palette.textColor2,
                height: 16.41.sp / 14.sp,
              ),
        ),
        SizedBox(height: 24.h),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: genders.map((gender) => _buildSelectableButton(gender)).toList(),
        ),
        SizedBox(height: 138.h),
      ],
    );
  }

  Widget _buildSelectableButton(String gender) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context.read<OnboardingBloc>().add(SelectGender(gender: gender));
            },
            child: Container(
              width: double.infinity,
              height: 48.h,
              margin: EdgeInsets.only(bottom: 12.h),
              // Space between buttons
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: state.gender == gender ? R.palette.primaryLight : Colors.transparent,
                  width: 1.5,
                ),
                color: R.palette.scBtn,
              ),
              child: Text(
                gender,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 16.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}

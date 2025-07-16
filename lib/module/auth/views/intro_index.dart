import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/widgets/show_skip_survey_dialogue.dart';
import 'package:unice_app/module/calling/navigation_data/navigation_data.dart';

class IntroIndex extends StatefulWidget {
  const IntroIndex({super.key});

  @override
  State<IntroIndex> createState() => _IntroIndexState();
}

class _IntroIndexState extends State<IntroIndex> {
  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return Background(
        safeAreaTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Container(
                height: 180.h,
                width: 180.w,
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: R.palette.primaryBorder, width: 1.r),
                  boxShadow: [
                    BoxShadow(
                      color: R.palette.primaryBorder.withValues(alpha: 1),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    R.assets.graphics.pngIcons.areumAvatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 64.h),
            Text(
              tr.hello_my_name_is_areum,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    height: 28.sp / 20.sp,
                    color: R.palette.disabledColor,
                  ),
            ),
            const Spacer(),
            MyButton(
                title: tr.yes,
                onTap: () {
                  sl<Navigation>().pushNamedWithExtra(path: Routes.recommenderEmail, navigationData: OnboardingNavigationData(page: 0));
                }),
            SecondaryButton(
              title: tr.skip_capital,
              decoration: TextDecoration.underline,
              onTap: () {
                showSkipSurveyDialog(context);
              },
              weight: FontWeight.w500,
            ),
            SizedBox(height: 16.h),
          ],
        ));
  }
}

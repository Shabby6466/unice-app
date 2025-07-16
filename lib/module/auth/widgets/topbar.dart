import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/widgets/back_arrow.dart';

class BuildTopBar extends StatelessWidget {
  final bool showBackArrow;
  final bool shouldShowLinearIndicator;
  final double percent;
  final VoidCallback? onBackPress;
  final Color? iconColor;

  const BuildTopBar({
    required this.shouldShowLinearIndicator,
    required this.showBackArrow,
    required this.percent,
    this.onBackPress,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      height: 76.h,
      width: double.maxFinite,
      child: Stack(
        children: [
          if (showBackArrow)
            SizedBox(
              height: 56.h,
              child: BackArrow(
                iconColor:iconColor,
                action: () {
                  if (onBackPress != null) {
                    onBackPress!();
                  } else {
                    context.pop();
                  }
                },
              ),
            ),
          if (shouldShowLinearIndicator) ...[
            Align(
              alignment: Alignment.center,
              child: LinearPercentIndicator(
                  key: const ValueKey('linearPercentIndicator_key_1'),
                  animation: true,
                  lineHeight: 8.h,
                  percent: percent,
                  alignment: MainAxisAlignment.center,
                  backgroundColor: R.palette.lightBorder,
                  barRadius: Radius.circular(4.r),
                  progressColor: R.palette.primaryLight,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

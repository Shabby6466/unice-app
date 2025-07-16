import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/module/auth/widgets/cutdown_timer.dart';
import 'package:unice_app/module/auth/widgets/pin_code_field.dart';

class LowerVisibleWidget extends StatefulWidget {
  final VoidCallback onTap;
  final ValueChanged<String> onPin;

  const LowerVisibleWidget({super.key, required this.onTap, required this.onPin});

  @override
  State<LowerVisibleWidget> createState() => _LowerVisibleWidgetState();
}

class _LowerVisibleWidgetState extends State<LowerVisibleWidget> {
  TextEditingController pinCodeController = TextEditingController();
  int resendCount = 0;
  bool showTimer = true;
  bool showResendButton = false;
  bool showLoader = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PinCodeField(
          pinCodeController,
          onPin: (String pin) async {
            widget.onPin(pin);
          },
        ),
        SizedBox(
          height: 0.h,
        ),
        SizedBox(
          height: 50.h,
        ),
        (showTimer)
            ? Column(
          children: [
            Center(
              child: Text(
                'You can resend your code if it does\'nt arrive in',
                key: const ValueKey('text_key_3'),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              key: const ValueKey('row_key_1'),
              children: <Widget>[
                CountDownTimer(
                  secondsRemaining: 120,
                  key: ValueKey(resendCount),
                  whenTimeExpires: (showTheTimer, showTheLoader, showTheResendButton) {
                    setState(() {
                      showTimer = showTheTimer;
                      showLoader = showTheLoader;
                      showResendButton = showTheResendButton;
                    });
                    if (resendCount == 1) {
                      return;
                    }
                  },
                  countDownTimerStyle: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
                ),
                Flexible(
                    child: Text(" ${"mins"} ", key: const ValueKey('text_key_5'), style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400))),
              ],
            ),
          ],
        )
            : const SizedBox.shrink(),
        (showResendButton)
            ? Center(
          child: GestureDetector(
              key: const ValueKey('GestureDetector_key'),
              onTap: widget.onTap,
              child: ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier(true),
                  builder: (context, loading, ____) {
                    return Text(
                      'Resend Code',
                      key: const ValueKey('text_key_6'),
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
                    );
                  })),
        )
            : const SizedBox.shrink()
      ],
    );
  }
}

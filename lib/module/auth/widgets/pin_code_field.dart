import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onPin;

  const PinCodeField(this.controller, {super.key, required this.onPin});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: 45.0.h,
          left: 62.w,
          right: 61.w,
        ),
        child: PinCodeTextField(
          onChanged: (_) {},
          appContext: context,
          enablePinAutofill: false,
          key: const ValueKey('pincode_key'),
          obscureText: false,
          autoFocus: true,
          autoDismissKeyboard: true,
          textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 36.sp,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          pastedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          length: 4,
          cursorColor: Theme.of(context).colorScheme.primary,
          cursorWidth: 2.w,
          // obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            borderWidth: 3.w,
            fieldHeight: 60.h,
            fieldWidth: 27.w,
            disabledColor: Theme.of(context).disabledColor,
            selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
            selectedColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).disabledColor,
            inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
            activeColor: Theme.of(context).primaryColor,
            activeFillColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          enableActiveFill: true,
          controller: controller,
          onCompleted: (pin) async {
            onPin(pin);
          },
        ));
  }
}

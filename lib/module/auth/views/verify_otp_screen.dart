import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/module/auth/bloc/login_bloc.dart';
import 'package:unice_app/module/auth/widgets/lower_visible_widget.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  VerifyOtpScreenState createState() => VerifyOtpScreenState();
}

class VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String? verificationId;

  int resendCount = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'scaffold-verify-phone');

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(listener: (context, state) {
            if (state is VerifiedEmailOtpSuccess) {
              sl<Navigation>().go(Routes.bottomTab);
            }
            if (state is VerifiedEmailOtpFailed) {
              Utility.showError(context, state.errMsg);
            }
          }),
        ],
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return Background(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Flexible(
                    child: Text(
                      'Enter 4 digit Code',
                      textScaler: const TextScaler.linear(1),
                      key: const ValueKey('text_key_1'),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Flexible(
                    child: Text(
                      "We've sent it to ${state.email}",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Center(
                      child: Column(
                        key: const ValueKey('column_key_2'),
                        children: <Widget>[
                          LowerVisibleWidget(
                            onPin: (value) {
                              context.read<LoginBloc>().add(VerifyEmailOtpEvent(code: value));
                            },
                            onTap: () {
                              context.read<LoginBloc>().add(ResendEmailOtpEvent());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  const Spacer(flex: 7)
                ],
              ),
            ),
          );
        }));
  }
}

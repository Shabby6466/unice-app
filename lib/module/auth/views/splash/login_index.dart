import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/app_links/app_link_listener.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/bloc/login_bloc.dart';
import 'package:unice_app/module/auth/usecase/save_token_use_case.dart';
import 'package:unice_app/module/calling/bloc/call_bloc.dart';
import 'package:unice_app/module/calling/navigation_data/navigation_data.dart';
import 'package:unice_app/module/onboarding/widgets/custom_buttom.dart';

class LoginIndex extends StatefulWidget {
  final Object? extra;

  const LoginIndex({super.key, this.extra});

  @override
  State<LoginIndex> createState() => _LoginIndexState();
}

class _LoginIndexState extends State<LoginIndex> {
  final _linkListener = AppLinkListener();
  bool _shouldIgnoreDeepLinks = false;

  @override
  void initState() {
    super.initState();
    if (widget.extra != null && widget.extra is Map) {
      final extraMap = widget.extra as Map;
      _shouldIgnoreDeepLinks = extraMap['ignoreDeepLinks'] == true;
    }

    if (!_shouldIgnoreDeepLinks) {
      _linkListener.init(context);
    } else {
      AppLinkListener.resetDeepLinkState();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLinkListener.markUserLoggedOut();
    // Force reset deep link handling when this screen builds
    // This prevents delayed processing of deep links after hot restart

    var tr = AppLocalizations.of(context);
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GoogleLoginSuccessState) {
          // context.read<LoginBloc>().add(GetProfileEvent());
          if (state.googleAuthOutputs.user.isActive) {
            sl<SaveTokenUseCase>().call(state.googleAuthOutputs.token);
            context.read<CallScreenBloc>().add(GenerateTokenEvent());
            sl<Navigation>().go(Routes.bottomTab);
          } else {
            sl<Navigation>().go(Routes.createProfile);
          }
        }
        if (state is TokenFoundState) {
          context.read<LoginBloc>().add(GetProfileEvent());
          sl<Navigation>().go(Routes.bottomTab);
        }
      },
      builder: (context, state) {
        return Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(child: SvgPicture.asset(R.assets.graphics.svgIcons.uniceLogo)),
              Center(child: SvgPicture.asset(R.assets.graphics.svgIcons.uniceText)),
              SizedBox(height: 8.h),
              Text(
                tr.tokenizing_your_emotion,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 8.sp,
                      height: 8.sp / 8.sp,
                      color: R.palette.disabledColor,
                    ),
              ),
              const Spacer(),
              CustomButton(
                callback: () {
                  context.read<LoginBloc>().add(GoogleAuthenticateEvent());
                },
                buttonColor: R.palette.white,
                logoImage: R.assets.graphics.svgIcons.googleLogo,
                buttonText: tr.login_google,
                textColor: R.palette.black2,
              ),
              SizedBox(height: 12.h),
              Visibility(
                // visible: true,
                visible: Platform.isIOS,
                child: Padding(
                  padding:  EdgeInsets.only(bottom: 20.h),
                  child: CustomButton(
                    callback: () {
                      context.read<LoginBloc>().add(AppleAuthenticateEvent());
                      // sl<Navigation>().go(Routes.signup);
                    },
                    buttonColor: R.palette.blackColor,
                    logoImage: R.assets.graphics.svgIcons.appleLogo,
                    buttonText: tr.login_apple,
                    textColor: R.palette.white,
                  ),
                ),
              ),
              MyButton(
                onTap: () {
                  sl<Navigation>().push(path: Routes.login);
                },
                title: tr.login_email,
              ),
              GestureDetector(
                onTap: () => sl<Navigation>().pushNamedWithExtra(
                    path: Routes.signup,
                    navigationData: SignupNavigationData(
                      referCode: null,
                    )),
                child: Container(
                  width: double.maxFinite,
                  color: R.palette.white,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 32.h),
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Text(
                    tr.registerNow,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 14.sp,
                          height: 16.sp / 12.sp,
                          fontWeight: FontWeight.w600,
                          color: R.palette.primary,
                        ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}

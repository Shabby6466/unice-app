import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/lottie_asset.dart';
import 'package:unice_app/module/auth/bloc/login_bloc.dart';
import 'package:unice_app/module/calling/bloc/call_bloc.dart';
import 'package:unice_app/module/chats/bloc/chat_bot_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    context.read<LoginBloc>().add(GetTokenEvent());
    var loginState = context.read<LoginBloc>().state;
    context.read<ChatBotBloc>().add(LoadChatHistoryEvent(userId: loginState.userId, page: '1'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GetProfileSuccessState) {
          context.read<CallScreenBloc>().add(GenerateTokenEvent());
          sl<Navigation>().go(Routes.bottomTab);
        }
        if (state is TokenFoundState) {
          context.read<LoginBloc>().add(GetProfileEvent());
        }
        if (state is TokenNotFoundState) {
          sl<Navigation>().go(Routes.loginIndex);
        }
        if (state.loggedIn && !state.profileOutput.isEmailVerified) {
          sl<Navigation>().go(Routes.verifyOtpScreen);
        }
      },
      child: Background(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(R.assets.graphics.svgIcons.uniceLogo),
              SvgPicture.asset(R.assets.graphics.svgIcons.uniceText),
              SizedBox(height: 8.h),
              Text(
                AppLocalizations.of(context).tokenizing_your_emotion,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 10.sp,
                      height: 8.sp / 8.sp,
                      color: R.palette.disabledColor,
                    ),
              ),
              const Spacer(),
              MyLottieAnim(
                path: R.assets.graphics.lottieAssets.loading,
                width: double.maxFinite,
                height: 50.h,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

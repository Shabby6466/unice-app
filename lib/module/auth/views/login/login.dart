import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/custom_textfield.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/bloc/login_bloc.dart';
import 'package:unice_app/module/calling/bloc/call_bloc.dart';
import 'package:unice_app/module/chats/bloc/chat_bot_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is EmailLoginFailState) {
          Utility.showError(context, state.errMsg);
        }
        if (state is EmailLoginSuccessState) {
          context.read<LoginBloc>().add(GetProfileEvent());
        }
        if (state is GetProfileSuccessState) {
          context.read<CallScreenBloc>().add(GenerateTokenEvent());
          var loginState = context.read<LoginBloc>().state;
          context.read<ChatBotBloc>().add(LoadChatHistoryEvent(userId: loginState.userId, page: '1'));
          if (state.profileOutput.isEmailVerified) {
            sl<Navigation>().go(Routes.bottomTab);
          } else {
            sl<Navigation>().go(Routes.verifyOtpScreen);
          }
        }
      },
      builder: (context, state) {
        return Background(
          // resizeToAvoidBottomInset: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 89.h),
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
                SizedBox(height: 45.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    labelText: tr.enter_address,
                    hintText: tr.enter_address,
                    errorText: '',
                    onChange: (v) => context.read<LoginBloc>().add(ChangeLoginEmailEvent(value: v)),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    obscureText: state.obscureText,
                    labelText: tr.password,
                    hintText: tr.password,
                    errorText: '',
                    onChange: (v) => context.read<LoginBloc>().add(ChangeLoginPasswordEvent(value: v)),
                    suffixIcon: GestureDetector(
                      child: Icon(state.obscureText ? Icons.visibility_off : Icons.visibility, color: R.palette.disabledColor),
                      onTap: () => context.read<LoginBloc>().add(ChangeObscureTextEvent()),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                MyButton(
                  loading: state.loading,
                  disableButton: !Utility.isEmailValid(state.email) || state.password.isEmpty,
                  onTap: () {
                    context.read<LoginBloc>().add(LoginEmailEvent());
                  },
                  title: tr.login,
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => sl<Navigation>().push(path: Routes.forgotPass),
                  child: Text(
                    tr.forgotPwd,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 14.sp,
                          height: 16.sp / 12.sp,
                          fontWeight: FontWeight.w400,
                          color: R.palette.primary,
                        ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

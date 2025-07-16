import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/custom_textfield.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/bloc/forgot_password_bloc.dart';
import 'package:unice_app/module/home/widgets/manage_friends_top_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);

    return BlocConsumer<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is EmailSentState) {
          Utility.showSuccess(context, tr.emailSentSuccess);
          sl<Navigation>().go(Routes.forgotSetPassword);
        }
      },
      builder: (context, state) {
        return Background(
          safeAreaTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FriendsTopBar(
                title: tr.back,
              ),
              SizedBox(height: 26.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Icon(CupertinoIcons.lock, size: 48, color: Colors.grey.withValues(alpha: .5)),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  tr.forgotPassword_,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  tr.forgotPassword_sub,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MaterialTextFormField(
                  controller: emailController,
                  labelText: tr.email_address,
                  hintText: tr.email_address,
                  errorText: '',
                  onChange: (String val) => context.read<PasswordBloc>().add(ChangeEmailEvent(email: val)),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      tr.rememberPass,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: R.palette.lightText,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        sl<Navigation>().popFromRoute();
                      },
                      child: Text(
                        tr.signIn,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: R.palette.primaryLight,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              BlocBuilder<PasswordBloc, PasswordState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: MyButton(
                      loading: state.loading,
                      disableButton: state.email.isEmpty,
                      title: tr.resetPassword,
                      onTap: () => context.read<PasswordBloc>().add(ResetPasswordEmailSentEvent()),
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }
}

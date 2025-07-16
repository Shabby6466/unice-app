import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/custom_textfield.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/bloc/forgot_password_bloc.dart';
import 'package:unice_app/module/home/widgets/manage_friends_top_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ForgotSetPasswordState();
}

class _ForgotSetPasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return BlocConsumer<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSetState) {
          Utility.showSuccess(context, tr.passwordChanged);
          sl<Navigation>().popFromRoute();
        }

        if (state is ChangePasswordErrorState) {
          Utility.showError(context, tr.passwordChangeFailed);
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
                child: Icon(CupertinoIcons.lock, size: 48, color: R.palette.textColor),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  tr.changePassword,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MaterialTextFormField(
                  labelText: tr.currentPassword,
                  hintText: tr.currentPassword,
                  errorText: '',
                  onChange: (v) => context.read<PasswordBloc>().add(ChangeCurrentPassword(val: v)),
                  obscureText: state.obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      context.read<PasswordBloc>().add(TogglePasswordVisibilityEvent());
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MaterialTextFormField(
                  labelText: tr.newPassword,
                  hintText: tr.newPassword,
                  errorText: '',
                  onChange: (v) => context.read<PasswordBloc>().add(ChangeNewPassword(val: v)),
                  obscureText: state.obscurePassword2,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscurePassword2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      context.read<PasswordBloc>().add(TogglePassword2VisibilityEvent());
                    },
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MyButton(
                  loading: state.loading,
                  disableButton:
                      (!Utility.isValidPassword(state.currentPassword, R.passLength) || !Utility.isValidPassword(state.newPassword, R.passLength)),
                  title: tr.continue_button,
                  onTap: () => context.read<PasswordBloc>().add(ChangePassApiEvent()),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

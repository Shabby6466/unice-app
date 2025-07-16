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

class ForgotSetPassword extends StatefulWidget {
  const ForgotSetPassword({super.key});

  @override
  State<ForgotSetPassword> createState() => _ForgotSetPasswordState();
}

class _ForgotSetPasswordState extends State<ForgotSetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return BlocConsumer<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is PasswordSetState) {
          Utility.showSuccess(context, tr.passwordReSet);
          sl<Navigation>().go(Routes.login);
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
                  tr.createPassword,
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
                  labelText: tr.password,
                  controller: _passwordController,
                  hintText: tr.password,
                  errorText: '',
                  onChange: (v) => context.read<PasswordBloc>().add(ChangePassEvent(val: v)),
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
                  labelText: tr.reEnterPassword,
                  hintText: tr.reEnterPassword,
                  controller: _confirmPasswordController,
                  errorText: '',
                  onChange: (v) => context.read<PasswordBloc>().add(ChangePass2Event(val: v)),
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
                  disableButton: (!Utility.isValidPassword(state.pass, R.passLength) || !Utility.isValidPassword(state.pass2, R.passLength)) ||
                      state.pass != state.pass2,
                  title: tr.continue_button,
                  onTap: () => context.read<PasswordBloc>().add(SetPasswordEvent()),
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

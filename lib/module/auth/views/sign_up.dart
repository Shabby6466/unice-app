import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:unice_app/module/auth/bloc/register_bloc.dart';
import 'package:unice_app/module/calling/navigation_data/navigation_data.dart';

class SignUpScreenIndex extends StatefulWidget {
  final SignupNavigationData navigationData;

  const SignUpScreenIndex({super.key, required this.navigationData});

  @override
  State<SignUpScreenIndex> createState() => _SignUpScreenIndexState();
}

class _SignUpScreenIndexState extends State<SignUpScreenIndex> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    final refCode = widget.navigationData.referCode;
    if (refCode != null && refCode.isNotEmpty) {
      _referCodeController.text = refCode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RegisterBloc>().add(ChangeReferralCodeEvent(value: refCode));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFieldCorrectState) {
          context.read<RegisterBloc>().add(RegisterApiEvent());
        }
        if (state is RegisterFieldIncorrectState) {
          Utility.showError(context, state.errMsg);
        }
        if (state is RegisterFailState) {
          Utility.showError(context, state.errMsg);
        }
        if (state is RegisterSuccessState) {
          sl<Navigation>().go(Routes.createProfile);
        }
      },
      builder: (context, state) {
        return Background(
          safeAreaTop: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80.h),
                Text(
                  tr.create_an_account,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        height: 24.sp / 24.sp,
                      ),
                ),
                SizedBox(height: 7.h),
                Text(
                  tr.connect_with_your_friends_today,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 14.sp / 14.sp,
                      ),
                ),
                SizedBox(height: 36.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    controller: _usernameController,
                    hintText: tr.enter_your_username,
                    errorText: '',
                    textInputFormatter: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onChange: (e) => context.read<RegisterBloc>().add(ChangeUsernameEvent(value: e)),
                    maxLength: 100,
                    labelText: tr.enter_your_username,
                  ),
                ),
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    controller: _emailController,
                    hintText: tr.enter_your_email,
                    errorText: '',
                    onChange: (e) => context.read<RegisterBloc>().add(ChangeEmailEvent(value: e)),
                    maxLength: 100,
                    labelText: tr.enter_your_email,
                  ),
                ),
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    controller: _referCodeController,
                    hintText: '${tr.referred_by} [${tr.optional}]',
                    errorText: '',
                    readOnly: widget.navigationData.referCode != null && widget.navigationData.referCode!.isNotEmpty,
                    onChange: (e) {
                      context.read<RegisterBloc>().add(ChangeReferralCodeEvent(value: e));
                    },
                    maxLength: 100,
                    labelText: '${tr.referred_by} [${tr.optional}]',
                  ),
                ),
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    controller: _pass,
                    hintText: tr.password,
                    errorText: '',
                    onChange: (e) => context.read<RegisterBloc>().add(ChangePasswordEvent(value: e)),
                    maxLength: 100,
                    obscureText: state.togglePassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        context.read<RegisterBloc>().add(TogglePasswordEvent());
                      },
                      child: Icon(
                        state.togglePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: R.palette.primaryLight,
                      ),
                    ),
                    labelText: tr.password,
                  ),
                ),
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: MaterialTextFormField(
                    controller: _confirmPass,
                    hintText: tr.confirmPassword,
                    errorText: '',
                    onChange: (e) => context.read<RegisterBloc>().add(ChangeConfirmPasswordEvent(value: e)),
                    maxLength: 100,
                    obscureText: state.toggleConfirmPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        context.read<RegisterBloc>().add(ToggleConfirmPasswordEvent());
                      },
                      child: Icon(
                        state.toggleConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: R.palette.primaryLight,
                      ),
                    ),
                    labelText: tr.confirmPassword,
                  ),
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.sp),
                    child: Text(
                      'Password must be alphanumeric',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 10.sp,
                            color: R.palette.blackColor,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.sp),
                    child: Text(
                      'Password must contain special character like\n! # \$ & * ~ ^ % ( ) _ + { } [ ] : ; " \' < > , . ? \\ | / - ',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 10.sp,
                            color: R.palette.blackColor,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 130.h),
                MyButton(
                  loading: state.loading,
                  title: tr.sign_up,
                  disableButton: disableBtn(state),
                  onTap: () {
                    context.read<RegisterBloc>().add(RegisterFieldCheckEvent(
                          password: state.password,
                          confirmPassword: state.confirmPassword,
                        ));
                  },
                ),
                SizedBox(height: 34.h),
              ],
            ),
          ),
        );
      },
    );
  }

  bool disableBtn(RegisterState state) {
    if (state.username.isEmpty) {
      return true;
    } else if (!Utility.isEmailValid(state.email)) {
      return true;
    } else {
      return false;
    }
  }
}

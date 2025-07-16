import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/custom_app_bar.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/bloc/login_bloc.dart';
import 'package:unice_app/module/auth/bloc/onboarding_bloc.dart';
import 'package:unice_app/module/auth/bloc/register_bloc.dart';
import 'package:unice_app/module/auth/views/gender_selection_screen.dart';
import 'package:unice_app/module/auth/views/select_age_screen.dart';
import 'package:unice_app/module/calling/bloc/call_bloc.dart';
import 'package:unice_app/module/calling/navigation_data/navigation_data.dart';

class OnboardingIndex extends StatefulWidget {
  final OnboardingNavigationData navigationData;

  const OnboardingIndex({super.key, required this.navigationData});

  @override
  State<OnboardingIndex> createState() => _OnboardingIndexState();
}

class _OnboardingIndexState extends State<OnboardingIndex> {
  PageController _pageController = PageController();

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(OnboardingInitialPageEvent(page: widget.navigationData.page));

    _pageController = PageController(initialPage: widget.navigationData.page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    var registerState = context.read<RegisterBloc>().state;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GetProfileSuccessState) {
          context.read<CallScreenBloc>().add(GenerateTokenEvent());
          sl<Navigation>().go(Routes.verifyOtpScreen);
        }
      },
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.currentPage > 1) {
            sl<Navigation>().go(Routes.bottomTab);
          } else {
            _pageController.jumpToPage(state.currentPage);
          }
          if (state.currentPage == 1) {
            if (state is CreateProfileSuccessState) {
              context.read<LoginBloc>().add(GetProfileEvent());
            } else if (state is CreateProfileFailureState) {
              Utility.showError(context, state.errMsg);
              sl<Navigation>().go(Routes.createProfile);
            }
          }
        },
        builder: (context, state) {
          double barPercent() {
            if (state.currentPage == 0) return 0.29;
            if (state.currentPage == 1) return 0.66;
            return 1;
          }

          void nextPage(BuildContext context) {
            if (state.currentPage == 1) {
              if (context.mounted) {
                context.read<OnboardingBloc>().add(CreateAccountApiEvent(token: registerState.token));
              }
            } else {
              context.read<OnboardingBloc>().add(NextPageEvent());
            }
          }

          void backPress(BuildContext context) {
            if (state.currentPage == 0) {
              if (sl<Navigation>().canPop()) {
                sl<Navigation>().popFromRoute();
              }
            } else {
              context.read<OnboardingBloc>().add(BackPageEvent());
            }
          }

          return Background(
            appBar: CustomAppBar(
              onBackTap: () {
                backPress(context);
              },
              shouldShowLinearIndicator: true,
              percent: barPercent(),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(UpdatePageEvent(page: index));
                        },
                        children: [
                          const SelectAgeScreen(),
                          const GenderSelectionScreen(),
                        ],
                      )),
                  AnimatedPositioned(
                    left: 0,
                    right: 0,
                    bottom: 34.h,
                    duration: const Duration(milliseconds: 200),
                    child: MyButton(
                      disableButton: state.isDisabled,
                      onTap: () async {
                        nextPage(context);
                        context.read<OnboardingBloc>().add(UpdateDisableStateEvent(isDisabled: true));
                      },
                      loading: state.loading,
                      title: tr.next,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

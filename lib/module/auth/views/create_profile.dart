import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/utils/validators/text_field_validators.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/cache_network_image.dart';
import 'package:unice_app/core/widgets/custom_textfield.dart';
import 'package:unice_app/core/widgets/material_button.dart';
import 'package:unice_app/module/auth/bloc/onboarding_bloc.dart';
import 'package:unice_app/module/auth/bloc/register_bloc.dart';

class CreateProfileIndex extends StatefulWidget {
  const CreateProfileIndex({super.key});

  @override
  State<CreateProfileIndex> createState() => _CreateProfileIndexState();
}

class _CreateProfileIndexState extends State<CreateProfileIndex> {
  GlobalKey<FormState> formState = GlobalKey();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final DateTime _selectedDate = DateTime(2000, 1, 1); // Default DOB

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return BlocConsumer<OnboardingBloc, OnboardingState>(listener: (context, state) {
      if (state is ImagePickErrorState) {
        Utility.showError(context, state.errMsg);
      }
    }, builder: (context, state) {
      return Background(
        safeAreaTop: true,
        child: Form(
          key: formState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Text(
                tr.create_profile,
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
              SizedBox(height: 38.h),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircularCacheNetworkImage(
                    height: 150.h,
                    width: 150.w,
                    imageUrl: state.imageUrl,
                    size: 150.r,
                    backgroundColor: R.palette.white,
                    imageFit: BoxFit.cover,
                    errorIconPath: R.assets.graphics.svgIcons.avatarIcon,
                  ),
                  Positioned(
                    right: 10.w,
                    bottom: 0,
                    child: state.loading
                        ? SizedBox(
                            height: 36.h,
                            width: 36.w,
                            child: const CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (context.mounted) {
                                context.read<OnboardingBloc>().add(AddProfilePictureEvent(token: context.read<RegisterBloc>().state.token));
                              }
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: R.palette.textColor2,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.r),
                                child: InkResponse(
                                  child: SvgPicture.asset(
                                    R.assets.graphics.svgIcons.cameraIcon,
                                    height: 50.h,
                                    width: 50.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(height: 36.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 39.w),
                child: MaterialTextFormField(
                  controller: _fullNameController,
                  hintText: tr.enter_your_full_name,
                  errorText: '',
                  onChange: (e) {},
                  maxLength: 100,
                  validator: TextFieldValidator.validateFirstName,
                  labelText: tr.enter_your_full_name,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 39.w),
                child: CustomTextField(
                  readOnly: true,
                  hintText: tr.enter_your_date_of_birth,
                  controller: _dateOfBirthController,
                  validator: TextFieldValidator.validateDateOfBirth,
                  showMaxLength: false,
                  onChange: (e) {},
                  onClick: () => _showDatePicker(context),
                  maxLength: 100,
                ),
              ),
              const Spacer(flex: 4),
              MyButton(
                  title: tr.next,
                  onTap: () {
                    if (formState.currentState == null) {
                      return;
                    }
                    if (!formState.currentState!.validate()) {
                      return;
                    }
                    if (context.mounted) {
                      context.read<OnboardingBloc>().add(CreateProfileEvent(
                            name: _fullNameController.text,
                            dob: _dateOfBirthController.text,
                          ));
                    }
                  }),
              SizedBox(height: 34.h),
            ],
          ),
        ),
      );
    });
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime maxDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: R.palette.primary,
              onPrimary: Colors.white,
              onSurface: CupertinoColors.black,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: CupertinoColors.systemGroupedBackground),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _dateOfBirthController.text = Utility.getDateWithFormat("yyyy-MM-dd", picked);
      });
    }
  }

  String get formattedDate {
    return "${_selectedDate.day.toString().padLeft(2, '0')}-"
        "${_selectedDate.month.toString().padLeft(2, '0')}-"
        "${_selectedDate.year}";
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/network_calls/dio_wrapper/index.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/image_picker/image_picker.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/module/auth/usecase/save_token_use_case.dart';
import 'package:unice_app/module/auth/usecase/upload_image_usecase.dart';
import 'package:unice_app/module/intro/usecases/create_profile_usecase.dart';
import 'package:unice_app/module/intro/usecases/update_user_profile_usecase.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CreateProfileUsecase createProfileUsecase;
  final UploadFileUsecase uploadFileUsecase;
  final UpdateUserProfileUsecase updateUserProfileUsecase;
  final SaveTokenUseCase saveTokenUseCase;

  OnboardingBloc({
    required this.createProfileUsecase,
    required this.updateUserProfileUsecase,
    required this.uploadFileUsecase,
    required this.saveTokenUseCase,
  }) : super(OnboardingChangeState.initial()) {
    on<UpdateDisableStateEvent>(_updateDisableState);
    on<NextPageEvent>(_nextPage);
    on<BackPageEvent>(_backPage);
    on<UpdatePageEvent>(_updatePage);
    on<ShowClearIcon>(_showClearIcon);
    on<SelectAge>(_selectAge);
    on<SelectGender>(_selectGender);
    on<CreateAccountApiEvent>(_createAccountApiEvent);
    on<SignUpEvent>(_signUp);
    on<CreateProfileEvent>(_createProfileEvent);
    on<OnboardingInitialPageEvent>(_onboardingInitialPageEvent);
    on<ResetStateEvent>(_resetState);
    on<AddImageEvent>(_addImageEvent);
    on<AddProfilePictureEvent>(_addProfilePictureEvent);
    on<UpdateBioEvent>(_updateBioEvent);
  }

  void _addProfilePictureEvent(AddProfilePictureEvent event, Emitter<OnboardingState> emit) async {
    try {
      emit(getBlocState(loading: true, errMsg: ''));
      final imagePath = await sl<LocalImagePicker>().getImageFromGallery();
      final res = await uploadFileUsecase.call(UploadFileInput(filePath: imagePath, token: event.token));
      emit(getBlocState(
        loading: false,
        image: res.url,
        imageUrl: imagePath,
        errMsg: '',
      ));
    } on DefaultFailure catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        image: state.image,
        dob: state.dob,
        fullName: state.fullName,
      ));
    } on ImagePickCancelled catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.toString(),
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        image: state.image,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    } on InvalidFileFormat catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        image: state.image,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    } on FileTooBigFailure catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        image: state.image,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    }
  }

  void _addImageEvent(AddImageEvent event, Emitter<OnboardingState> emit) async {
    try {
      emit(getBlocState(loading: true, errMsg: ''));
      final imagePath = await sl<LocalImagePicker>().getImageFromGallery();
      final res = await uploadFileUsecase.call(UploadFileInput(filePath: imagePath, token: event.token));
      sl<Logger>().i('update image url: ${res.url}');
      await updateUserProfileUsecase.call(UpdateUserProfileInput(
        profilePicture: res.url,
        token: event.token,
      ));
      emit(ProfilePicSuccess(
        loading: false,
        errMsg: '',
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: res.url,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
        image: res.url,
      ));
      emit(getBlocState(
        loading: false,
        imageUrl: imagePath,
        errMsg: '',
      ));
    } on DefaultFailure catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        image: state.image,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    } on ImagePickCancelled catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.toString(),
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        image: state.image,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    } on InvalidFileFormat catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        image: state.image,
        fullName: state.fullName,
      ));
    } on FileTooBigFailure catch (e) {
      emit(ImagePickErrorState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        image: state.image,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    }
  }

  void _updateBioEvent(UpdateBioEvent event, Emitter<OnboardingState> emit) async {
    try {
      emit(getBlocState(errMsg: ''));
      await updateUserProfileUsecase.call(UpdateUserProfileInput(
        bio: event.bio,
        token: '',
      ));
      emit(UpdateBioSuccessState(
        loading: false,
        errMsg: '',
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
        image: state.image,
      ));
    } on DefaultFailure catch (e) {
      emit(UpdateBioFailedState(
        loading: false,
        errMsg: e.message,
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        image: state.image,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        fullName: state.fullName,
      ));
    }
  }

  void _createAccountApiEvent(CreateAccountApiEvent event, Emitter<OnboardingState> emit) async {
    try {
      final dob = DateTime.parse(state.dob);
      final formattedDob = Utility.formatDateToString(dob, format: 'yyyy-MM-dd');

      final now = DateTime.now();
      var age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      emit(getBlocState(loading: true));
      await saveTokenUseCase.call(event.token);
      await createProfileUsecase(CreateProfileInput(
        profilePicture: state.image,
        name: state.fullName,
        gender: state.gender.toLowerCase(),
        dob: formattedDob,
        age: age.toString(),
        token: event.token,
      ));
      emit(CreateProfileSuccessState(
        loading: false,
        errMsg: '',
        isDisabled: state.isDisabled,
        currentPage: state.currentPage,
        showClearIcon: state.showClearIcon,
        age: state.age,
        gender: state.gender,
        imageUrl: state.imageUrl,
        username: state.username,
        email: state.email,
        phoneNumber: state.phoneNumber,
        referCode: state.referCode,
        dob: state.dob,
        image: state.image,
        fullName: state.fullName,
      ));
    } catch (e) {
      emit(
        CreateProfileFailureState(
          loading: false,
          errMsg: e.toString(),
          isDisabled: state.isDisabled,
          currentPage: state.currentPage,
          showClearIcon: state.showClearIcon,
          age: state.age,
          gender: state.gender,
          imageUrl: state.imageUrl,
          username: state.username,
          email: state.email,
          phoneNumber: state.phoneNumber,
          referCode: state.referCode,
          dob: state.dob,
          image: state.image,
          fullName: state.fullName,
        ),
      );
    }
  }

  void _onboardingInitialPageEvent(OnboardingInitialPageEvent event, Emitter<OnboardingState> emit) {
    emit(getBlocState(currentPage: event.page));
  }

  void _createProfileEvent(CreateProfileEvent event, Emitter<OnboardingState> emit) {
    emit(getBlocState(fullName: event.name, dob: event.dob));
    sl<Navigation>().go(Routes.intro);
  }

  void _signUp(SignUpEvent event, Emitter<OnboardingState> emit) {
    emit(getBlocState(username: event.username, email: event.email, phoneNumber: event.phoneNumber, referCode: event.referCode));
    sl<Navigation>().go(Routes.createProfile);
  }

  void _updateDisableState(UpdateDisableStateEvent event, Emitter<OnboardingState> emit) {
    emit(getBlocState(isDisabled: event.isDisabled));
  }

  void _nextPage(NextPageEvent event, Emitter<OnboardingState> emit) {
    if (state.currentPage < 2) {
      emit(getBlocState(currentPage: state.currentPage + 1));
    }
  }

  void _backPage(BackPageEvent event, Emitter<OnboardingState> emit) {
    if (state.currentPage > 0) {
      emit(getBlocState(currentPage: state.currentPage - 1));
    }
  }

  void _updatePage(UpdatePageEvent event, Emitter<OnboardingState> emit) {
    emit(getBlocState(currentPage: event.page));
  }

  void _showClearIcon(ShowClearIcon event, Emitter<OnboardingState> emit) {
    emit(getBlocState(showClearIcon: event.showClearIcon));
  }

  void _selectAge(SelectAge event, Emitter<OnboardingState> emit) {
    var disabled = event.age.isEmpty;
    emit(getBlocState(age: event.age, isDisabled: disabled));
  }

  void _selectGender(SelectGender event, Emitter<OnboardingState> emit) {
    var disabled = event.gender.isEmpty;
    emit(getBlocState(gender: event.gender, isDisabled: disabled));
  }

  void _resetState(ResetStateEvent event, Emitter<OnboardingState> emit) {
    emit(OnboardingChangeState.initial());
  }

  /// this method used as state change
  OnboardingState getBlocState({
    bool? loading,
    String? errMsg,
    bool? isDisabled,
    int? currentPage,
    bool? showClearIcon,
    String? age,
    String? gender,
    String? imageUrl,
    String? username,
    String? email,
    String? phoneNumber,
    String? referCode,
    String? dob,
    String? fullName,
    String? image,
  }) {
    return OnboardingChangeState(
      image: image ?? state.image,
      loading: loading ?? state.loading,
      errMsg: errMsg ?? state.errMsg,
      isDisabled: isDisabled ?? state.isDisabled,
      currentPage: currentPage ?? state.currentPage,
      showClearIcon: showClearIcon ?? state.showClearIcon,
      age: age ?? state.age,
      gender: gender ?? state.gender,
      imageUrl: imageUrl ?? state.imageUrl,
      username: username ?? state.username,
      email: email ?? state.email,
      phoneNumber: phoneNumber ?? state.phoneNumber,
      referCode: referCode ?? state.referCode,
      dob: dob ?? state.dob,
      fullName: fullName ?? state.fullName,
    );
  }
}

/// bloc states
@immutable
abstract class OnboardingState {
  const OnboardingState({
    required this.loading,
    required this.errMsg,
    required this.isDisabled,
    required this.currentPage,
    required this.showClearIcon,
    required this.age,
    required this.gender,
    required this.imageUrl,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.referCode,
    required this.dob,
    required this.image,
    required this.fullName,
  });

  final bool loading;
  final String errMsg;
  final bool isDisabled;
  final int currentPage;
  final bool showClearIcon;
  final String age;
  final String gender;
  final String imageUrl;
  final String username;
  final String email;
  final String phoneNumber;
  final String referCode;
  final String fullName;
  final String dob;
  final String image;
}

class OnboardingChangeState extends OnboardingState {
  const OnboardingChangeState({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.image,
    required super.dob,
    required super.fullName,
  });

  factory OnboardingChangeState.initial() {
    return const OnboardingChangeState(
      loading: false,
      errMsg: '',
      isDisabled: true,
      currentPage: 0,
      showClearIcon: false,
      age: '',
      gender: '',
      imageUrl: '',
      username: '',
      email: '',
      phoneNumber: '',
      referCode: '',
      dob: '',
      image: '',
      fullName: '',
    );
  }
}

class CreateProfileSuccessState extends OnboardingState {
  const CreateProfileSuccessState({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.dob,
    required super.fullName,
    required super.image,
  });
}

class ImagePickErrorState extends OnboardingState {
  const ImagePickErrorState({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.dob,
    required super.image,
    required super.fullName,
  });
}

class UpdateBioSuccessState extends OnboardingState {
  const UpdateBioSuccessState({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.dob,
    required super.image,
    required super.fullName,
  });
}

class UpdateBioFailedState extends OnboardingState {
  const UpdateBioFailedState({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.dob,
    required super.image,
    required super.fullName,
  });
}

class CreateProfileFailureState extends OnboardingState {
  const CreateProfileFailureState({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.dob,
    required super.fullName,
    required super.image,
  });
}

class ProfilePicSuccess extends OnboardingState {
  const ProfilePicSuccess({
    required super.loading,
    required super.errMsg,
    required super.isDisabled,
    required super.currentPage,
    required super.showClearIcon,
    required super.age,
    required super.gender,
    required super.imageUrl,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.referCode,
    required super.dob,
    required super.fullName,
    required super.image,
  });
}

/// bloc events
@immutable
abstract class OnboardingEvent {}

class UpdateDisableStateEvent extends OnboardingEvent {
  final bool isDisabled;

  UpdateDisableStateEvent({required this.isDisabled});
}

class NextPageEvent extends OnboardingEvent {}

class BackPageEvent extends OnboardingEvent {}

class ShowClearIcon extends OnboardingEvent {
  final bool showClearIcon;

  ShowClearIcon({required this.showClearIcon});
}

class UpdatePageEvent extends OnboardingEvent {
  final int page;

  UpdatePageEvent({required this.page});
}

class SelectAge extends OnboardingEvent {
  final String age;

  SelectAge({required this.age});
}

class SelectGender extends OnboardingEvent {
  final String gender;

  SelectGender({required this.gender});
}

class CreateAccountApiEvent extends OnboardingEvent {
  final String token;

  CreateAccountApiEvent({required this.token});
}

class SignUpEvent extends OnboardingEvent {
  final String username;
  final String email;
  final String phoneNumber;
  final String referCode;

  SignUpEvent({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.referCode,
  });
}

class ResetStateEvent extends OnboardingEvent {}

class CreateProfileEvent extends OnboardingEvent {
  final String name;
  final String dob;

  CreateProfileEvent({
    required this.name,
    required this.dob,
  });
}

class OnboardingInitialPageEvent extends OnboardingEvent {
  final int page;

  OnboardingInitialPageEvent({required this.page});
}

class AddImageEvent extends OnboardingEvent {
  final String token;
  final String name, gender, age, dateofBirth;

  AddImageEvent({
    required this.token,
    this.name = '',
    this.gender = '',
    this.age = '',
    this.dateofBirth = '',
  });
}

class UpdateBioEvent extends OnboardingEvent {
  final String token;
  final String name, gender, age, dateofBirth, bio;

  UpdateBioEvent({
    required this.token,
    this.name = '',
    this.gender = '',
    this.age = '',
    this.dateofBirth = '',
    this.bio = '',
  });
}

class AddProfilePictureEvent extends OnboardingEvent {
  final String token;

  AddProfilePictureEvent({required this.token});
}

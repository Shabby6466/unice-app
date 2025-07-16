import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unice_app/core/network_calls/dio_wrapper/index.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/module/auth/usecase/register_use_case.dart';

@immutable
abstract class RegisterState {
  final bool loading, togglePassword, toggleConfirmPassword;
  final String errMsg, username, email, phoneNo, password, confirmPassword, referralCode;
  final String token;

  const RegisterState({
    required this.token,
    required this.errMsg,
    required this.loading,
    required this.username,
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.togglePassword,
    required this.toggleConfirmPassword,
    required this.confirmPassword,
    required this.referralCode,
  });
}

class RegisterChangeState extends RegisterState {
  const RegisterChangeState({
    required super.loading,
    required super.token,
    required super.errMsg,
    required super.username,
    required super.email,
    required super.phoneNo,
    required super.password,
    required super.confirmPassword,
    required super.referralCode,
    super.togglePassword = false,
    super.toggleConfirmPassword = false,
  });

  factory RegisterChangeState.initial() => const RegisterChangeState(
        loading: false,
        token: '',
        errMsg: '',
        username: '',
        email: '',
        phoneNo: '',
        password: '',
        confirmPassword: '',
        toggleConfirmPassword: true,
        togglePassword: true,
        referralCode: '',
      );
}

class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState({
    required super.loading,
    required super.errMsg,
    required super.username,
    required super.email,
    required super.phoneNo,
    required super.token,
    required super.password,
    required super.referralCode,
    required super.confirmPassword,
    super.togglePassword = true,
    super.toggleConfirmPassword = true,
  });
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({
    required this.registerUseCase,
  }) : super(RegisterChangeState.initial()) {
    on<ChangeUsernameEvent>(_changeUsernameEvent);
    on<ChangeEmailEvent>(_changeEmailEvent);
    on<ChangePhoneNoEvent>(_changePhoneNoEvent);
    on<ChangePasswordEvent>(_changePasswordEvent);
    on<ChangeConfirmPasswordEvent>(_changeConfirmPasswordEvent);
    on<TogglePasswordEvent>(_togglePasswordEvent);
    on<ToggleConfirmPasswordEvent>(_toggleConfirmPasswordEvent);
    on<RegisterApiEvent>(_registerApiEvent);
    on<ClearRegisterStateEvent>(_resetState);
    on<ChangeReferralCodeEvent>(_changeReferralCodeEvent);
    on<RegisterFieldCheckEvent>(_registerFieldCheck);
  }

  void _registerFieldCheck(RegisterFieldCheckEvent event, Emitter<RegisterState> emit) {
    if (event.password != event.confirmPassword) {
      emit(RegisterFieldIncorrectState(
        token: state.token,
        loading: state.loading,
        errMsg: 'Your password do not match',
        username: state.username,
        email: state.email,
        phoneNo: state.phoneNo,
        password: state.password,
        confirmPassword: state.confirmPassword,
        referralCode: state.referralCode,
      ));
    } else if (event.password.length < 8 || event.confirmPassword.length < 8) {
      emit(RegisterFieldIncorrectState(
        token: state.token,
        loading: state.loading,
        errMsg: 'Password length must be greater than 8',
        username: state.username,
        email: state.email,
        phoneNo: state.phoneNo,
        password: state.password,
        confirmPassword: state.confirmPassword,
        referralCode: state.referralCode,
      ));
    } else if (Utility.isValidPassword(event.password, 8)) {
      emit(RegisterFieldIncorrectState(
        token: state.token,
        loading: state.loading,
        errMsg: 'Password must contain alphanumeric and special character values mentioned below',
        username: state.username,
        email: state.email,
        phoneNo: state.phoneNo,
        password: state.password,
        confirmPassword: state.confirmPassword,
        referralCode: state.referralCode,
      ));
    } else {
      emit(RegisterFieldCorrectState(
        token: state.token,
        loading: state.loading,
        errMsg: '',
        username: state.username,
        email: state.email,
        phoneNo: state.phoneNo,
        password: state.password,
        confirmPassword: state.confirmPassword,
        referralCode: state.referralCode,
      ));
    }
  }

  void _resetState(ClearRegisterStateEvent event, Emitter<RegisterState> emit) {
    emit(RegisterChangeState.initial());
  }

  void _registerApiEvent(RegisterApiEvent event, Emitter<RegisterState> emit) async {
    try {
      Utility.closeKeyboard();
      emit(getBlocState(loading: true));
      var res = await registerUseCase.call(RegisterInput(
        email: state.email,
        username: state.username,
        password: state.password,
        referralCode: state.referralCode,
        token: '',
        gender: 'male',
        phoneNumber: state.phoneNo,
        age: 18,
        friendRecommendationEnabled: true,
      ));
      var token = res.token;
      emit(RegisterSuccessState(
        token: token,
        loading: false,
        errMsg: '',
        username: state.username,
        email: state.email,
        phoneNo: state.phoneNo,
        password: state.password,
        confirmPassword: state.confirmPassword,
        referralCode: state.referralCode,
      ));
      // emit(getBlocState(loading: false));
    } on DefaultFailure catch (e) {
      emit(RegisterFailState(
        token: state.token,
        loading: false,
        errMsg: e.message,
        username: state.username,
        email: state.email,
        phoneNo: state.phoneNo,
        password: state.password,
        confirmPassword: state.confirmPassword,
        referralCode: state.referralCode,
      ));
    }
  }

  void _changeUsernameEvent(ChangeUsernameEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(username: event.value));
  }

  void _changeReferralCodeEvent(ChangeReferralCodeEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(referralCode: event.value));
  }

  void _changeEmailEvent(ChangeEmailEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(email: event.value));
  }

  void _changePhoneNoEvent(ChangePhoneNoEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(phoneNo: event.value));
  }

  void _changePasswordEvent(ChangePasswordEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(password: event.value));
  }

  void _changeConfirmPasswordEvent(ChangeConfirmPasswordEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(confirmPassword: event.value));
  }

  void _togglePasswordEvent(TogglePasswordEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(togglePassword: !state.togglePassword));
  }

  void _toggleConfirmPasswordEvent(ToggleConfirmPasswordEvent event, Emitter<RegisterState> emit) {
    emit(getBlocState(toggleConfirmPassword: !state.toggleConfirmPassword));
  }

  RegisterState getBlocState({
    bool? loading,
    String? errMsg,
    String? username,
    String? email,
    String? phoneNo,
    String? password,
    String? confirmPassword,
    bool? togglePassword,
    bool? toggleConfirmPassword,
    String? token,
    String? referralCode,
  }) {
    return RegisterChangeState(
      token: token ?? state.token,
      loading: loading ?? state.loading,
      errMsg: errMsg ?? state.errMsg,
      username: username ?? state.username,
      email: email ?? state.email,
      phoneNo: phoneNo ?? state.phoneNo,
      password: password ?? state.password,
      confirmPassword: confirmPassword ?? state.confirmPassword,
      togglePassword: togglePassword ?? state.togglePassword,
      toggleConfirmPassword: toggleConfirmPassword ?? state.toggleConfirmPassword,
      referralCode: referralCode ?? state.referralCode,
    );
  }
}

class RegisterFailState extends RegisterState {
  const RegisterFailState({
    required super.loading,
    required super.errMsg,
    required super.token,
    required super.username,
    required super.email,
    required super.phoneNo,
    required super.password,
    required super.confirmPassword,
    required super.referralCode,
    super.togglePassword = true,
    super.toggleConfirmPassword = true,
  });
}

class RegisterFieldCorrectState extends RegisterState {
  const RegisterFieldCorrectState({
    required super.loading,
    required super.errMsg,
    required super.username,
    required super.email,
    required super.phoneNo,
    required super.token,
    required super.password,
    required super.referralCode,
    required super.confirmPassword,
    super.togglePassword = true,
    super.toggleConfirmPassword = true,
  });
}

class RegisterFieldIncorrectState extends RegisterState {
  const RegisterFieldIncorrectState({
    required super.loading,
    required super.errMsg,
    required super.username,
    required super.email,
    required super.phoneNo,
    required super.token,
    required super.password,
    required super.referralCode,
    required super.confirmPassword,
    super.togglePassword = true,
    super.toggleConfirmPassword = true,
  });
}

@immutable
abstract class RegisterEvent {}

class ChangeUsernameEvent extends RegisterEvent {
  final String value;

  ChangeUsernameEvent({required this.value});
}

class ChangeEmailEvent extends RegisterEvent {
  final String value;

  ChangeEmailEvent({required this.value});
}

class ChangePhoneNoEvent extends RegisterEvent {
  final String value;

  ChangePhoneNoEvent({required this.value});
}

class ChangePasswordEvent extends RegisterEvent {
  final String value;

  ChangePasswordEvent({required this.value});
}

class ChangeConfirmPasswordEvent extends RegisterEvent {
  final String value;

  ChangeConfirmPasswordEvent({required this.value});
}

class TogglePasswordEvent extends RegisterEvent {}

class ToggleConfirmPasswordEvent extends RegisterEvent {}

class RegisterApiEvent extends RegisterEvent {}

class ChangeReferralCodeEvent extends RegisterEvent {
  final String value;

  ChangeReferralCodeEvent({required this.value});
}

class RegisterFieldCheckEvent extends RegisterEvent {
  final String confirmPassword;
  final String password;

  RegisterFieldCheckEvent({
    required this.confirmPassword,
    required this.password,
  });
}

class ClearRegisterStateEvent extends RegisterEvent {}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unice_app/core/network_calls/dio_wrapper/index.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/module/auth/usecase/password/change_password_use_case.dart';
import 'package:unice_app/module/auth/usecase/password/forgot_password_use_case.dart';
import 'package:unice_app/module/auth/usecase/password/reset_password_use_case.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  PasswordBloc({
    required this.resetPasswordUseCase,
    required this.forgotPasswordUseCase,
    required this.changePasswordUseCase,
  }) : super(PasswordChangeState.initial()) {
    on<ChangeEmailEvent>(_changeEmail);
    on<ResetPasswordEmailSentEvent>(_onResetPasswordEmailSentEvent);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibilityEvent);
    on<TogglePassword2VisibilityEvent>(_onTogglePassword2VisibilityEvent);
    on<ChangePassEvent>(_onChangePassEvent);
    on<ChangePass2Event>(_onChangePass2Event);
    on<SetPasswordEvent>(_onSetPasswordEvent);
    on<ChangePassApiEvent>(_onChangePassApiEvent);
    on<ChangeNewPassword>(_onChangeNewPassword);
    on<ChangeCurrentPassword>(_onChangeCurrentPassword);
  }

  FutureOr<void> _onChangeNewPassword(ChangeNewPassword event, Emitter<PasswordState> emit) {
    emit(getBlocState(newPassword: event.val));
  }

  FutureOr<void> _onChangeCurrentPassword(ChangeCurrentPassword event, Emitter<PasswordState> emit) {
    emit(getBlocState(currentPassword: event.val));
  }

  void _onChangePassApiEvent(ChangePassApiEvent event, Emitter<PasswordState> emit) async {
    try {
      Utility.closeKeyboard();
      emit(getBlocState(loading: true));
      await changePasswordUseCase.call(ChangePasswordInput(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
        token: '',
      ));
      emit(ChangePasswordSetState(
          errMsg: '',
          obscurePassword: state.obscurePassword,
          loading: false,
          obscurePassword2: state.obscurePassword2,
          email: state.email,
          forgotPasswordOutput: state.forgotPasswordOutput,
          pass: state.pass,
          pass2: state.pass2,
          newPassword: '',
          currentPassword: ''));
    } on DefaultFailure catch (e) {
      emit(ChangePasswordErrorState(
          errMsg: '',
          obscurePassword: state.obscurePassword,
          loading: false,
          obscurePassword2: state.obscurePassword2,
          email: state.email,
          forgotPasswordOutput: state.forgotPasswordOutput,
          pass: state.pass,
          pass2: state.pass2,
          newPassword: state.newPassword,
          currentPassword: state.currentPassword));
    }
  }

  void _onSetPasswordEvent(SetPasswordEvent event, Emitter<PasswordState> emit) async {
    try {
      Utility.closeKeyboard();
      emit(getBlocState(loading: true));
      await resetPasswordUseCase.call(ResetPasswordInput(
        code: state.forgotPasswordOutput.data.code,
        password: state.pass,
        token: '',
      ));
      emit(PasswordSetState(
        errMsg: '',
        obscurePassword: true,
        loading: false,
        obscurePassword2: true,
        newPassword: state.newPassword,
        currentPassword: state.currentPassword,
        email: '',
        forgotPasswordOutput: state.forgotPasswordOutput,
        pass: '',
        pass2: '',
      ));
    } on DefaultFailure catch (e) {
      emit(getBlocState(loading: false, errMsg: e.message));
    }
  }

  void _onChangePass2Event(ChangePass2Event event, Emitter<PasswordState> emit) {
    emit(getBlocState(pass2: event.val));
  }

  void _onChangePassEvent(ChangePassEvent event, Emitter<PasswordState> emit) {
    emit(getBlocState(pass: event.val));
  }

  void _onTogglePassword2VisibilityEvent(TogglePassword2VisibilityEvent event, Emitter<PasswordState> emit) {
    emit(getBlocState(obscurePassword2: !state.obscurePassword2));
  }

  void _onTogglePasswordVisibilityEvent(TogglePasswordVisibilityEvent event, Emitter<PasswordState> emit) {
    emit(getBlocState(obscurePassword: !state.obscurePassword));
  }

  void _onResetPasswordEmailSentEvent(ResetPasswordEmailSentEvent event, Emitter<PasswordState> emit) async {
    try {
      Utility.closeKeyboard();
      emit(getBlocState(loading: true));
      var res = await forgotPasswordUseCase.call(ForgotPasswordInput(email: state.email));

      emit(EmailSentState(
        loading: false,
        errMsg: '',
        email: state.email,
        forgotPasswordOutput: res,
        obscurePassword2: state.obscurePassword2,
        obscurePassword: state.obscurePassword,
        pass2: state.pass2,
        pass: state.pass,
        newPassword: state.newPassword,
        currentPassword: state.currentPassword,
      ));
    } on DefaultFailure catch (e) {
      emit(getBlocState(loading: false, errMsg: e.message));
    }
  }

  void _changeEmail(ChangeEmailEvent event, Emitter<PasswordState> emit) {
    emit(getBlocState(email: event.email));
  }

  PasswordState getBlocState({
    bool? loading,
    bool? obscurePassword,
    bool? obscurePassword2,
    String? errMsg,
    String? pass,
    String? pass2,
    String? email,
    String? newPassword,
    String? currentPassword,
    ForgotPasswordOutput? forgotPasswordOutput,
  }) {
    return PasswordChangeState(
      currentPassword: currentPassword ?? state.currentPassword,
      newPassword: newPassword ?? state.newPassword,
      loading: loading ?? state.loading,
      errMsg: errMsg ?? state.errMsg,
      pass: pass ?? state.pass,
      pass2: pass2 ?? state.pass2,
      obscurePassword2: obscurePassword2 ?? state.obscurePassword2,
      email: email ?? state.email,
      obscurePassword: obscurePassword ?? state.obscurePassword,
      forgotPasswordOutput: forgotPasswordOutput ?? state.forgotPasswordOutput,
    );
  }
}

@immutable
abstract class PasswordState {
  final bool loading, obscurePassword, obscurePassword2;
  final String errMsg, email, pass, pass2, currentPassword, newPassword;
  final ForgotPasswordOutput forgotPasswordOutput;

  const PasswordState({
    required this.errMsg,
    required this.obscurePassword,
    required this.loading,
    required this.obscurePassword2,
    required this.email,
    required this.forgotPasswordOutput,
    required this.pass,
    required this.pass2,
    required this.newPassword,
    required this.currentPassword,
  });
}

class PasswordChangeState extends PasswordState {
  const PasswordChangeState({
    required super.loading,
    required super.errMsg,
    required super.email,
    required super.obscurePassword,
    required super.obscurePassword2,
    required super.forgotPasswordOutput,
    required super.pass,
    required super.pass2,
    required super.newPassword,
    required super.currentPassword,
  });

  factory PasswordChangeState.initial() => PasswordChangeState(
        obscurePassword: true,
        obscurePassword2: true,
        loading: false,
        errMsg: '',
        email: '',
        pass: '',
        pass2: '',
        forgotPasswordOutput: ForgotPasswordOutput.initial(),
        currentPassword: '',
        newPassword: '',
      );
}

class EmailSentState extends PasswordState {
  const EmailSentState({
    required super.loading,
    required super.errMsg,
    required super.obscurePassword,
    required super.obscurePassword2,
    required super.email,
    required super.forgotPasswordOutput,
    required super.pass,
    required super.pass2,
    required super.newPassword,
    required super.currentPassword,
  });
}

class PasswordSetState extends PasswordState {
  const PasswordSetState(
      {required super.errMsg,
      required super.obscurePassword,
      required super.loading,
      required super.obscurePassword2,
      required super.email,
      required super.forgotPasswordOutput,
      required super.pass,
      required super.pass2,
      required super.newPassword,
      required super.currentPassword});
}

class ChangePasswordSetState extends PasswordState {
  const ChangePasswordSetState(
      {required super.errMsg,
      required super.obscurePassword,
      required super.loading,
      required super.obscurePassword2,
      required super.email,
      required super.forgotPasswordOutput,
      required super.pass,
      required super.pass2,
      required super.newPassword,
      required super.currentPassword});
}

class ChangePasswordErrorState extends PasswordState {
  const ChangePasswordErrorState(
      {required super.errMsg,
      required super.obscurePassword,
      required super.loading,
      required super.obscurePassword2,
      required super.email,
      required super.forgotPasswordOutput,
      required super.pass,
      required super.pass2,
      required super.newPassword,
      required super.currentPassword});
}

@immutable
abstract class PasswordEvent {}

class ChangeEmailEvent extends PasswordEvent {
  final String email;

  ChangeEmailEvent({required this.email});
}

class ResetPasswordEmailSentEvent extends PasswordEvent {}

class TogglePasswordVisibilityEvent extends PasswordEvent {}

class TogglePassword2VisibilityEvent extends PasswordEvent {}

class ChangePassEvent extends PasswordEvent {
  final String val;

  ChangePassEvent({required this.val});
}

class ChangePass2Event extends PasswordEvent {
  final String val;

  ChangePass2Event({required this.val});
}

class SetPasswordEvent extends PasswordEvent {}

class ChangePassApiEvent extends PasswordEvent {}

class ChangeCurrentPassword extends PasswordEvent {
  final String val;

  ChangeCurrentPassword({required this.val});
}

class ChangeNewPassword extends PasswordEvent {
  final String val;

  ChangeNewPassword({required this.val});
}

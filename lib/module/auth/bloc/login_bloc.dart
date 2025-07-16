import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/network_calls/dio_wrapper/index.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/module/auth/usecase/apple_login_use_case.dart';
import 'package:unice_app/module/auth/usecase/get_token_usecase.dart';
import 'package:unice_app/module/auth/usecase/google_auth_use_case.dart';
import 'package:unice_app/module/auth/usecase/login_use_case.dart';
import 'package:unice_app/module/auth/usecase/resend_email_usecase.dart';
import 'package:unice_app/module/auth/usecase/save_token_use_case.dart';
import 'package:unice_app/module/auth/usecase/verify_email_code_usecase.dart';
import 'package:unice_app/module/intro/usecases/get_profile_usecase.dart';
import 'package:unice_app/module/onboarding/usecase/login_usecase.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUseCase;
  final GoogleAuthUseCase googleAuthUseCase;
  final LoginEmailUseCase loginEmailUseCase;
  final SaveTokenUseCase saveTokenUseCase;
  final GetTokenUseCase getTokenUseCase;
  final GetProfileUseCase getProfileUseCase;
  final AppleLoginUseCase appleLoginUseCase;
  final VerifyEmailCodeUseCase verifyEmailCodeUseCase;
  final ResendEmailUsecase resendEmailUsecase;

  LoginBloc({
    required this.loginUseCase,
    required this.saveTokenUseCase,
    required this.googleAuthUseCase,
    required this.loginEmailUseCase,
    required this.getProfileUseCase,
    required this.getTokenUseCase,
    required this.appleLoginUseCase,
    required this.verifyEmailCodeUseCase,
    required this.resendEmailUsecase,
  }) : super(LoginChangeState.initial()) {
    on<GoogleAuthenticateEvent>(_googleLoginApiEvent);
    on<ChangeLoginEmailEvent>(_changeEmailEvent);
    on<ChangeLoginPasswordEvent>(_changePasswordEvent);
    on<LoginEmailEvent>(_loginEmailEvent);
    on<GetProfileEvent>(_getProfileEvent);
    on<LoginClearStateEvent>(clearState);
    on<GetTokenEvent>(_getTokenEvent);
    on<ChangeObscureTextEvent>(_changeObscureTextEvent);
    on<AppleAuthenticateEvent>(_onAppleAuthenticateEvent);
    on<VerifyEmailOtpEvent>(_verifyEmailOtp);
    on<ResendEmailOtpEvent>(_resendEmailOtp);
  }

  Future<void> _resendEmailOtp(ResendEmailOtpEvent event, Emitter<LoginState> emit) async {
    emit(getBlocState(loading: true, errMsg: ''));
    try {
      final res = await resendEmailUsecase.call(ResendEmailInput(email: state.email, token: ''));
      if (res) {
        emit(getBlocState(
          loading: false,
          errMsg: '',
        ));
      }
    } on DefaultFailure catch (e) {
      emit(getBlocState(errMsg: e.message, loading: false));
    }
  }

  Future<void> _verifyEmailOtp(VerifyEmailOtpEvent event, Emitter<LoginState> emit) async {
    emit(getBlocState(loading: true, errMsg: ''));
    try {
      final res = await verifyEmailCodeUseCase.call(VerifyEmailInput(email: state.email, code: event.code, token: ''));
      if (res) {
        emit(VerifiedEmailOtpSuccess(
          loading: false,
          errMsg: '',
          profileOutput: state.profileOutput,
          bio: state.bio,
          email: state.email,
          obscureText: state.obscureText,
          token: state.token,
          password: state.password,
          username: state.username,
          translationEnabled: state.translationEnabled,
          totalRewardPoints: state.totalRewardPoints,
          profilePicture: state.profilePicture,
          dob: state.dob,
          googleAuthOutputs: state.googleAuthOutputs,
          walletAddress: state.walletAddress,
          userId: state.userId,
        ));
      }
    } on DefaultFailure catch (e) {
      emit(VerifiedEmailOtpFailed(
        loading: false,
        errMsg: e.message,
        profileOutput: state.profileOutput,
        bio: state.bio,
        email: state.email,
        obscureText: state.obscureText,
        token: state.token,
        password: state.password,
        username: state.username,
        translationEnabled: state.translationEnabled,
        totalRewardPoints: state.totalRewardPoints,
        profilePicture: state.profilePicture,
        dob: state.dob,
        googleAuthOutputs: state.googleAuthOutputs,
        walletAddress: state.walletAddress,
        userId: state.userId,
      ));
    }
  }

  void _onAppleAuthenticateEvent(AppleAuthenticateEvent event, Emitter<LoginState> emit) async {
    try {
      emit(getBlocState(loading: true));
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.rns.unice',
          redirectUri: Uri.parse('https://unice-app.firebaseapp.com/__/auth/handler'),
        ),
      );
      if (credential.authorizationCode.isNotEmpty) {
        debugPrint('IdentityToken: ${credential.identityToken}');
        debugPrint('AuthorizationCode: ${credential.authorizationCode}');
        debugPrint('userIdentifier: ${credential.userIdentifier}');
        var res = await appleLoginUseCase.call(
            AppleLoginInput(idToken: credential.identityToken ?? '', firstName: credential.givenName ?? '', lastName: credential.familyName ?? ''));
        emit(GoogleLoginSuccessState(
            loading: false,
            errMsg: state.errMsg,
            loggedIn: state.loggedIn,
            profileOutput: state.profileOutput,
            bio: state.bio,
            email: state.email,
            obscureText: state.obscureText,
            token: res.token,
            password: state.password,
            username: state.username,
            translationEnabled: state.translationEnabled,
            totalRewardPoints: state.totalRewardPoints,
            profilePicture: state.profilePicture,
            dob: state.dob,
            googleAuthOutputs: res,
            walletAddress: state.walletAddress,
            userId: state.userId));
      } else {
        sl<Logger>().w('Empty');
      }

      emit(getBlocState(loading: false));
    } on DefaultFailure catch (e) {
      emit(getBlocState(loading: false, errMsg: e.message));
    } on PlatformException catch (e) {
      emit(getBlocState(loading: false, errMsg: e.message));
    }
  }

  void _changeObscureTextEvent(ChangeObscureTextEvent event, Emitter<LoginState> emit) {
    emit(getBlocState(obscureText: !state.obscureText));
  }

  void clearState(LoginClearStateEvent event, Emitter<LoginState> emit) {
    emit(LoginChangeState.initial());
  }

  FutureOr<void> _loginEmailEvent(LoginEmailEvent event, Emitter<LoginState> emit) async {
    try {
      Utility.closeKeyboard();
      emit(getBlocState(loading: true));
      var res = await loginEmailUseCase.call(LoginInput(identifier: state.email, password: state.password));
      await saveTokenUseCase.call(res.token);
      emit(EmailLoginSuccessState(
          loading: false,
          googleAuthOutputs: state.googleAuthOutputs,
          errMsg: '',
          obscureText: state.obscureText,
          username: state.username,
          profilePicture: state.profilePicture,
          dob: state.dob,
          walletAddress: state.walletAddress,
          bio: state.bio,
          totalRewardPoints: state.totalRewardPoints,
          userId: state.userId,
          profileOutput: state.profileOutput,
          translationEnabled: state.translationEnabled,
          loggedIn: true,
          email: '',
          password: '',
          token: state.token));
    } on DefaultFailure catch (e) {
      emit(EmailLoginFailState(
          loading: false,
          errMsg: e.message,
          username: state.username,
          obscureText: state.obscureText,
          googleAuthOutputs: state.googleAuthOutputs,
          profilePicture: state.profilePicture,
          dob: state.dob,
          translationEnabled: state.translationEnabled,
          bio: state.bio,
          userId: state.userId,
          totalRewardPoints: state.totalRewardPoints,
          loggedIn: false,
          profileOutput: state.profileOutput,
          walletAddress: state.walletAddress,
          email: state.email,
          password: state.password,
          token: state.token));
    }
  }

  FutureOr<void> _getProfileEvent(GetProfileEvent event, Emitter<LoginState> emit) async {
    try {
      emit(getBlocState(loading: true));
      var res = await getProfileUseCase.call(NoParams());
      emit(GetProfileSuccessState(
        email: res.email,
        password: state.password,
        googleAuthOutputs: state.googleAuthOutputs,
        walletAddress: res.walletAddress,
        bio: res.profile.bio,
        token: state.token,
        profileOutput: res,
        obscureText: state.obscureText,
        loading: false,
        totalRewardPoints: res.totalRewardPoints,
        errMsg: '',
        username: res.username,
        userId: res.profile.userId,
        translationEnabled: res.profile.translationEnabled,
        loggedIn: true,
        profilePicture: res.profile.profilePicture,
        dob: res.profile.dateOfBirth,
      ));
    } on DefaultFailure catch (e) {
      emit(GetProfileFailState(
        errMsg: e.message,
        loading: false,
        email: state.email,
        password: state.password,
        googleAuthOutputs: state.googleAuthOutputs,
        bio: state.bio,
        token: state.token,
        loggedIn: false,
        obscureText: state.obscureText,
        translationEnabled: state.translationEnabled,
        profileOutput: state.profileOutput,
        walletAddress: state.walletAddress,
        totalRewardPoints: state.totalRewardPoints,
        username: state.username,
        profilePicture: state.profilePicture,
        dob: state.dob,
        userId: state.userId,
      ));
    }
  }

  void _getTokenEvent(GetTokenEvent event, Emitter<LoginState> emit) async {
    try {
      emit(getBlocState(loading: true));
      var res = await getTokenUseCase.call(NoParams());
      if (res.isEmpty) {
        emit(TokenNotFoundState(
          loading: false,
          obscureText: state.obscureText,
          errMsg: state.errMsg,
          profileOutput: state.profileOutput,
          bio: state.bio,
          googleAuthOutputs: state.googleAuthOutputs,
          email: state.email,
          totalRewardPoints: state.totalRewardPoints,
          password: state.password,
          walletAddress: state.walletAddress,
          translationEnabled: state.translationEnabled,
          loggedIn: state.loggedIn,
          token: state.token,
          username: state.username,
          profilePicture: state.profilePicture,
          dob: state.dob,
          userId: state.userId,
        ));
      } else {
        emit(TokenFoundState(
          loading: false,
          obscureText: state.obscureText,
          errMsg: state.errMsg,
          profileOutput: state.profileOutput,
          email: state.email,
          password: state.password,
          loggedIn: state.loggedIn,
          googleAuthOutputs: state.googleAuthOutputs,
          bio: state.bio,
          token: res,
          totalRewardPoints: state.totalRewardPoints,
          username: state.username,
          translationEnabled: state.translationEnabled,
          profilePicture: state.profilePicture,
          walletAddress: state.walletAddress,
          dob: state.dob,
          userId: state.userId,
        ));
      }
    } on DefaultFailure catch (e) {
      emit(TokenNotFoundState(
          loading: false,
          profileOutput: state.profileOutput,
          googleAuthOutputs: state.googleAuthOutputs,
          errMsg: e.message,
          email: state.email,
          password: state.password,
          loggedIn: state.loggedIn,
          bio: state.bio,
          totalRewardPoints: state.totalRewardPoints,
          token: state.token,
          obscureText: state.obscureText,
          username: state.username,
          walletAddress: state.walletAddress,
          translationEnabled: state.translationEnabled,
          profilePicture: state.profilePicture,
          dob: state.dob,
          userId: state.userId));
    }
  }

  void _changeEmailEvent(ChangeLoginEmailEvent event, Emitter<LoginState> emit) {
    emit(getBlocState(email: event.value));
  }

  void _changePasswordEvent(ChangeLoginPasswordEvent event, Emitter<LoginState> emit) {
    emit(getBlocState(password: event.value));
  }

  /// this method is used to call login useCase
  FutureOr<void> _googleLoginApiEvent(GoogleAuthenticateEvent event, Emitter<LoginState> emit) async {
    try {
      emit(getBlocState(loading: true));
      var res = await loginUseCase.call(NoParams());
      if (res != null) {
        var result = await googleAuthUseCase.call(GoogleAuthInput(email: res.email));
        emit(GoogleLoginSuccessState(
            loading: false,
            errMsg: state.errMsg,
            loggedIn: state.loggedIn,
            profileOutput: state.profileOutput,
            bio: state.bio,
            email: state.email,
            obscureText: state.obscureText,
            token: result.token,
            password: state.password,
            username: state.username,
            translationEnabled: state.translationEnabled,
            totalRewardPoints: state.totalRewardPoints,
            profilePicture: state.profilePicture,
            dob: state.dob,
            googleAuthOutputs: result,
            walletAddress: state.walletAddress,
            userId: state.userId));
      } else {
        emit(getBlocState(loading: false));
      }
    } on DefaultFailure catch (e) {
      emit(getBlocState(errMsg: e.message, loading: false, loggedIn: false));
    }
  }

  // this method used as state change
  LoginState getBlocState({
    bool? loading,
    String? errMsg,
    String? email,
    String? password,
    ProfileOutput? profileOutput,
    bool? loggedIn,
    String? token,
    String? username,
    int? totalRewardPoints,
    String? profilePicture,
    String? dob,
    String? walletAddress,
    String? userId,
    bool? translationEnabled,
    bool? obscureText,
    String? bio,
    GoogleAuthOutputs? googleAuthOutputs,
  }) {
    return LoginChangeState(
      email: email ?? state.email,
      profileOutput: profileOutput ?? state.profileOutput,
      password: password ?? state.password,
      totalRewardPoints: totalRewardPoints ?? state.totalRewardPoints,
      loading: loading ?? state.loading,
      errMsg: errMsg ?? state.errMsg,
      loggedIn: loggedIn ?? state.loggedIn,
      token: token ?? state.token,
      bio: bio ?? state.bio,
      walletAddress: walletAddress ?? state.walletAddress,
      username: username ?? state.username,
      profilePicture: profilePicture ?? state.profilePicture,
      dob: dob ?? state.dob,
      translationEnabled: translationEnabled ?? state.translationEnabled,
      userId: userId ?? state.userId,
      obscureText: obscureText ?? state.obscureText,
      googleAuthOutputs: googleAuthOutputs ?? state.googleAuthOutputs,
    );
  }
}

/// states of the bloc
@immutable
abstract class LoginState {
  const LoginState({
    required this.loading,
    required this.errMsg,
    required this.totalRewardPoints,
    required this.email,
    required this.password,
    required this.walletAddress,
    required this.token,
    required this.bio,
    required this.profileOutput,
    this.loggedIn = false,
    required this.username,
    required this.profilePicture,
    required this.dob,
    required this.userId,
    required this.translationEnabled,
    required this.googleAuthOutputs,
    required this.obscureText,
  });

  final bool loading, obscureText;
  final String errMsg, email, password;
  final bool loggedIn;
  final ProfileOutput profileOutput;
  final String token;
  final String username;
  final String? walletAddress;
  final int totalRewardPoints;
  final String profilePicture;
  final String bio;
  final String dob;
  final String userId;
  final bool translationEnabled;
  final GoogleAuthOutputs googleAuthOutputs;
}

class LoginChangeState extends LoginState {
  const LoginChangeState({
    required super.loading,
    required super.errMsg,
    required super.loggedIn,
    required super.bio,
    required super.walletAddress,
    required super.totalRewardPoints,
    required super.email,
    required super.password,
    required super.profileOutput,
    required super.obscureText,
    required super.token,
    required super.translationEnabled,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
    required super.googleAuthOutputs,
  });

  factory LoginChangeState.initial() => LoginChangeState(
        loading: false,
        errMsg: '',
        loggedIn: false,
        obscureText: true,
        walletAddress: '',
        email: '',
        totalRewardPoints: 0,
        profileOutput: ProfileOutput.initial(),
        password: '',
        token: '',
        bio: '',
        username: '',
        profilePicture: '',
        dob: '',
        userId: '',
        translationEnabled: false,
        googleAuthOutputs: GoogleAuthOutputs.initial(),
      );
}

class PasscodeMatchState extends LoginState {
  const PasscodeMatchState({
    required super.loading,
    required super.profileOutput,
    required super.errMsg,
    required super.walletAddress,
    required super.bio,
    required super.email,
    required super.password,
    required super.token,
    required super.totalRewardPoints,
    required super.username,
    required super.profilePicture,
    required super.obscureText,
    required super.translationEnabled,
    required super.dob,
    required super.userId,
    required super.googleAuthOutputs,
  });
}

class VerifiedEmailOtpSuccess extends LoginState {
  const VerifiedEmailOtpSuccess({
    required super.loading,
    required super.profileOutput,
    required super.errMsg,
    required super.walletAddress,
    required super.bio,
    required super.email,
    required super.password,
    required super.token,
    required super.totalRewardPoints,
    required super.username,
    required super.profilePicture,
    required super.obscureText,
    required super.translationEnabled,
    required super.dob,
    required super.userId,
    required super.googleAuthOutputs,
  });
}

class VerifiedEmailOtpFailed extends LoginState {
  const VerifiedEmailOtpFailed({
    required super.loading,
    required super.profileOutput,
    required super.errMsg,
    required super.walletAddress,
    required super.bio,
    required super.email,
    required super.password,
    required super.token,
    required super.totalRewardPoints,
    required super.username,
    required super.profilePicture,
    required super.obscureText,
    required super.translationEnabled,
    required super.dob,
    required super.userId,
    required super.googleAuthOutputs,
  });
}

class GetProfileSuccessState extends LoginState {
  const GetProfileSuccessState({
    required super.loading,
    required super.errMsg,
    required super.bio,
    required super.totalRewardPoints,
    required super.profileOutput,
    required super.obscureText,
    required super.email,
    required super.translationEnabled,
    required super.googleAuthOutputs,
    required super.password,
    required super.token,
    required super.username,
    required super.loggedIn,
    required super.profilePicture,
    required super.dob,
    required super.walletAddress,
    required super.userId,
  });
}

class GetProfileFailState extends LoginState {
  const GetProfileFailState({
    required super.loading,
    required super.errMsg,
    required super.profileOutput,
    required super.totalRewardPoints,
    required super.email,
    required super.obscureText,
    required super.password,
    required super.token,
    required super.bio,
    required super.loggedIn,
    required super.translationEnabled,
    required super.googleAuthOutputs,
    required super.walletAddress,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
  });
}

class PasscodeNotMatchState extends LoginState {
  const PasscodeNotMatchState({
    required super.loading,
    required super.errMsg,
    required super.profileOutput,
    required super.email,
    required super.bio,
    required super.password,
    required super.walletAddress,
    required super.obscureText,
    required super.totalRewardPoints,
    required super.token,
    required super.username,
    required super.translationEnabled,
    required super.profilePicture,
    required super.googleAuthOutputs,
    required super.dob,
    required super.userId,
  });
}

class EmailLoginFailState extends LoginState {
  const EmailLoginFailState({
    required super.loading,
    required super.errMsg,
    required super.obscureText,
    required super.profileOutput,
    required super.bio,
    required super.loggedIn,
    required super.totalRewardPoints,
    required super.email,
    required super.token,
    required super.password,
    required super.walletAddress,
    required super.translationEnabled,
    required super.googleAuthOutputs,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
  });
}

class TokenFoundState extends LoginState {
  const TokenFoundState({
    required super.loading,
    required super.errMsg,
    required super.profileOutput,
    required super.bio,
    required super.obscureText,
    required super.loggedIn,
    required super.email,
    required super.totalRewardPoints,
    required super.googleAuthOutputs,
    required super.password,
    required super.token,
    required super.translationEnabled,
    required super.walletAddress,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
  });
}

class TokenNotFoundState extends LoginState {
  const TokenNotFoundState({
    required super.loading,
    required super.errMsg,
    required super.obscureText,
    required super.bio,
    required super.loggedIn,
    required super.totalRewardPoints,
    required super.googleAuthOutputs,
    required super.profileOutput,
    required super.translationEnabled,
    required super.walletAddress,
    required super.email,
    required super.password,
    required super.token,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
  });
}

class EmailLoginSuccessState extends LoginState {
  const EmailLoginSuccessState({
    required super.loading,
    required super.errMsg,
    required super.bio,
    required super.profileOutput,
    required super.email,
    required super.translationEnabled,
    required super.totalRewardPoints,
    required super.googleAuthOutputs,
    required super.obscureText,
    required super.password,
    required super.walletAddress,
    required super.loggedIn,
    required super.token,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
  });
}

class UserExistState extends LoginState {
  const UserExistState({
    required super.loading,
    required super.errMsg,
    required super.totalRewardPoints,
    required super.profileOutput,
    required super.translationEnabled,
    required super.obscureText,
    required super.email,
    required super.password,
    required super.token,
    required super.walletAddress,
    required super.bio,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
    required super.googleAuthOutputs,
  });
}

class UserNotExistState extends LoginState {
  const UserNotExistState({
    required super.loading,
    required super.bio,
    required super.profileOutput,
    required super.totalRewardPoints,
    required super.obscureText,
    required super.walletAddress,
    required super.errMsg,
    required super.email,
    required super.password,
    required super.translationEnabled,
    required super.token,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
    required super.googleAuthOutputs,
  });
}

class GoogleLoginSuccessState extends LoginState {
  const GoogleLoginSuccessState({
    required super.loading,
    required super.errMsg,
    required super.totalRewardPoints,
    required super.walletAddress,
    required super.obscureText,
    required super.loggedIn,
    required super.email,
    required super.bio,
    required super.username,
    required super.translationEnabled,
    required super.profilePicture,
    required super.dob,
    required super.userId,
    required super.password,
    required super.profileOutput,
    required super.token,
    required super.googleAuthOutputs,
  });
}

class GoogleLoginFailState extends LoginState {
  const GoogleLoginFailState({
    required super.loading,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.userId,
    required super.bio,
    required super.obscureText,
    required super.translationEnabled,
    required super.errMsg,
    required super.walletAddress,
    required super.loggedIn,
    required super.profileOutput,
    required super.totalRewardPoints,
    required super.email,
    required super.token,
    required super.password,
    required super.googleAuthOutputs,
  });
}

class BiometricAuthSuccessState extends LoginState {
  const BiometricAuthSuccessState({
    required super.loading,
    required super.username,
    required super.profilePicture,
    required super.dob,
    required super.translationEnabled,
    required super.bio,
    required super.userId,
    required super.obscureText,
    required super.totalRewardPoints,
    required super.errMsg,
    required super.email,
    required super.token,
    required super.walletAddress,
    required super.password,
    required super.profileOutput,
    required super.googleAuthOutputs,
  });
}

class BiometricAuthFailState extends LoginState {
  const BiometricAuthFailState({
    required super.loading,
    required super.totalRewardPoints,
    required super.errMsg,
    required super.walletAddress,
    required super.username,
    required super.bio,
    required super.profilePicture,
    required super.obscureText,
    required super.dob,
    required super.userId,
    required super.email,
    required super.password,
    required super.translationEnabled,
    required super.profileOutput,
    required super.token,
    required super.googleAuthOutputs,
  });
}

/// event of the bloc
@immutable
abstract class LoginEvent {}

class GoogleAuthenticateEvent extends LoginEvent {
  GoogleAuthenticateEvent();
}

class ChangeLoginEmailEvent extends LoginEvent {
  final String value;

  ChangeLoginEmailEvent({required this.value});
}

class GetTokenEvent extends LoginEvent {}

class ChangeLoginPasswordEvent extends LoginEvent {
  final String value;

  ChangeLoginPasswordEvent({required this.value});
}

class LoginEmailEvent extends LoginEvent {}

class GetProfileEvent extends LoginEvent {}

class LoginClearStateEvent extends LoginEvent {}

class ChangeObscureTextEvent extends LoginEvent {}

class AppleAuthenticateEvent extends LoginEvent {}

class VerifyEmailOtpEvent extends LoginEvent {
  final String code;

  VerifyEmailOtpEvent({required this.code});
}

class ResendEmailOtpEvent extends LoginEvent {}

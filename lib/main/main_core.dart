// coverage: false
// coverage:ignore-file

import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unice_app/app/my_app.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/firebase/firebase_notification_helper.dart';
import 'package:unice_app/core/utils/base_env.dart';
import 'package:unice_app/core/utils/bloc_observer/bloc_observer.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/module/auth/bloc/forgot_password_bloc.dart';
import 'package:unice_app/module/auth/usecase/password/change_password_use_case.dart';
import 'package:unice_app/module/auth/usecase/password/forgot_password_use_case.dart';
import 'package:unice_app/module/auth/usecase/password/reset_password_use_case.dart';
import 'package:unice_app/module/setting/blocs/setting_bloc.dart';
import 'package:unice_app/module/setting/usecase/language/get_language_use_case.dart';
import 'package:unice_app/module/setting/usecase/language/save_language_use_case.dart';
import 'package:unice_app/module/setting/usecase/logout_use_case.dart';
import 'package:unice_app/module/setting/usecase/theme/get_theme_use_case.dart';
import 'package:unice_app/module/setting/usecase/theme/set_theme_use_case.dart';
import 'package:unice_app/module/wallet/usecase/update_api_wallet_address_usecase.dart';

import '../core/services/voice_service/voice_service.dart';

/// this used to initialize all required parameters and start the app
void initMainCore({required String enviormentPath}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: enviormentPath);
  MyFirebase firebase = FirebaseImp();
  var result = await firebase.init();
  if (result) {
    Bloc.observer = BlocObservers();
    final mediaData = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    R.setData(mediaData);
    BaseEnv.instance.setEnv();
    await configureDependencies();
    await sl.isReady<SharedPreferences>();

     await sl<VoiceService>().initialize();

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SettingBloc>(
            create: (context) => SettingBloc(
              setThemeUseCase: sl<SetThemeUseCase>(),
              getThemeUseCase: sl<GetThemeUseCase>(),
              getLanguageUseCase: sl<GetLanguageUseCase>(),
              saveLanguageUseCase: sl<SaveLanguageUseCase>(),
              logoutUseCase: sl<LogoutUseCase>(),
              updateApiWalletAddressUsecase: sl<UpdateApiWalletAddressUsecase>(),
            ),
          ),
          BlocProvider<PasswordBloc>(
            create: (context) => PasswordBloc(
              resetPasswordUseCase: sl<ResetPasswordUseCase>(),
              forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
              changePasswordUseCase: sl<ChangePasswordUseCase>(),
            ),
          )
        ],
        child: MyApp(
          remoteNotificationsService: sl<RemoteNotificationsService>(),
        ),
      ),
    );
  }
}

abstract class MyFirebase {
  Future<bool> init();
}

class FirebaseImp extends MyFirebase {
  @override
  Future<bool> init() async {
    var app = await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Platform.isAndroid ? dotenv.env['ANDROID_FIREBASE_API_KEY'] ?? '' : dotenv.env['iOS_FIREBASE_API_KEY'] ?? '',
        appId: Platform.isAndroid ? dotenv.env['ANDROID_FIREBASE_APP_ID'] ?? '' : dotenv.env['iOS_FIREBASE_APP_ID'] ?? '',
        messagingSenderId: Platform.isAndroid ? dotenv.env['ANDROID_FIREBASE_MESSAGE_ID'] ?? '' : dotenv.env['iOS_FIREBASE_MESSAGE_ID'] ?? '',
        projectId: Platform.isAndroid ? dotenv.env['ANDROID_FIREBASE_PROJECT_ID'] ?? '' : dotenv.env['iOS_FIREBASE_PROJECT_ID'] ?? '',
      ),
    );

    FirebaseAppCheck.instanceFor(app: app);
    return true;
  }
}

void setUpNotifications(RemoteNotificationsService remoteNotificationsService) async {
  var remoteNotificationService = remoteNotificationsService;
  await remoteNotificationService.getNotificationsPermission();
  remoteNotificationService.listenToNotification();
  _tryConsumingIncomingCallFromTerminatedState();
}

void _tryConsumingIncomingCallFromTerminatedState() {
  // This is only relevant for Android.
  if (Platform.isIOS) return;

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    sl<Logger>().f('background triggered');
    // StreamVideo.instance.consumeAndAcceptActiveCall(
    //   onCallAccepted: (callToJoin) {
    //     sl<Navigation>().pushNamedWithExtra(path: Routes.callScreen, navigationData: CallNavigationData(call: callToJoin));
    //   },
    // );
  });
}

void galleryPermission(RemoteNotificationsService remoteNotificationsService) async {
  var remoteNotificationService = remoteNotificationsService;
  await remoteNotificationService.requestGalleryPermission();
}

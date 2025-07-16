import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/firebase/firebase_notification_helper.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/go_router/app_routes.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/widgets/no_internet_widget.dart';
import 'package:unice_app/main/main_core.dart';
import 'package:unice_app/module/auth/bloc/login_bloc.dart';
import 'package:unice_app/module/auth/bloc/onboarding_bloc.dart';
import 'package:unice_app/module/auth/bloc/register_bloc.dart';
import 'package:unice_app/module/auth/usecase/apple_login_use_case.dart';
import 'package:unice_app/module/auth/usecase/get_token_usecase.dart';
import 'package:unice_app/module/auth/usecase/google_auth_use_case.dart';
import 'package:unice_app/module/auth/usecase/register_use_case.dart';
import 'package:unice_app/module/auth/usecase/resend_email_usecase.dart';
import 'package:unice_app/module/auth/usecase/save_token_use_case.dart';
import 'package:unice_app/module/auth/usecase/update_setting_use_case.dart';
import 'package:unice_app/module/auth/usecase/upload_image_usecase.dart';
import 'package:unice_app/module/auth/usecase/verify_email_code_usecase.dart';
import 'package:unice_app/module/calling/bloc/call_bloc.dart';
import 'package:unice_app/module/calling/usecase/translation_usecase.dart';
import 'package:unice_app/module/calling/usecase/updated_usecases/generate_call_token_use_case.dart';
import 'package:unice_app/module/calling/usecase/updated_usecases/get_call_history_use_case.dart';
import 'package:unice_app/module/chats/bloc/chat_bot_bloc.dart';
import 'package:unice_app/module/chats/bloc/chats_bloc.dart';
import 'package:unice_app/module/chats/usecases/chat/create_chat_room_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat/get_all_chat_room_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat/get_chat_mesage_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat/get_chat_room_by_id.dart';
import 'package:unice_app/module/chats/usecases/chat/read_message_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat/report_message_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat/send_message_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat/toggle_chat_favorite_usecase.dart';
import 'package:unice_app/module/chats/usecases/chat_bot_message_usecase.dart';
import 'package:unice_app/module/chats/usecases/get_all_chat_bot_message_usecase.dart';
import 'package:unice_app/module/chats/usecases/new_chat_bot_session_usecase.dart';
import 'package:unice_app/module/chats/usecases/referral/claim_referral_usecase.dart';
import 'package:unice_app/module/chats/usecases/voice/upload_voice_use_case.dart';
import 'package:unice_app/module/home/bloc/bottom_tab_bloc.dart';
import 'package:unice_app/module/home/bloc/home_bloc.dart';
import 'package:unice_app/module/home/bloc/invite_friend_bloc.dart';
import 'package:unice_app/module/home/bloc/qr_bloc.dart';
import 'package:unice_app/module/home/usecases/block_user_use_case.dart';
import 'package:unice_app/module/home/usecases/blocked_users_list_use_case.dart';
import 'package:unice_app/module/home/usecases/cancel_pending_request_usecase.dart';
import 'package:unice_app/module/home/usecases/friends_requests_usecase.dart';
import 'package:unice_app/module/home/usecases/friends_suggestion_usecase.dart';
import 'package:unice_app/module/home/usecases/get_all_friends_usecase.dart';
import 'package:unice_app/module/home/usecases/get_friends_usecase.dart';
import 'package:unice_app/module/home/usecases/get_user_by_id_usecase.dart';
import 'package:unice_app/module/home/usecases/get_user_by_username_usecase.dart';
import 'package:unice_app/module/home/usecases/refferals/get_referral_UseCase.dart';
import 'package:unice_app/module/home/usecases/send_friend_request_usecase.dart';
import 'package:unice_app/module/home/usecases/unblock_user_use_case.dart';
import 'package:unice_app/module/home/usecases/unfriend_usecase.dart';
import 'package:unice_app/module/home/usecases/update_friend_request_status_use_case.dart';
import 'package:unice_app/module/intro/usecases/create_profile_usecase.dart';
import 'package:unice_app/module/intro/usecases/get_profile_usecase.dart';
import 'package:unice_app/module/intro/usecases/update_user_profile_usecase.dart';
import 'package:unice_app/module/onboarding/usecase/login_usecase.dart';
import 'package:unice_app/module/setting/blocs/setting_bloc.dart';
import 'package:unice_app/module/wallet/bloc/wallet_bloc.dart';
import 'package:unice_app/module/wallet/usecase/list_transactions_usecase.dart';
import 'package:unice_app/module/wallet/usecase/meta_mask_get_wallet_address_usecase.dart';
import 'package:unice_app/module/wallet/usecase/meta_mask_usecase.dart';
import 'package:unice_app/module/wallet/usecase/update_api_wallet_address_usecase.dart';
import '../module/auth/usecase/login_use_case.dart';

/// This widget is the root of application.
class MyApp extends StatefulWidget {
  final RemoteNotificationsService remoteNotificationsService;

  const MyApp({super.key, required this.remoteNotificationsService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setUpNotifications(widget.remoteNotificationsService);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: R.palette.blackColor,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = getScreenSize();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatsBloc>(
          create: (context) => ChatsBloc(
            createChatRoomUsecase: sl<CreateChatRoomUsecase>(),
            getAllChatRoomUsecase: sl<GetAllChatRoomUsecase>(),
            getChatMessageUsecase: sl<GetChatMessageUsecase>(),
            readMessageUsecase: sl<ReadMessageUsecase>(),
            sendMessageUsecase: sl<SendMessageUsecase>(),
            toggleChatFavouriteUsecase: sl<ToggleChatFavouriteUsecase>(),
            reportMessageUsecase: sl<ReportMessageUsecase>(),
            getChatRoomByIdInputUsecase: sl<GetChatRoomByIdInputUsecase>(),
            uploadVoiceUseCase: sl<UploadVoiceUseCase>(),
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            loginUseCase: sl<LoginUsecase>(),
            googleAuthUseCase: sl<GoogleAuthUseCase>(),
            loginEmailUseCase: sl<LoginEmailUseCase>(),
            getProfileUseCase: sl<GetProfileUseCase>(),
            getTokenUseCase: sl<GetTokenUseCase>(),
            saveTokenUseCase: sl<SaveTokenUseCase>(),
            appleLoginUseCase: sl<AppleLoginUseCase>(),
            verifyEmailCodeUseCase: sl<VerifyEmailCodeUseCase>(),
            resendEmailUsecase: sl<ResendEmailUsecase>(),
          ),
        ),
        BlocProvider<CallScreenBloc>(
          create: (context) => CallScreenBloc(
            translationUsecase: sl<TranslationUsecase>(),
            generateCallTokenUseCase: sl<GenerateCallTokenUseCase>(),
            getCallHistoryUseCase: sl<GetCallHistoryUseCase>(),
          ),
        ),
        BlocProvider<BottomTabBloc>(
          create: (context) => BottomTabBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            registerUseCase: sl<RegisterUseCase>(),
          ),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            updateSettingUseCase: sl<UpdateSettingUseCase>(),
            getFriendsUsecase: sl<GetFriendsUsecase>(),
            unfriendUseCase: sl<UnfriendUseCase>(),
            getAllFriendsUsecase: sl<GetAllFriendsUsecase>(),
            claimReferralUseCase: sl<ClaimReferralUseCase>(),
            referralListUseCase: sl<ReferralListUseCase>(),
          ),
        ),
        BlocProvider<WalletBloc>(
          create: (context) => WalletBloc(
            connectMetamaskUsecase: sl<ConnectMetamaskUsecase>(),
            metaMaskGetWalletAddressUsecase: sl<MetaMaskGetWalletAddressUsecase>(),
            updateApiWalletAddressUsecase: sl<UpdateApiWalletAddressUsecase>(),
            listWalletTransactionsUseCase: sl<ListWalletTransactionsUseCase>(),
          ),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => OnboardingBloc(
            uploadFileUsecase: sl<UploadFileUsecase>(),
            createProfileUsecase: sl<CreateProfileUsecase>(),
            updateUserProfileUsecase: sl<UpdateUserProfileUsecase>(),
            saveTokenUseCase: sl<SaveTokenUseCase>(),
          ),
        ),
        BlocProvider<InviteFriendBloc>(
          create: (context) => InviteFriendBloc(
            friendsSuggestionsUsecase: sl<FriendsSuggestionsUsecase>(),
            friendsRequestUseCase: sl<FriendRequestsUsecase>(),
            sendFriendRequestUseCase: sl<SendFriendRequestUseCase>(),
            blockUserUseCase: sl<BlockUserUseCase>(),
            unblockUserUseCase: sl<UnblockUserUseCase>(),
            cancelPendingRequestUseCase: sl<CancelPendingRequestUseCase>(),
            blockedUsersListUseCase: sl<BlockedUsersListUseCase>(),
            updateFriendRequestStatusUseCase: sl<UpdateFriendRequestStatusUseCase>(),
            getUserByIdUseCase: sl<GetUserByIdUseCase>(),
          ),
        ),
        BlocProvider<QrBloc>(
          create: (context) => QrBloc(
            getUserByUsernameUseCase: sl<GetUserByUsernameUseCase>(),
            getUserByIdUseCase: sl<GetUserByIdUseCase>(),
          ),
        ),
        BlocProvider<ChatBotBloc>(
          create: (context) => ChatBotBloc(
            newChatBotSessionUsecase: sl<NewChatBotSessionUsecase>(),
            sendChatBotMessageUsecase: sl<SendChatBotMessageUsecase>(),
            getAllChatBotMessageUsecase: sl<GetAllChatBotMessageUsecase>(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: screenSize,
        useInheritedMediaQuery: true,
        builder: (context, __) => NoInternetAppWidget(
          child: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, settingState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routeInformationProvider: AppRouter.router.routeInformationProvider,
                routeInformationParser: AppRouter.router.routeInformationParser,
                routerDelegate: AppRouter.router.routerDelegate,
                title: 'Unice',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('ko'),
                ],
                locale: Locale(settingState.locale),
                theme: AppTheme().lightTheme(),
                darkTheme: AppTheme().lightTheme(),
              );
            },
          ),
        ),
      ),
    );
  }

  Size getScreenSize() {
    return const Size(375, 812);
  }
}

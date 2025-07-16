import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as l;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:stream_video/stream_video.dart' as stream_video;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/module/calling/navigation_data/navigation_data.dart';

abstract class StreamCallService {
  Future<bool> init(BuildContext context, User user, String token);

  Future<void> registerDeviceToken(String deviceToken);

  Future<Call> startCall({required String callId, required List<String> memberIds});

  Future<Call> startAudioCall({required String callId, required List<String> memberIds});

  void listenForIncomingCalls(BuildContext context, String myUserId);

  void dispose();
}

@Singleton(as: StreamCallService)
class StreamCallServiceImpl implements StreamCallService {
  StreamVideo? _streamVideo;
  final l.FlutterLocalNotificationsPlugin _localNotif = l.FlutterLocalNotificationsPlugin();
  PushNotificationManager? _pushManager; // Updated type
  StreamSubscription<CallKitEvent>? _callKitSub;
  StreamSubscription<Call?>? _incomingCallSub;

  /// Initializes StreamVideo, Firebase, and push notifications
  @override
  Future<bool> init(BuildContext context, User user, String token) async {
    // Ensure Firebase is initialized for messaging
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();
    try {
      StreamVideo.reset();
    } catch (e) {
      sl<Logger>().w('StreamVideo.reset() threw: $e');
    }

    if (_streamVideo != null) {
      sl<Logger>().w('StreamCallService already initialized, resetting...');
      _streamVideo!.dispose();
      _streamVideo = null;
    }
    // Initialize StreamVideo client with push manager
    _streamVideo = StreamVideo(
      'ppp84c4t8j4m',
      user: user,
      userToken: token,
      options: const StreamVideoOptions(
        autoConnect: true,
        keepConnectionsAliveWhenInBackground: true,
        includeUserDetailsForAutoConnect: true,
        logPriority: stream_video.Priority.error,
      ),
      pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
        iosPushProvider: const StreamVideoPushProvider.apn(
          name: 'apn',
          tokenStreamProvider: _iosTokenStream,
        ),
        androidPushProvider: const StreamVideoPushProvider.firebase(
          name: 'fcm',
          tokenStreamProvider: _fcmTokenStream,
        ),
        registerApnDeviceToken: true,
        pushParams: const StreamVideoPushParams(
          appName: 'Unice',
          ios: IOSParams(iconName: 'IconMask'),
        ),
      ),
    );

    // Initialize local notifications
    await _localNotif.initialize(
      const l.InitializationSettings(
        android: l.AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: l.DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onTapNotification,
    );

    // Handle background FCM
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    // Setup push manager and register device
    // Note: pushNotificationManager returns PushNotificationManager
    _pushManager = _streamVideo!.pushNotificationManager!;
    _pushManager!.registerDevice();
    _callKitSub = _pushManager!.onCallEvent.listen(_handleCallEvent);

    if (Platform.isAndroid) {
      final android = _localNotif.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      var channel = AndroidNotificationChannel(
        'call_channel', // same id you use in NotificationDetails
        'Calls', // user-visible name
        description: 'Incoming calls',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: R.palette.primary,
        showBadge: true,
      );
      await android?.createNotificationChannel(channel);
    }

    // Listen for incoming calls
    listenForIncomingCalls(context, user.id);
    return true;
  }

  /// Stream of FCM tokens (Android)
  static Stream<String> _fcmTokenStream() => FirebaseMessaging.instance.onTokenRefresh;

  /// Stream of APNs tokens (iOS)
  static Stream<String> _iosTokenStream() => FirebaseMessaging.instance.onTokenRefresh;

  static Future<void> _onBackgroundMessage(RemoteMessage msg) async {
    sl<Logger>().d('Background message received: ${msg.data}');
    await StreamVideo.instance.handleRingingFlowNotifications(msg.data);
  }

  void _handleCallEvent(CallKitEvent event) {
    sl<Logger>().d('CallKitEvent: $event');
    if (event is CallRingEvent) {
      final invite = event as CallRingEvent;
      _showIncomingCall(invite);
    }
    // You can handle other CallKitEvent types here if needed
  }

  Future<void> _showIncomingCall(CallRingEvent invite) async {
    sl<Logger>().d('Displaying incoming call notification');
    await _localNotif.show(
      invite.callCid.hashCode,
      'Incoming call',
      'From ${invite.user.name}',
      const l.NotificationDetails(
        android: l.AndroidNotificationDetails(
          'call_channel',
          'Calls',
          importance: l.Importance.max,
          priority: l.Priority.high,
          fullScreenIntent: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('ringtone'),
        ),
        iOS: l.DarwinNotificationDetails(presentSound: true),
      ),
      payload: invite.callCid,
    );
  }

  void _onTapNotification(l.NotificationResponse resp) {
    sl<Logger>().d('Notification tapped with payload: ${resp.payload}');
    final callCid = resp.payload;
    if (callCid != null) {
      StreamVideo.instance.consumeAndAcceptActiveCall(onCallAccepted: (call) async {
        await call.join(
          connectOptions: const CallConnectOptions(
            audioOutputDevice: stream_video.RtcMediaDevice(id: '', label: 'audio', kind: RtcMediaDeviceKind.audioOutput),
          ),
        );
        sl<Navigation>().pushNamedWithExtra(path: Routes.callScreen, navigationData: CallNavigationData(call: call));
      });
    }
  }

  /// Registers this device for push notifications via the push manager
  @override
  Future<void> registerDeviceToken(String deviceToken) async {
    _pushManager!.registerDevice();
    sl<Logger>().i('Device registered for push notifications');
  }

  @override
  Future<Call> startCall({required String callId, required List<String> memberIds}) async {
    final call = _streamVideo!.makeCall(
      id: callId,
      callType: StreamCallType.defaultType(),
      preferences: DefaultCallPreferences(
        closedCaptionsVisibleCaptions: 5,
        closedCaptionsVisibilityDurationMs: 5000,
        reactionAutoDismissTime: const Duration(seconds: 1),
      ),
    );
    await call.getOrCreate(
      ringing: true,
      memberIds: memberIds,
      transcription: const StreamTranscriptionSettings(
        transcriptionMode: TranscriptionSettingsMode.available,
        closedCaptionMode: ClosedCaptionSettingsMode.available,
        language: TranscriptionSettingsLanguage.auto,
      ),
    );

    return call;
  }

  @override
  Future<Call> startAudioCall({required String callId, required List<String> memberIds}) async {
    final call = _streamVideo!.makeCall(
      id: callId,
      callType: StreamCallType.audioRoom(),
      preferences: DefaultCallPreferences(
        closedCaptionsVisibleCaptions: 3,
        closedCaptionsVisibilityDurationMs: 3000,
      ),
    );
    var res = await call.getOrCreate(
      ringing: true,
      memberIds: memberIds,
      transcription: const StreamTranscriptionSettings(
        transcriptionMode: TranscriptionSettingsMode.available,
        closedCaptionMode: ClosedCaptionSettingsMode.available,
        language: TranscriptionSettingsLanguage.auto,
      ),
    );
    if (res.isSuccess) {
      // await call.join();
      // await call.goLive();
      return call;
    } else {
      return call;
    }
  }

  @override
  void listenForIncomingCalls(BuildContext context, String myUserId) {
    _incomingCallSub = _streamVideo!.state.incomingCall.listen((call) {
      if (call == null || call.state.value.createdByUserId == myUserId) return;

      sl<Navigation>().pushNamedWithExtra(path: Routes.callScreen, navigationData: CallNavigationData(call: call));
    });
  }

  @override
  void dispose() {
    try {
      _callKitSub!.cancel();
      _callKitSub = null;
      _incomingCallSub!.cancel();
      _incomingCallSub = null;
      _streamVideo!.dispose(); // Add this to properly clean StreamVideo instance
      _streamVideo = null; // VERY important: clear after dispose
      sl<Logger>().i('StreamCallService disposed');
    } catch (e, st) {
      sl<Logger>().e('Error while disposing StreamCallService', error: e, stackTrace: st);
    }
  }
}

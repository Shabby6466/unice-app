// coverage: false
// coverage:ignore-file

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseEnv {
  BaseEnv._internal();

  static final BaseEnv _instance = BaseEnv._internal();

  static BaseEnv get instance => _instance;

  late String _url;
  late String _agoraAppID;
  late String _tempToken;
  late String _channel;

  void setEnv() {
    _url = dotenv.env['BASE_URL'] ?? '';
    _agoraAppID = dotenv.env['AGORA_APP_ID'] ?? '';
    _tempToken = dotenv.env['TEMP_TOKEN'] ?? '';
    _channel = dotenv.env['CHANNEL'] ?? '';
  }

  String get url => _url;

  String get agoraAppID => _agoraAppID;

  String get channel => _channel;
  String get tempToken => _tempToken;
}

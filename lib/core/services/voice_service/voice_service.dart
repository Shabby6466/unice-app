import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class VoiceService {
  /// Initialize the voice recorder and player
  Future<void> initialize();

  /// Start recording audio
  Future<void> startRecording();

  /// Stop recording audio
  /// Returns the path of the recorded audio file
  Future<String?> stopRecording();

  /// Play recorded audio from a given file path
  Future<void> playAudio(String filePath);

  /// Stop playing audio
  Future<void> stopPlaying();

  /// Pause playing audio
  Future<void> pausePlaying();

  /// Resume playing audio
  Future<void> resumePlaying();

  /// Get current recording duration in seconds
  Duration getCurrentDuration();

  /// Dispose recorder and player resources
  Future<void> dispose();

  /// Check if currently recording
  bool isRecording();

  /// Check if currently playing
  bool isPlaying();

  /// Check if player is paused
  bool isPaused();

  Future<String> convertAacToMp3(String inputPath);
}

@LazySingleton(as: VoiceService)
class VoiceServiceImpl implements VoiceService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  String? _recordedFilePath;
  DateTime? _recordingStartTime;

  @override
  Future<void> initialize() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }

    // Initialize recorder
    await _recorder.openRecorder();
    _isRecorderInitialized = true;

    // Initialize player
    await _player.openPlayer();
    _isPlayerInitialized = true;
  }

  @override
  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      await initialize();
    }

    // Generate temporary file path for recording
    final directory = await getTemporaryDirectory();
    _recordedFilePath = '${directory.path}/recorded_audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    // Start recording
    await _recorder.startRecorder(
      toFile: _recordedFilePath,
      codec: Codec.aacADTS,
    );

    _recordingStartTime = DateTime.now();
  }

  @override
  Future<String?> stopRecording() async {
    if (!_isRecorderInitialized || !_recorder.isRecording) {
      return null;
    }

    await _recorder.stopRecorder();
    _recordingStartTime = null;

    return _recordedFilePath;
  }

  @override
  Future<void> playAudio(String filePath) async {
    if (!_isPlayerInitialized) {
      await _player.openPlayer();
      _isPlayerInitialized = true;
    }

    await _player.startPlayer(
      fromURI: filePath,
      whenFinished: () {
        // Handle player finished event
      },
    );
  }

  @override
  Future<void> stopPlaying() async {
    if (_isPlayerInitialized && _player.isPlaying) {
      await _player.stopPlayer();
    }
  }

  @override
  Future<void> pausePlaying() async {
    if (_isPlayerInitialized && _player.isPlaying) {
      await _player.pausePlayer();
    }
  }

  @override
  Future<void> resumePlaying() async {
    if (_isPlayerInitialized && !_player.isPlaying) {
      await _player.resumePlayer();
    }
  }

  @override
  Duration getCurrentDuration() {
    if (_recordingStartTime != null && _recorder.isRecording) {
      return DateTime.now().difference(_recordingStartTime!);
    }
    return Duration.zero;
  }

  @override
  Future<void> dispose() async {
    if (_isRecorderInitialized) {
      await _recorder.closeRecorder();
      _isRecorderInitialized = false;
    }

    if (_isPlayerInitialized) {
      await _player.closePlayer();
      _isPlayerInitialized = false;
    }
  }

  @override
  bool isRecording() {
    return _isRecorderInitialized && _recorder.isRecording;
  }

  @override
  bool isPlaying() {
    return _isPlayerInitialized && _player.isPlaying;
  }

  @override
  bool isPaused() {
    return _isPlayerInitialized && _player.isPaused;
  }

  @override
  Future<String> convertAacToMp3(String inputPath) async {

    return '';
  }
}

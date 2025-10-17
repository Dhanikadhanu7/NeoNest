import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  late final AudioPlayer player;

  AudioManager._internal() {
    player = AudioPlayer();
  }
}

final audioManager = AudioManager();

import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playRingtone() async {
    // Release mode needs asset source prefix
    await _player.stop(); // Stop any previous sound
    await _player.play(AssetSource('audio/ringtone.mp3'));
  }

  Future<void> stop() async {
    await _player.stop();
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playRingtone() async {
    // Release mode needs asset source prefix
    await _player.stop(); // Stop any previous sound
    await _player.play(AssetSource('audio/ringtone.mp3'));

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 5000);
    }
  }

  Future<void> stop() async {
    await _player.stop();
    Vibration.cancel();
  }
}

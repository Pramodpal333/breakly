import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'preferences_service.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final PreferencesService _prefs;

  AudioService(this._prefs);

  Future<void> playRingtone() async {
    // Release mode needs asset source prefix
    await _player.stop(); // Stop any previous sound

    if (_prefs.playSoundOnAlert) {
      await _player.play(AssetSource('audio/ringtone.mp3'));
    }

    if (_prefs.vibrateOnAlert && (await Vibration.hasVibrator())) {
      Vibration.vibrate(duration: 3000);
    }
  }

  Future<void> stop() async {
    await _player.stop();
    Vibration.cancel();
  }
}

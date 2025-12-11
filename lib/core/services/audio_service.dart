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
      if (_prefs.ringInSilentMode) {
        // Configure player to respect silent mode preference
        // Playback category ignores silent switch on iOS
        // Alarm usage usually ignores silent/DND on Android
        await _player.setAudioContext(
          AudioContext(
            iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
            android: AudioContextAndroid(
              usageType: AndroidUsageType.alarm,
              contentType: AndroidContentType.music,
              audioFocus: AndroidAudioFocus.gainTransient,
            ),
          ),
        );
      } else {
        // Reset to default ambient/music behavior
        await _player.setAudioContext(
          AudioContext(
            iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
            android: AudioContextAndroid(
              usageType: AndroidUsageType.media,
              contentType: AndroidContentType.music,
              audioFocus: AndroidAudioFocus.gainTransient,
            ),
          ),
        );
      }

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

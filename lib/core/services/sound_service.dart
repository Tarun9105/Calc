import 'package:just_audio/just_audio.dart';

/// Singleton service that handles button click sound playback.
///
/// Usage:
///   await SoundService.instance.init();   // call once in main()
///   SoundService.instance.setEnabled(true);
///   SoundService.instance.playKeyPress(); // call on each button press
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();
  bool _enabled = false;

  /// Preloads the key-press sound asset so the first button press
  /// plays instantly without any loading lag.
  Future<void> init() async {
    try {
      await _player.setAsset('assets/sounds/key_press.wav');
      await _player.setVolume(1.0);
    } catch (_) {}
  }

  /// Enable or disable sound playback.
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Play a short key-press click if sound is enabled.
  Future<void> playKeyPress() async {
    if (!_enabled) return;
    try {
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      // Silently ignore audio errors
    }
  }

  /// Release audio resources.
  Future<void> dispose() async {
    await _player.dispose();
  }
}

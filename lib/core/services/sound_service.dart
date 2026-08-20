import 'package:just_audio/just_audio.dart';

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();
  bool _enabled = false;

  Future<void> init() async {
    try {
      await _player.setAsset('assets/sounds/key_press.wav');
      await _player.setVolume(1.0);
    } catch (_) {}
  }

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> playKeyPress() async {
    if (!_enabled) return;
    try {
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}

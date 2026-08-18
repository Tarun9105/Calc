import 'package:flutter/services.dart';

/// Singleton service that plays the system tap/click sound on button presses.
///
/// Uses Flutter's built-in [SystemSound] — no external package or audio asset
/// required. The sound respects the device's system sound settings.
///
/// Usage:
///   SoundService.instance.setEnabled(true);
///   SoundService.instance.playKeyPress(); // call on each button press
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  bool _enabled = false;

  /// No-op — kept for API symmetry. Call once at app startup if needed.
  void init() {}

  /// Enable or disable sound playback. Driven by [AppSettings.soundEnabled].
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Play the system click sound if sound is enabled.
  Future<void> playKeyPress() async {
    if (!_enabled) return;
    await SystemSound.play(SystemSoundType.click);
  }

  /// No-op — SoundService is an app-level singleton; no cleanup needed.
  void dispose() {}
}

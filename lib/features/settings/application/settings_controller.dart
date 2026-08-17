import '../domain/app_settings.dart';
import 'settings_repository.dart';

/// Controller that owns settings state and persists changes.
class SettingsController {
  SettingsController({SettingsRepository? settingsRepository})
      : _settingsRepository =
            settingsRepository ?? InMemorySettingsRepository() {
    _settings = _settingsRepository.load();
  }

  final SettingsRepository _settingsRepository;
  late AppSettings _settings;

  AppSettings get settings => _settings;

  void updateThemeMode(CalculatorThemeMode themeMode) {
    _save(_settings.copyWith(themeMode: themeMode));
  }

  void updateTextScale(TextScalePreference textScale) {
    _save(_settings.copyWith(textScale: textScale));
  }

  void updateDecimalPrecision(int precision) {
    _save(_settings.copyWith(decimalPrecision: precision.clamp(2, 10)));
  }

  void updateHapticsEnabled(bool isEnabled) {
    _save(_settings.copyWith(hapticsEnabled: isEnabled));
  }

  void updateSoundEnabled(bool isEnabled) {
    _save(_settings.copyWith(soundEnabled: isEnabled));
  }

  void _save(AppSettings settings) {
    _settings = _settingsRepository.save(settings);
  }
}

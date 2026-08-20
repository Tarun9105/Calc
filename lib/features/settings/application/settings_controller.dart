import '../domain/app_settings.dart';
import 'settings_repository.dart';

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
    _saveSettings(_settings.copyWith(themeMode: themeMode));
  }

  void updateTextScale(TextScalePreference textScale) {
    _saveSettings(_settings.copyWith(textScale: textScale));
  }

  void updateDecimalPrecision(int precision) {
    _saveSettings(_settings.copyWith(decimalPrecision: precision.clamp(2, 10)));
  }

  void updateHapticsEnabled(bool isEnabled) {
    _saveSettings(_settings.copyWith(hapticsEnabled: isEnabled));
  }

  void updateSoundEnabled(bool isEnabled) {
    _saveSettings(_settings.copyWith(soundEnabled: isEnabled));
  }

  void updateCustomOperatorColor(int? colorValue) {
    _saveSettings(_settings.copyWith(customOperatorColorValue: colorValue));
  }

  void updateCustomButtonBackgroundText(String? text) {
    _saveSettings(_settings.copyWith(customButtonBackgroundText: text));
  }

  void _saveSettings(AppSettings settings) {
    _settings = _settingsRepository.save(settings);
  }
}

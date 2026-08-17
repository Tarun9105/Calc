import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
enum CalculatorThemeMode {
  @HiveField(0)
  system,
  @HiveField(1)
  dark,
  @HiveField(2)
  light,
}

@HiveType(typeId: 2)
enum TextScalePreference {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large,
}

@HiveType(typeId: 3)
class AppSettings {
  const AppSettings({
    this.themeMode = CalculatorThemeMode.system,
    this.textScale = TextScalePreference.medium,
    this.decimalPrecision = 10,
    this.hapticsEnabled = true,
    this.soundEnabled = false,
    this.customOperatorColorValue,
    this.customButtonBackgroundText,
  });

  @HiveField(0)
  final CalculatorThemeMode themeMode;
  @HiveField(1)
  final TextScalePreference textScale;
  @HiveField(2)
  final int decimalPrecision;
  @HiveField(3)
  final bool hapticsEnabled;
  @HiveField(4)
  final bool soundEnabled;
  @HiveField(5)
  final int? customOperatorColorValue;
  @HiveField(6)
  final String? customButtonBackgroundText;

  AppSettings copyWith({
    CalculatorThemeMode? themeMode,
    TextScalePreference? textScale,
    int? decimalPrecision,
    bool? hapticsEnabled,
    bool? soundEnabled,
    int? customOperatorColorValue,
    String? customButtonBackgroundText,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      textScale: textScale ?? this.textScale,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      customOperatorColorValue: customOperatorColorValue ?? this.customOperatorColorValue,
      customButtonBackgroundText: customButtonBackgroundText ?? this.customButtonBackgroundText,
    );
  }
}

extension TextScalePreferenceValue on TextScalePreference {
  double get scale {
    switch (this) {
      case TextScalePreference.small:
        return 0.9;
      case TextScalePreference.medium:
        return 1;
      case TextScalePreference.large:
        return 1.18;
    }
  }

  String get label {
    switch (this) {
      case TextScalePreference.small:
        return 'Small';
      case TextScalePreference.medium:
        return 'Medium';
      case TextScalePreference.large:
        return 'Large';
    }
  }
}

extension CalculatorThemeModeLabel on CalculatorThemeMode {
  String get label {
    switch (this) {
      case CalculatorThemeMode.system:
        return 'System';
      case CalculatorThemeMode.dark:
        return 'Dark';
      case CalculatorThemeMode.light:
        return 'Light';
    }
  }
}


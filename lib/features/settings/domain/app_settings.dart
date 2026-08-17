enum CalculatorThemeMode {
  system,
  dark,
  light,
}

enum TextScalePreference {
  small,
  medium,
  large,
}

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

  final CalculatorThemeMode themeMode;
  final TextScalePreference textScale;
  final int decimalPrecision;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final int? customOperatorColorValue;
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


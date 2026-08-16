import 'package:flutter/material.dart';

import '../features/settings/domain/app_settings.dart';

ThemeData buildSmartCalcTheme({
  CalculatorThemeMode themeMode = CalculatorThemeMode.dark,
}) {
  final isLight = themeMode == CalculatorThemeMode.light;
  final background = isLight ? const Color(0xFFF2F2F7) : const Color(0xFF000000);
  const operator = Color(0xFFFF9500);
  final digit = isLight ? const Color(0xFFE0E0E6) : const Color(0xFF333333);
  const function = Color(0xFFA5A5A5);
  final scientific = isLight ? const Color(0xFFD1D1D6) : const Color(0xFF1C1C1C);
  final textOnSurface = isLight ? Colors.black : Colors.white;

  return ThemeData(
    brightness: isLight ? Brightness.light : Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: operator,
      brightness: isLight ? Brightness.light : Brightness.dark,
      surface: background,
      primary: operator,
      secondary: digit,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w300,
        color: textOnSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: isLight ? Colors.black87 : Colors.white70,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      SmartCalcColors(
        digit: digit,
        function: function,
        operator: operator,
        scientific: scientific,
      ),
    ],
  );
}

class SmartCalcColors extends ThemeExtension<SmartCalcColors> {
  const SmartCalcColors({
    required this.digit,
    required this.function,
    required this.operator,
    required this.scientific,
  });

  final Color digit;
  final Color function;
  final Color operator;
  final Color scientific;

  @override
  SmartCalcColors copyWith({
    Color? digit,
    Color? function,
    Color? operator,
    Color? scientific,
  }) {
    return SmartCalcColors(
      digit: digit ?? this.digit,
      function: function ?? this.function,
      operator: operator ?? this.operator,
      scientific: scientific ?? this.scientific,
    );
  }

  @override
  SmartCalcColors lerp(
    covariant ThemeExtension<SmartCalcColors>? other,
    double t,
  ) {
    if (other is! SmartCalcColors) {
      return this;
    }

    return SmartCalcColors(
      digit: Color.lerp(digit, other.digit, t) ?? digit,
      function: Color.lerp(function, other.function, t) ?? function,
      operator: Color.lerp(operator, other.operator, t) ?? operator,
      scientific: Color.lerp(scientific, other.scientific, t) ?? scientific,
    );
  }
}

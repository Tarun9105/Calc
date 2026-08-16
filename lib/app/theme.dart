import 'package:flutter/material.dart';

ThemeData buildSmartCalcTheme() {
  const background = Color(0xFF000000);
  const operator = Color(0xFFFF9500);
  const digit = Color(0xFF333333);
  const function = Color(0xFFA5A5A5);

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      surface: background,
      primary: operator,
      secondary: digit,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      SmartCalcColors(
        digit: digit,
        function: function,
        operator: operator,
      ),
    ],
  );
}

class SmartCalcColors extends ThemeExtension<SmartCalcColors> {
  const SmartCalcColors({
    required this.digit,
    required this.function,
    required this.operator,
  });

  final Color digit;
  final Color function;
  final Color operator;

  @override
  SmartCalcColors copyWith({
    Color? digit,
    Color? function,
    Color? operator,
  }) {
    return SmartCalcColors(
      digit: digit ?? this.digit,
      function: function ?? this.function,
      operator: operator ?? this.operator,
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
    );
  }
}


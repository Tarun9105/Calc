import '../domain/angle_mode.dart';

class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.display = '0',
    this.angleMode = AngleMode.degrees,
    this.errorMessage,
  });

  final String expression;
  final String display;
  final AngleMode angleMode;
  final String? errorMessage;

  CalculatorState copyWith({
    String? expression,
    String? display,
    AngleMode? angleMode,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      display: display ?? this.display,
      angleMode: angleMode ?? this.angleMode,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

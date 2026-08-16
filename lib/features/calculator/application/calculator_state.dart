import '../domain/angle_mode.dart';
import '../../history/domain/history_entry.dart';

class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.display = '0',
    this.angleMode = AngleMode.degrees,
    this.history = const <HistoryEntry>[],
    this.memoryValue,
    this.errorMessage,
  });

  final String expression;
  final String display;
  final AngleMode angleMode;
  final List<HistoryEntry> history;
  final double? memoryValue;
  final String? errorMessage;

  CalculatorState copyWith({
    String? expression,
    String? display,
    AngleMode? angleMode,
    List<HistoryEntry>? history,
    double? memoryValue,
    bool clearMemoryValue = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      display: display ?? this.display,
      angleMode: angleMode ?? this.angleMode,
      history: history ?? this.history,
      memoryValue: clearMemoryValue ? null : memoryValue ?? this.memoryValue,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

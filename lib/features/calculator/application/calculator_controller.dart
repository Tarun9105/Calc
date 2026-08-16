import '../domain/calculator_engine.dart';
import 'calculator_state.dart';

class CalculatorController {
  CalculatorController({
    CalculatorEngine engine = const CalculatorEngine(),
  }) : _engine = engine;

  final CalculatorEngine _engine;
  CalculatorState _state = const CalculatorState();

  CalculatorState get state => _state;

  void append(String value) {
    final nextExpression = '${_state.expression}$value';
    _state = _state.copyWith(
      expression: nextExpression,
      display: nextExpression,
      clearError: true,
    );
  }

  void clear() {
    _state = const CalculatorState();
  }

  void backspace() {
    if (_state.expression.isEmpty) {
      return;
    }

    final nextExpression = _state.expression.substring(0, _state.expression.length - 1);
    _state = _state.copyWith(
      expression: nextExpression,
      display: nextExpression.isEmpty ? '0' : nextExpression,
      clearError: true,
    );
  }

  void evaluate() {
    final result = _engine.evaluate(_state.expression);
    if (result.isSuccess) {
      final display = _formatValue(result.value!);
      _state = _state.copyWith(
        expression: display,
        display: display,
        clearError: true,
      );
      return;
    }

    _state = _state.copyWith(
      errorMessage: result.error!.message,
      display: result.error!.message,
    );
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}


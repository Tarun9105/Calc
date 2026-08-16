import '../domain/angle_mode.dart';
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
    final nextValue = _state.errorMessage == null ? value : _normalizeReplacement(value);
    final nextExpression = '${_state.expression}$value';
    _state = _state.copyWith(
      expression: _state.errorMessage == null ? nextExpression : nextValue,
      display: _state.errorMessage == null ? nextExpression : nextValue,
      clearError: true,
    );
  }

  void applyFunction(String functionName) {
    final target = _state.expression.isEmpty ? '0' : _state.expression;
    final nextExpression = '$functionName($target)';
    _state = _state.copyWith(
      expression: nextExpression,
      display: nextExpression,
      clearError: true,
    );
  }

  void appendConstant(String constant) {
    append(constant);
  }

  void appendPower() {
    append('^');
  }

  void cycleAngleMode() {
    final nextMode = switch (_state.angleMode) {
      AngleMode.degrees => AngleMode.radians,
      AngleMode.radians => AngleMode.gradians,
      AngleMode.gradians => AngleMode.degrees,
    };

    _state = _state.copyWith(
      angleMode: nextMode,
      clearError: true,
    );
  }

  void toggleSign() {
    final expression = _state.expression;
    if (expression.isEmpty || expression == '0') {
      return;
    }

    final nextExpression = expression.startsWith('-')
        ? expression.substring(1)
        : '-$expression';

    _state = _state.copyWith(
      expression: nextExpression,
      display: nextExpression,
      clearError: true,
    );
  }

  void applyPercent() {
    final expression = _state.expression;
    if (expression.isEmpty) {
      return;
    }

    final parsed = double.tryParse(expression);
    if (parsed == null) {
      _state = _state.copyWith(
        expression: '$expression/100',
        display: '$expression/100',
        clearError: true,
      );
      return;
    }

    final value = parsed / 100;
    final display = _formatValue(value);
    _state = _state.copyWith(
      expression: display,
      display: display,
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
    final result = _engine.evaluate(
      _state.expression,
      angleMode: _state.angleMode,
    );
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

  String _normalizeReplacement(String value) {
    if (value == '.') {
      return '0.';
    }
    return value;
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}

import '../domain/angle_mode.dart';
import '../domain/calculator_engine.dart';
import '../../history/application/history_repository.dart';
import '../../history/domain/history_entry.dart';
import '../../memory/application/memory_repository.dart';
import 'calculator_state.dart';

class CalculatorController {
  CalculatorController({
    CalculatorEngine engine = const CalculatorEngine(),
    HistoryRepository? historyRepository,
    MemoryRepository? memoryRepository,
  })  : _engine = engine,
        _historyRepository = historyRepository ?? InMemoryHistoryRepository(),
        _memoryRepository = memoryRepository ?? InMemoryMemoryRepository() {
    _state = _state.copyWith(
      history: _historyRepository.load(),
      memoryValue: _memoryRepository.load()?.value,
    );
  }

  final CalculatorEngine _engine;
  final HistoryRepository _historyRepository;
  final MemoryRepository _memoryRepository;
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
    _state = CalculatorState(
      angleMode: _state.angleMode,
      history: _historyRepository.load(),
      memoryValue: _memoryRepository.load()?.value,
    );
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
    final originalExpression = _state.expression;
    final result = _engine.evaluate(
      _state.expression,
      angleMode: _state.angleMode,
    );
    if (result.isSuccess) {
      final display = _formatValue(result.value!);
      final history = _historyRepository.saveEntry(
        HistoryEntry(
          expression: originalExpression,
          result: display,
          createdAt: DateTime.now(),
        ),
      );
      _state = _state.copyWith(
        expression: display,
        display: display,
        history: history,
        clearError: true,
      );
      return;
    }

    _state = _state.copyWith(
      errorMessage: result.error!.message,
      display: result.error!.message,
    );
  }

  void recallHistory(int index) {
    if (index < 0 || index >= _state.history.length) {
      return;
    }

    final entry = _state.history[index];
    _state = _state.copyWith(
      expression: entry.expression,
      display: entry.result,
      clearError: true,
    );
  }

  void deleteHistoryEntry(int index) {
    _state = _state.copyWith(
      history: _historyRepository.deleteAt(index),
      clearError: true,
    );
  }

  void clearHistory() {
    _state = _state.copyWith(
      history: _historyRepository.clear(),
      clearError: true,
    );
  }

  void memoryStore() {
    final value = _parseDisplayValue();
    if (value == null) {
      return;
    }

    final memoryValue = _memoryRepository.save(value);
    _state = _state.copyWith(
      memoryValue: memoryValue.value,
      clearError: true,
    );
  }

  void memoryRecall() {
    final memoryValue = _memoryRepository.load();
    if (memoryValue == null) {
      return;
    }

    final display = _formatValue(memoryValue.value);
    _state = _state.copyWith(
      expression: display,
      display: display,
      memoryValue: memoryValue.value,
      clearError: true,
    );
  }

  void memoryClear() {
    _memoryRepository.clear();
    _state = _state.copyWith(
      clearMemoryValue: true,
      clearError: true,
    );
  }

  void memoryAdd() {
    final currentValue = _parseDisplayValue();
    if (currentValue == null) {
      return;
    }

    final nextValue = (_memoryRepository.load()?.value ?? 0) + currentValue;
    _memoryRepository.save(nextValue);
    _state = _state.copyWith(
      memoryValue: nextValue,
      clearError: true,
    );
  }

  void memorySubtract() {
    final currentValue = _parseDisplayValue();
    if (currentValue == null) {
      return;
    }

    final nextValue = (_memoryRepository.load()?.value ?? 0) - currentValue;
    _memoryRepository.save(nextValue);
    _state = _state.copyWith(
      memoryValue: nextValue,
      clearError: true,
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

  double? _parseDisplayValue() {
    final candidate = double.tryParse(_state.display);
    if (candidate != null) {
      return candidate;
    }

    return double.tryParse(_state.expression);
  }
}

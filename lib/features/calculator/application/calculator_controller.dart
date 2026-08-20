import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import '../domain/angle_mode.dart';
import '../domain/calculator_engine.dart';
import '../domain/calculator_error.dart';
import '../../history/application/history_repository.dart';
import '../../history/domain/history_entry.dart';
import '../../memory/application/memory_repository.dart';
import '../../settings/application/settings_repository.dart';
import '../../settings/domain/app_settings.dart';
import '../../history/application/hive_history_repository.dart';
import '../../memory/application/hive_memory_repository.dart';
import '../../settings/application/hive_settings_repository.dart';
import 'calculator_state.dart';

class CalculatorController {
  CalculatorController({
    CalculatorEngine engine = const CalculatorEngine(),
    HistoryRepository? historyRepository,
    MemoryRepository? memoryRepository,
    SettingsRepository? settingsRepository,
  })  : _engine = engine,
        _historyRepository = historyRepository ?? HiveHistoryRepository(),
        _memoryRepository = memoryRepository ?? HiveMemoryRepository(),
        _settingsRepository = settingsRepository ?? HiveSettingsRepository() {
    _state = _state.copyWith(
      history: _historyRepository.load(),
      memoryValue: _memoryRepository.load()?.value,
      settings: _settingsRepository.load(),
    );
  }

  final CalculatorEngine _engine;
  final HistoryRepository _historyRepository;
  final MemoryRepository _memoryRepository;
  final SettingsRepository _settingsRepository;
  CalculatorState _state = const CalculatorState();

  CalculatorState get state => _state;

  HistoryRepository get historyRepository => _historyRepository;
  MemoryRepository get memoryRepository => _memoryRepository;
  SettingsRepository get settingsRepository => _settingsRepository;

  bool _isOperator(String char) {
    return ['+', '-', '*', '/', '^'].contains(char);
  }

  void append(String value) {
    final expression = _state.errorMessage == null ? _state.expression : '';

    if (expression.isNotEmpty &&
        _isOperator(value) &&
        _isOperator(expression[expression.length - 1])) {
      final nextExpression =
          expression.substring(0, expression.length - 1) + value;
      _state = _state.copyWith(
        expression: nextExpression,
        display: _getLiveResult(nextExpression) ?? nextExpression,
        clearError: true,
      );
      return;
    }

    final nextValue =
        _state.errorMessage == null ? value : _normalizeReplacement(value);
    final nextExpression = '$expression$nextValue';
    _state = _state.copyWith(
      expression: nextExpression,
      display: _getLiveResult(nextExpression) ?? nextExpression,
      clearError: true,
    );
  }

  void applyFunction(String functionName) {
    final expression = _state.errorMessage == null ? _state.expression : '';
    final nextExpression = '$expression$functionName(';

    _state = _state.copyWith(
      expression: nextExpression,
      display: _getLiveResult(nextExpression) ?? nextExpression,
      clearError: true,
    );
  }

  void pasteExpression(String value) {
    _state = _state.copyWith(
      expression: value,
      display: _getLiveResult(value) ?? value,
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

    final nextExpression =
        expression.startsWith('-') ? expression.substring(1) : '-$expression';

    _state = _state.copyWith(
      expression: nextExpression,
      display: _getLiveResult(nextExpression) ?? nextExpression,
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
        display: _getLiveResult('$expression/100') ?? '$expression/100',
        clearError: true,
      );
      return;
    }

    final value = parsed / 100;
    final display = _formatValue(Decimal.parse(value.toString()));
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
      settings: _settingsRepository.load(),
    );
  }

  void backspace() {
    if (_state.expression.isEmpty) {
      return;
    }

    final nextExpression =
        _state.expression.substring(0, _state.expression.length - 1);
    _state = _state.copyWith(
      expression: nextExpression,
      display: nextExpression.isEmpty
          ? '0'
          : (_getLiveResult(nextExpression) ?? nextExpression),
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

    final display = _formatValue(Decimal.parse(memoryValue.value.toString()));
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

  void refreshMemoryState() {
    _state = _state.copyWith(
      memoryValue: _memoryRepository.load()?.value,
      clearMemoryValue: _memoryRepository.load() == null,
      clearError: true,
    );
  }

  void updateThemeMode(CalculatorThemeMode themeMode) {
    _saveSettings(_state.settings.copyWith(themeMode: themeMode));
  }

  void updateTextScale(TextScalePreference textScale) {
    _saveSettings(_state.settings.copyWith(textScale: textScale));
  }

  void updateDecimalPrecision(int decimalPrecision) {
    _saveSettings(
      _state.settings.copyWith(
        decimalPrecision: decimalPrecision.clamp(2, 10),
      ),
    );
  }

  void updateHapticsEnabled(bool isEnabled) {
    _saveSettings(_state.settings.copyWith(hapticsEnabled: isEnabled));
  }

  void updateSoundEnabled(bool isEnabled) {
    _saveSettings(_state.settings.copyWith(soundEnabled: isEnabled));
  }

  void applySettings(AppSettings settings) {
    _saveSettings(settings);
  }

  String _normalizeReplacement(String value) {
    if (value == '.') {
      return '0.';
    }
    return value;
  }

  String _formatValue(Decimal value) {
    if (value.isInteger) {
      return NumberFormat.decimalPattern().format(value.toBigInt().toInt());
    }

    final formatter = NumberFormat.decimalPattern()
      ..maximumFractionDigits = _state.settings.decimalPrecision;
    return formatter.format(value.toDouble());
  }

  double? _parseDisplayValue() {
    final candidate = double.tryParse(_state.display);
    if (candidate != null) {
      return candidate;
    }

    return double.tryParse(_state.expression);
  }

  String? _getLiveResult(String expr) {
    if (expr.isEmpty) return null;

    String evalStr = expr;
    while (evalStr.isNotEmpty &&
        (_isOperator(evalStr[evalStr.length - 1]) ||
            evalStr[evalStr.length - 1] == '.' ||
            evalStr[evalStr.length - 1] == '(')) {
      evalStr = evalStr.substring(0, evalStr.length - 1);
    }

    if (evalStr.isEmpty) return null;

    final result = _engine.evaluate(evalStr, angleMode: _state.angleMode);
    if (result.isSuccess) {
      return _formatValue(result.value!);
    }
    return null;
  }

  void _saveSettings(AppSettings settings) {
    _state = _state.copyWith(
      settings: _settingsRepository.save(settings),
      clearError: true,
    );
  }
}

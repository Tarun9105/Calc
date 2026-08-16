import 'dart:math' as math;

import 'angle_mode.dart';
import 'calculator_error.dart';
import 'calculator_result.dart';

class CalculatorEngine {
  const CalculatorEngine();

  CalculatorResult evaluate(
    String expression, {
    AngleMode angleMode = AngleMode.degrees,
  }) {
    final trimmed = expression.trim();
    if (trimmed.isEmpty) {
      return const CalculatorResult.failure(
        CalculatorError.invalidExpression,
      );
    }

    try {
      final parser = _Parser(trimmed, angleMode);
      final value = parser.parse();
      if (value.isInfinite || value.isNaN) {
        return const CalculatorResult.failure(CalculatorError.overflow);
      }
      return CalculatorResult.success(value);
    } on _CalculatorException catch (error) {
      return CalculatorResult.failure(error.error);
    } catch (_) {
      return const CalculatorResult.failure(CalculatorError.invalidExpression);
    }
  }
}

class _Parser {
  static const _epsilon = 0.0000000001;

  _Parser(this.input, this.angleMode);

  final String input;
  final AngleMode angleMode;
  int index = 0;

  double parse() {
    final value = _parseExpression();
    _skipWhitespace();
    if (!_isAtEnd) {
      throw const _CalculatorException(CalculatorError.invalidExpression);
    }
    return value;
  }

  double _parseExpression() {
    var value = _parseTerm();
    while (true) {
      _skipWhitespace();
      if (_match('+')) {
        value += _parseTerm();
      } else if (_match('-')) {
        value -= _parseTerm();
      } else {
        return value;
      }
    }
  }

  double _parseTerm() {
    var value = _parsePower();
    while (true) {
      _skipWhitespace();
      if (_match('*')) {
        value *= _parsePower();
      } else if (_match('/')) {
        final divisor = _parsePower();
        if (divisor == 0) {
          throw const _CalculatorException(CalculatorError.divideByZero);
        }
        value /= divisor;
      } else if (_match('%')) {
        final divisor = _parsePower();
        if (divisor == 0) {
          throw const _CalculatorException(CalculatorError.divideByZero);
        }
        value %= divisor;
      } else if (_matchIdentifier('mod')) {
        final divisor = _parsePower();
        if (divisor == 0) {
          throw const _CalculatorException(CalculatorError.divideByZero);
        }
        value %= divisor;
      } else {
        return value;
      }
    }
  }

  double _parsePower() {
    var value = _parseUnary();
    _skipWhitespace();
    if (_match('^')) {
      value = math.pow(value, _parsePower()).toDouble();
    }
    return value;
  }

  double _parseUnary() {
    _skipWhitespace();
    if (_match('+')) {
      return _parseUnary();
    }
    if (_match('-')) {
      return -_parseUnary();
    }
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skipWhitespace();
    if (_match('(')) {
      final value = _parseExpression();
      _skipWhitespace();
      if (!_match(')')) {
        throw const _CalculatorException(CalculatorError.invalidExpression);
      }
      return value;
    }

    if (_peekIsLetter) {
      final identifier = _parseIdentifier();
      if (identifier == 'pi') {
        return math.pi;
      }
      if (identifier == 'e') {
        return math.e;
      }

      _skipWhitespace();
      if (!_match('(')) {
        throw const _CalculatorException(CalculatorError.invalidExpression);
      }
      final argument = _parseExpression();
      _skipWhitespace();
      if (!_match(')')) {
        throw const _CalculatorException(CalculatorError.invalidExpression);
      }
      return _applyFunction(identifier, argument);
    }

    return _parseNumber();
  }

  double _parseNumber() {
    _skipWhitespace();
    final start = index;
    var hasDecimal = false;

    while (!_isAtEnd) {
      final char = input[index];
      if (_isDigit(char)) {
        index++;
        continue;
      }
      if (char == '.' && !hasDecimal) {
        hasDecimal = true;
        index++;
        continue;
      }
      break;
    }

    if (start == index) {
      throw const _CalculatorException(CalculatorError.invalidExpression);
    }

    return double.parse(input.substring(start, index));
  }

  double _applyFunction(String identifier, double value) {
    switch (identifier) {
      case 'sin':
        return math.sin(_toRadians(value));
      case 'cos':
        return math.cos(_toRadians(value));
      case 'tan':
        return math.tan(_toRadians(value));
      case 'asin':
        if (value < -1 || value > 1) {
          throw const _CalculatorException(CalculatorError.invalidInverseTrig);
        }
        return _fromRadians(math.asin(value));
      case 'acos':
        if (value < -1 || value > 1) {
          throw const _CalculatorException(CalculatorError.invalidInverseTrig);
        }
        return _fromRadians(math.acos(value));
      case 'atan':
        return _fromRadians(math.atan(value));
      case 'sqrt':
        if (value < 0) {
          throw const _CalculatorException(CalculatorError.negativeSqrt);
        }
        return math.sqrt(value);
      case 'ln':
        if (value <= 0) {
          throw const _CalculatorException(CalculatorError.negativeLog);
        }
        return math.log(value);
      case 'log':
        if (value <= 0) {
          throw const _CalculatorException(CalculatorError.negativeLog);
        }
        return math.log(value) / math.ln10;
      case 'abs':
        return value.abs();
      case 'inv':
        if (value == 0) {
          throw const _CalculatorException(CalculatorError.divideByZero);
        }
        return 1 / value;
      case 'square':
        return value * value;
      case 'cube':
        return value * value * value;
      case 'factorial':
        return _factorial(value);
      default:
        throw const _CalculatorException(CalculatorError.invalidExpression);
    }
  }

  double _factorial(double value) {
    if (value < 0 || (value - value.roundToDouble()).abs() > _epsilon) {
      throw const _CalculatorException(CalculatorError.invalidFactorial);
    }

    final integerValue = value.toInt();
    var result = 1.0;
    for (var i = 2; i <= integerValue; i++) {
      result *= i;
      if (result.isInfinite) {
        throw const _CalculatorException(CalculatorError.overflow);
      }
    }
    return result;
  }

  double _toRadians(double value) {
    switch (angleMode) {
      case AngleMode.degrees:
        return value * math.pi / 180;
      case AngleMode.radians:
        return value;
      case AngleMode.gradians:
        return value * math.pi / 200;
    }
  }

  double _fromRadians(double value) {
    switch (angleMode) {
      case AngleMode.degrees:
        return value * 180 / math.pi;
      case AngleMode.radians:
        return value;
      case AngleMode.gradians:
        return value * 200 / math.pi;
    }
  }

  String _parseIdentifier() {
    final start = index;
    while (!_isAtEnd && _isLetter(input[index])) {
      index++;
    }
    return input.substring(start, index).toLowerCase();
  }

  void _skipWhitespace() {
    while (!_isAtEnd && input[index].trim().isEmpty) {
      index++;
    }
  }

  bool _match(String expected) {
    _skipWhitespace();
    if (_isAtEnd || input[index] != expected) {
      return false;
    }
    index++;
    return true;
  }

  bool _matchIdentifier(String expected) {
    _skipWhitespace();
    final end = index + expected.length;
    if (end > input.length) {
      return false;
    }

    final candidate = input.substring(index, end).toLowerCase();
    if (candidate != expected) {
      return false;
    }

    if (end < input.length && _isLetter(input[end])) {
      return false;
    }

    index = end;
    return true;
  }

  bool get _isAtEnd => index >= input.length;
  bool get _peekIsLetter => !_isAtEnd && _isLetter(input[index]);

  bool _isDigit(String value) => value.codeUnitAt(0) >= 48 && value.codeUnitAt(0) <= 57;
  bool _isLetter(String value) {
    final code = value.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }
}

class _CalculatorException implements Exception {
  const _CalculatorException(this.error);

  final CalculatorError error;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smartcalc/features/calculator/domain/angle_mode.dart';
import 'package:smartcalc/features/calculator/domain/calculator_engine.dart';
import 'package:smartcalc/features/calculator/domain/calculator_error.dart';

void main() {
  const engine = CalculatorEngine();

  group('CalculatorEngine', () {
    test('respects arithmetic precedence', () {
      final result = engine.evaluate('2 + 3 * 4');
      expect(result.isSuccess, isTrue);
      expect(result.value, 14);
    });

    test('respects parentheses precedence', () {
      final result = engine.evaluate('(2 + 3) * 4');
      expect(result.isSuccess, isTrue);
      expect(result.value, 20);
    });

    test('returns divide by zero error', () {
      final result = engine.evaluate('8 / 0');
      expect(result.error, CalculatorError.divideByZero);
    });

    test('supports trig in degree mode', () {
      final result = engine.evaluate('sin(90)', angleMode: AngleMode.degrees);
      expect(result.isSuccess, isTrue);
      expect(result.value, closeTo(1, 0.000001));
    });

    test('supports power operations', () {
      final result = engine.evaluate('2 ^ 3 ^ 2');
      expect(result.isSuccess, isTrue);
      expect(result.value, 512);
    });

    test('supports constants and logarithms', () {
      final result = engine.evaluate('log(100) + ln(e)');
      expect(result.isSuccess, isTrue);
      expect(result.value, closeTo(3, 0.000001));
    });

    test('supports gradians for trig conversion', () {
      final result = engine.evaluate('sin(100)', angleMode: AngleMode.gradians);
      expect(result.isSuccess, isTrue);
      expect(result.value, closeTo(1, 0.000001));
    });

    test('supports factorial helper function', () {
      final result = engine.evaluate('factorial(5)');
      expect(result.isSuccess, isTrue);
      expect(result.value, 120);
    });

    test('rejects invalid factorial input', () {
      final result = engine.evaluate('factorial(3.5)');
      expect(result.error, CalculatorError.invalidFactorial);
    });

    test('rejects invalid inverse trig input', () {
      final result = engine.evaluate('asin(2)');
      expect(result.error, CalculatorError.invalidInverseTrig);
    });

    test('rejects malformed expressions', () {
      final result = engine.evaluate('2 + * 3');
      expect(result.error, CalculatorError.invalidExpression);
    });
  });
}

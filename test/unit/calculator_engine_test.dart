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
  });
}

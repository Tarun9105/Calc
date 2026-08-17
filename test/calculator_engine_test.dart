import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:smartcalc/features/calculator/domain/calculator_engine.dart';

void main() {
  group('CalculatorEngine', () {
    final engine = const CalculatorEngine();

    test('evaluates basic addition', () {
      final result = engine.evaluate('2+2');
      expect(result.isSuccess, isTrue);
      expect(result.value, Decimal.parse('4'));
    });

    test('evaluates decimal addition correctly (0.1 + 0.2 = 0.3)', () {
      final result = engine.evaluate('0.1+0.2');
      expect(result.isSuccess, isTrue);
      expect(result.value, Decimal.parse('0.3'));
    });

    test('evaluates implicit multiplication', () {
      final result = engine.evaluate('2(3)');
      expect(result.isSuccess, isTrue);
      expect(result.value, Decimal.parse('6'));
    });
  });
}

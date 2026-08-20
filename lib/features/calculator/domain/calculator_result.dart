import 'package:decimal/decimal.dart';
import 'calculator_error.dart';

class CalculatorResult {
  const CalculatorResult._({
    this.value,
    this.error,
  });

  const CalculatorResult.success(Decimal value) : this._(value: value);

  const CalculatorResult.failure(CalculatorError error) : this._(error: error);

  final Decimal? value;
  final CalculatorError? error;

  bool get isSuccess => error == null;
}

import 'calculator_error.dart';

class CalculatorResult {
  const CalculatorResult._({
    this.value,
    this.error,
  });

  const CalculatorResult.success(double value) : this._(value: value);

  const CalculatorResult.failure(CalculatorError error) : this._(error: error);

  final double? value;
  final CalculatorError? error;

  bool get isSuccess => error == null;
}


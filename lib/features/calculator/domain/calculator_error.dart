enum CalculatorError {
  invalidExpression,
  divideByZero,
  negativeSqrt,
  negativeLog,
  overflow,
}

extension CalculatorErrorMessage on CalculatorError {
  String get message {
    switch (this) {
      case CalculatorError.invalidExpression:
        return 'Invalid expression';
      case CalculatorError.divideByZero:
        return 'Cannot divide by zero';
      case CalculatorError.negativeSqrt:
        return 'Cannot take the square root of a negative number';
      case CalculatorError.negativeLog:
        return 'Cannot take the logarithm of a non-positive number';
      case CalculatorError.overflow:
        return 'Result too large to display';
    }
  }
}


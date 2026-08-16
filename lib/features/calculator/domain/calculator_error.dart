enum CalculatorError {
  invalidExpression,
  divideByZero,
  negativeSqrt,
  negativeLog,
  invalidFactorial,
  invalidInverseTrig,
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
      case CalculatorError.invalidFactorial:
        return 'Factorial is only defined for non-negative integers';
      case CalculatorError.invalidInverseTrig:
        return 'Inverse trig input is out of range';
      case CalculatorError.overflow:
        return 'Result too large to display';
    }
  }
}

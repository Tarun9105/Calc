class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.display = '0',
    this.errorMessage,
  });

  final String expression;
  final String display;
  final String? errorMessage;

  CalculatorState copyWith({
    String? expression,
    String? display,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      display: display ?? this.display,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}


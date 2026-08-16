import 'package:flutter_test/flutter_test.dart';
import 'package:smartcalc/features/calculator/presentation/calculator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('renders portrait calculator controls', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CalculatorScreen(),
      ),
    );

    expect(find.text('AC'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('0'), findsAtLeastNWidgets(1));
  });
}

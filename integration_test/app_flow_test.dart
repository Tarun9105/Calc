import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smartcalc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on basic arithmetic operators and calculate result',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap 2 + 3 = 5
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets('verify memory operations', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Ensure clear first
      await tester.tap(find.text('AC'));
      await tester.pumpAndSettle();

      // Type 9 and Store
      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();
      
      // Store in memory (MS button)
      await tester.tap(find.text('MS'));
      await tester.pumpAndSettle();

      // Clear display
      await tester.tap(find.text('AC'));
      await tester.pumpAndSettle();

      // Recall memory (MR button)
      await tester.tap(find.text('MR'));
      await tester.pumpAndSettle();

      // Ensure 9 is displayed
      expect(find.text('9'), findsWidgets);
    });
  });
}

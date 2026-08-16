import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:smartcalc/features/calculator/presentation/calculator_screen.dart';

void main() {
  testWidgets('renders portrait calculator controls', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CalculatorScreen(),
      ),
    );

    expect(find.text('AC'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('0'), findsAtLeastNWidgets(1));
  });

  testWidgets('renders scientific keypad in landscape', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CalculatorScreen(),
      ),
    );

    expect(find.text('sin'), findsOneWidget);
    expect(find.text('DEG'), findsAtLeastNWidgets(1));
    expect(find.text('π'), findsOneWidget);
  });

  testWidgets('renders history and memory controls', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CalculatorScreen(),
      ),
    );

    expect(find.text('History'), findsOneWidget);
    expect(find.text('MS'), findsOneWidget);
    expect(find.text('MR'), findsOneWidget);
  });

  testWidgets('renders settings controls', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CalculatorScreen(),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Precision'), findsOneWidget);
    expect(find.text('Haptics'), findsOneWidget);
    expect(find.text('Sound'), findsOneWidget);
  });
}

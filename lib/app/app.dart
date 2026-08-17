import 'package:flutter/material.dart';

import '../features/calculator/presentation/calculator_screen.dart';
import 'theme.dart';

class SmartCalcApp extends StatelessWidget {
  const SmartCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCalc',
      theme: buildSmartCalcTheme(context),
      home: const CalculatorScreen(),
    );
  }
}

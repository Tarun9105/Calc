import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'SmartCalc Phase 1 scaffold',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

import '../application/calculator_controller.dart';
import '../application/calculator_state.dart';
import 'calculator_display.dart';
import 'calculator_keypad.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();

  CalculatorState get _state => _controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CalculatorDisplay(
              expression: _state.expression,
              display: _state.display,
              errorMessage: _state.errorMessage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: CalculatorKeypad(
                onInput: _handleInput,
                onEvaluate: _handleEvaluate,
                onClear: _handleClear,
                onPercent: _handlePercent,
                onToggleSign: _handleToggleSign,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleInput(String value) {
    setState(() {
      _controller.append(value);
    });
  }

  void _handleEvaluate() {
    setState(() {
      _controller.evaluate();
    });
  }

  void _handleClear() {
    setState(() {
      _controller.clear();
    });
  }

  void _handlePercent() {
    setState(() {
      _controller.applyPercent();
    });
  }

  void _handleToggleSign() {
    setState(() {
      _controller.toggleSign();
    });
  }
}

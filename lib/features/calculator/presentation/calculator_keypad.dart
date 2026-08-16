import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/calculator_key_button.dart';

typedef KeyPressCallback = void Function(String value);
typedef VoidKeyCallback = void Function();

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    required this.onInput,
    required this.onEvaluate,
    required this.onClear,
    required this.onPercent,
    required this.onToggleSign,
    super.key,
  });

  final KeyPressCallback onInput;
  final VoidKeyCallback onEvaluate;
  final VoidKeyCallback onClear;
  final VoidKeyCallback onPercent;
  final VoidKeyCallback onToggleSign;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SmartCalcColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow([
          _key(
            label: 'AC',
            semanticLabel: 'all clear',
            backgroundColor: colors.function,
            foregroundColor: Colors.black,
            onPressed: onClear,
          ),
          _key(
            label: '+/-',
            semanticLabel: 'toggle sign',
            backgroundColor: colors.function,
            foregroundColor: Colors.black,
            onPressed: onToggleSign,
          ),
          _key(
            label: '%',
            semanticLabel: 'percent',
            backgroundColor: colors.function,
            foregroundColor: Colors.black,
            onPressed: onPercent,
          ),
          _key(
            label: '÷',
            semanticLabel: 'divide',
            backgroundColor: colors.operator,
            foregroundColor: Colors.white,
            onPressed: () => onInput('/'),
          ),
        ]),
        _buildRow([
          _digit(colors, '7'),
          _digit(colors, '8'),
          _digit(colors, '9'),
          _operator(colors, '×', 'multiply', '*'),
        ]),
        _buildRow([
          _digit(colors, '4'),
          _digit(colors, '5'),
          _digit(colors, '6'),
          _operator(colors, '−', 'subtract', '-'),
        ]),
        _buildRow([
          _digit(colors, '1'),
          _digit(colors, '2'),
          _digit(colors, '3'),
          _operator(colors, '+', 'add', '+'),
        ]),
        _buildRow([
          _key(
            label: '0',
            semanticLabel: '0',
            backgroundColor: colors.digit,
            foregroundColor: Colors.white,
            onPressed: () => onInput('0'),
            flex: 2,
          ),
          _key(
            label: '.',
            semanticLabel: 'decimal point',
            backgroundColor: colors.digit,
            foregroundColor: Colors.white,
            onPressed: () => onInput('.'),
          ),
          _key(
            label: '=',
            semanticLabel: 'equals',
            backgroundColor: colors.operator,
            foregroundColor: Colors.white,
            onPressed: onEvaluate,
          ),
        ]),
      ],
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(children: children);
  }

  Widget _digit(SmartCalcColors colors, String value) {
    return _key(
      label: value,
      semanticLabel: value,
      backgroundColor: colors.digit,
      foregroundColor: Colors.white,
      onPressed: () => onInput(value),
    );
  }

  Widget _operator(
    SmartCalcColors colors,
    String label,
    String semanticLabel,
    String input,
  ) {
    return _key(
      label: label,
      semanticLabel: semanticLabel,
      backgroundColor: colors.operator,
      foregroundColor: Colors.white,
      onPressed: () => onInput(input),
    );
  }

  Widget _key({
    required String label,
    required String semanticLabel,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
    int flex = 1,
  }) {
    return CalculatorKeyButton(
      label: label,
      semanticLabel: semanticLabel,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onPressed: onPressed,
      flex: flex,
    );
  }
}

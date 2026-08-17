import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/calculator_key_button.dart';

typedef ScientificActionCallback = void Function();
typedef ScientificFunctionCallback = void Function(String value);

class ScientificKeypad extends StatelessWidget {
  const ScientificKeypad({
    required this.angleModeLabel,
    required this.onFunction,
    required this.onConstant,
    required this.onPower,
    required this.onCycleAngleMode,
    this.width,
    super.key,
  });

  final String angleModeLabel;
  final ScientificFunctionCallback onFunction;
  final ScientificFunctionCallback onConstant;
  final ScientificActionCallback onPower;
  final ScientificActionCallback onCycleAngleMode;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SmartCalcColors>()!;

    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(12, 12, 0, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: _row(colors, [
            _key(colors, 'sin', 'sine', () => onFunction('sin')),
            _key(colors, 'cos', 'cosine', () => onFunction('cos')),
            _key(colors, 'tan', 'tangent', () => onFunction('tan')),
            _key(colors, angleModeLabel, 'change angle mode', onCycleAngleMode),
          ])),
          Expanded(child: _row(colors, [
            _key(colors, 'ln', 'natural logarithm', () => onFunction('ln')),
            _key(colors, 'log', 'logarithm base ten', () => onFunction('log')),
            _key(colors, '√', 'square root', () => onFunction('sqrt')),
            _key(colors, '1/x', 'inverse', () => onFunction('inv')),
          ])),
          Expanded(child: _row(colors, [
            _key(colors, 'x²', 'square', () => onFunction('square')),
            _key(colors, 'x³', 'cube', () => onFunction('cube')),
            _key(colors, 'xʸ', 'power', onPower),
            _key(colors, 'x!', 'factorial', () => onFunction('factorial')),
          ])),
          Expanded(child: _row(colors, [
            _key(colors, 'asin', 'inverse sine', () => onFunction('asin')),
            _key(colors, 'acos', 'inverse cosine', () => onFunction('acos')),
            _key(colors, 'atan', 'inverse tangent', () => onFunction('atan')),
            _key(colors, '|x|', 'absolute value', () => onFunction('abs')),
          ])),
          Expanded(child: _row(colors, [
            _key(colors, 'π', 'pi', () => onConstant('pi')),
            _key(colors, 'e', 'e constant', () => onConstant('e')),
            _key(colors, '(', 'left parenthesis', () => onConstant('(')),
            _key(colors, ')', 'right parenthesis', () => onConstant(')')),
          ])),
        ],
      ),
    );
  }

  Widget _row(SmartCalcColors colors, List<Widget> children) {
    return Row(children: children);
  }

  Widget _key(
    SmartCalcColors colors,
    String label,
    String semanticLabel,
    VoidCallback onPressed,
  ) {
    return CalculatorKeyButton(
      label: label,
      semanticLabel: semanticLabel,
      backgroundColor: colors.scientific,
      foregroundColor: Colors.white,
      onPressed: onPressed,
    );
  }
}

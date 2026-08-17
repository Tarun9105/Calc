import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/calculator_key_button.dart';

typedef KeyPressCallback = void Function(String value);
typedef VoidKeyCallback = void Function();

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    required this.onInput,
    required this.onEvaluate,
    required this.onBackspace,
    required this.onClear,
    required this.onPercent,
    required this.onToggleSign,
    this.customButtonBackgroundText,
    super.key,
  });

  final KeyPressCallback onInput;
  final VoidKeyCallback onEvaluate;
  final VoidKeyCallback onBackspace;
  final VoidKeyCallback onClear;
  final VoidKeyCallback onPercent;
  final VoidKeyCallback onToggleSign;
  final String? customButtonBackgroundText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SmartCalcColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _buildRow([
          _key(
            label: '⌫', // Standard backspace symbol, or we can use 'C'
            semanticLabel: 'delete',
            backgroundColor: colors.function,
            foregroundColor: Colors.black,
            onPressed: onBackspace,
            onLongPress: onClear,
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
        ])),
        Expanded(child: _buildRow([
          _digit(colors, '7', context),
          _digit(colors, '8', context),
          _digit(colors, '9', context),
          _operator(colors, '×', 'multiply', '*'),
        ])),
        Expanded(child: _buildRow([
          _digit(colors, '4', context),
          _digit(colors, '5', context),
          _digit(colors, '6', context),
          _operator(colors, '−', 'subtract', '-'),
        ])),
        Expanded(child: _buildRow([
          _digit(colors, '1', context),
          _digit(colors, '2', context),
          _digit(colors, '3', context),
          _operator(colors, '+', 'add', '+'),
        ])),
        Expanded(child: _buildRow([
          _key(
            label: '0',
            semanticLabel: '0',
            backgroundColor: colors.digit,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            onPressed: () => onInput('0'),
            flex: 2,
          ),
          _key(
            label: '.',
            semanticLabel: 'decimal point',
            backgroundColor: colors.digit,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            onPressed: () => onInput('.'),
          ),
          _key(
            label: '=',
            semanticLabel: 'equals',
            backgroundColor: colors.operator,
            foregroundColor: Colors.white,
            onPressed: onEvaluate,
          ),
        ])),
      ],
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(children: children);
  }

  Widget _digit(SmartCalcColors colors, String value, BuildContext context) {
    return _key(
      label: value,
      semanticLabel: value,
      backgroundColor: colors.digit,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
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
    VoidCallback? onLongPress,
    int flex = 1,
  }) {
    return CalculatorKeyButton(
      label: label,
      semanticLabel: semanticLabel,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onPressed: onPressed,
      onLongPress: onLongPress,
      flex: flex,
      customBackgroundText: customButtonBackgroundText,
    );
  }
}

import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({
    required this.expression,
    required this.display,
    required this.errorMessage,
    super.key,
  });

  final String expression;
  final String display;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayStyle = theme.textTheme.displayLarge ?? const TextStyle(fontSize: 64);
    final expressionStyle = theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 18);

    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        alignment: Alignment.bottomRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              expression.isEmpty ? '0' : expression,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: expressionStyle.copyWith(color: Colors.white60),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                display,
                textAlign: TextAlign.right,
                style: displayStyle.copyWith(
                  color: errorMessage == null ? Colors.white : const Color(0xFFFF7B72),
                ),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                textAlign: TextAlign.right,
                style: expressionStyle.copyWith(
                  color: const Color(0xFFFF7B72),
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


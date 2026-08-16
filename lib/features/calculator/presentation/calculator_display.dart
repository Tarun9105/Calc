import 'package:flutter/material.dart';

import '../domain/angle_mode.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({
    required this.expression,
    required this.display,
    required this.angleMode,
    required this.errorMessage,
    super.key,
  });

  final String expression;
  final String display;
  final AngleMode angleMode;
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
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  angleMode.shortLabel,
                  style: expressionStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
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


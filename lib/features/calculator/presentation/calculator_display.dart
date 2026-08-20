import 'package:flutter/material.dart';

import '../domain/angle_mode.dart';
import '../../settings/domain/app_settings.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({
    required this.expression,
    required this.display,
    required this.angleMode,
    required this.settings,
    required this.errorMessage,
    this.onAngleModeTapped,
    super.key,
  });

  final String expression;
  final String display;
  final AngleMode angleMode;
  final AppSettings settings;
  final String? errorMessage;
  final VoidCallback? onAngleModeTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = settings.textScale.scale;
    final displayStyle =
        theme.textTheme.displayLarge ?? const TextStyle(fontSize: 64);
    final expressionStyle =
        theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 18);
    final mutedText = settings.themeMode == CalculatorThemeMode.light
        ? Colors.black54
        : Colors.white60;
    final primaryText = settings.themeMode == CalculatorThemeMode.light
        ? Colors.black
        : Colors.white;
    final badgeColor = settings.themeMode == CalculatorThemeMode.light
        ? Colors.black.withValues(alpha: 0.08)
        : Colors.white10;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      alignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAngleModeTapped,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    angleMode.shortLabel,
                    style: expressionStyle.copyWith(
                      color: mutedText,
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            label: 'Expression: ${expression.isEmpty ? '0' : expression}',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                expression.isEmpty ? '0' : expression,
                style: expressionStyle.copyWith(
                  color: mutedText,
                  fontSize: 18 * scale,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Semantics(
              label: 'Result: $display',
              child: Text(
                display,
                textAlign: TextAlign.right,
                style: displayStyle.copyWith(
                  fontSize: 64 * scale,
                  color: errorMessage == null
                      ? primaryText
                      : const Color(0xFFFF7B72),
                ),
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
    );
  }
}

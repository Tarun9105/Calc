import 'package:flutter/material.dart';

class CalculatorKeyButton extends StatelessWidget {
  const CalculatorKeyButton({
    required this.label,
    required this.semanticLabel,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.onLongPress,
    this.customBackgroundText,
    this.flex = 1,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final String? customBackgroundText;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Material(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(flex == 2 ? 34 : 999),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(flex == 2 ? 34 : 999),
                onTap: onPressed,
                onLongPress: onLongPress,
                child: Align(
                  alignment: flex == 2 ? Alignment.centerLeft : Alignment.center,
                  child: Padding(
                    padding: flex == 2 ? const EdgeInsets.only(left: 32) : EdgeInsets.zero,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (customBackgroundText != null && customBackgroundText!.isNotEmpty)
                          FittedBox(
                            child: Text(
                              customBackgroundText!,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.blue.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: foregroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class CalculatorKeyButton extends StatelessWidget {
  const CalculatorKeyButton({
    required this.label,
    required this.semanticLabel,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.onLongPress,
    this.flex = 1,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
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
                    padding: EdgeInsets.only(left: flex == 2 ? 24 : 0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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


import 'package:flutter/material.dart';

class MemoryToolbar extends StatelessWidget {
  const MemoryToolbar({
    required this.memoryValue,
    required this.onMemoryClear,
    required this.onMemoryRecall,
    required this.onMemoryAdd,
    required this.onMemorySubtract,
    required this.onMemoryStore,
    super.key,
  });

  final double? memoryValue;
  final VoidCallback onMemoryClear;
  final VoidCallback onMemoryRecall;
  final VoidCallback onMemoryAdd;
  final VoidCallback onMemorySubtract;
  final VoidCallback onMemoryStore;

  @override
  Widget build(BuildContext context) {
    final hasMemory = memoryValue != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _memoryButton('MC', onMemoryClear, enabled: hasMemory),
          _memoryButton('MR', onMemoryRecall, enabled: hasMemory),
          _memoryButton('M+', onMemoryAdd),
          _memoryButton('M-', onMemorySubtract),
          _memoryButton('MS', onMemoryStore),
          if (hasMemory)
            Chip(
              label: Text(
                'M ${_format(memoryValue!)}',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              backgroundColor: colorScheme.onSurface.withValues(alpha: 0.08),
              side: BorderSide.none,
            ),
        ],
      ),
    );
  }

  Widget _memoryButton(
    String label,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      child: Text(label),
    );
  }

  String _format(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}

import 'package:flutter/material.dart';

import '../domain/history_entry.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({
    required this.history,
    required this.onRecall,
    required this.onDelete,
    required this.onClearAll,
    super.key,
  });

  final List<HistoryEntry> history;
  final ValueChanged<int> onRecall;
  final ValueChanged<int> onDelete;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.7);

    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No history yet. Complete a calculation to reuse it here.',
              style: TextStyle(color: muted),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onClearAll,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return ListTile(
                title: Text(
                  entry.expression,
                  style: TextStyle(color: muted),
                ),
                subtitle: Text(
                  entry.result,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => onRecall(index),
                trailing: IconButton(
                  onPressed: () => onDelete(index),
                  icon: const Icon(Icons.delete_outline),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

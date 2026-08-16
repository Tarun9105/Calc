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
    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'No history yet. Complete a calculation to reuse it here.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    color: Colors.white,
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
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  title: Text(
                    entry.expression,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    entry.result,
                    style: const TextStyle(
                      color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

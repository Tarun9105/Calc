import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../features/settings/domain/app_settings.dart';
import '../../history/presentation/history_panel.dart';
import '../application/memory_controller.dart';
import 'memory_toolbar.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({
    required this.controller,
    required this.themeMode,
    super.key,
  });

  /// Shared [MemoryController] so that memory/history actions are persisted.
  final MemoryController controller;

  /// Theme to use for this screen (kept in sync with calculator's setting).
  final CalculatorThemeMode themeMode;

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  MemoryController get _ctrl => widget.controller;

  @override
  void initState() {
    super.initState();
    _ctrl.refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildSmartCalcTheme(themeMode: widget.themeMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Memory & History'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Memory section ──────────────────────────────────────────
                _SectionLabel(label: 'Memory'),
                const SizedBox(height: 8),
                MemoryToolbar(
                  memoryValue: _ctrl.memoryValue,
                  onMemoryClear: () => setState(_ctrl.memoryClear),
                  onMemoryRecall: () => setState(
                    () => _ctrl.memoryRecall((_) {}),
                  ),
                  onMemoryAdd: () => setState(
                    () => _ctrl.memoryAdd(_ctrl.memoryValue ?? 0),
                  ),
                  onMemorySubtract: () => setState(
                    () => _ctrl.memorySubtract(_ctrl.memoryValue ?? 0),
                  ),
                  onMemoryStore: () => setState(
                    () => _ctrl.memoryStore(_ctrl.memoryValue ?? 0),
                  ),
                ),
                const SizedBox(height: 24),
                // ── History section ──────────────────────────────────────────
                _SectionLabel(label: 'History'),
                const SizedBox(height: 8),
                HistoryPanel(
                  history: _ctrl.history,
                  onRecall: (index) => setState(() {
                    _ctrl.recallHistory(index);
                  }),
                  onDelete: (index) =>
                      setState(() => _ctrl.deleteHistory(index)),
                  onClearAll: () => setState(_ctrl.clearHistory),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}

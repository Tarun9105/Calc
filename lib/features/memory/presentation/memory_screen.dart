import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../features/settings/domain/app_settings.dart';
import '../../history/presentation/history_panel.dart';
import '../application/memory_controller.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({
    required this.controller,
    required this.settings,
    super.key,
  });

  final MemoryController controller;

  final AppSettings settings;

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
      data: buildSmartCalcTheme(
        context,
        themeMode: widget.settings.themeMode,
        customOperatorColor: widget.settings.customOperatorColorValue != null
            ? Color(widget.settings.customOperatorColorValue!)
            : null,
      ),
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
                const SizedBox(height: 8),
                _SectionLabel(label: 'History'),
                const SizedBox(height: 8),
                HistoryPanel(
                  history: _ctrl.history,
                  onRecall: (index) {
                    final recalledString = _ctrl.recallHistory(index);
                    if (recalledString != null) {
                      Navigator.of(context).pop(recalledString);
                    }
                  },
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

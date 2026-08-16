import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../application/calculator_controller.dart';
import '../application/calculator_state.dart';
import '../domain/angle_mode.dart';
import '../../history/presentation/history_panel.dart';
import '../../memory/presentation/memory_toolbar.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_panel.dart';
import 'calculator_display.dart';
import 'calculator_keypad.dart';
import 'scientific_keypad.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();

  CalculatorState get _state => _controller.state;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Theme(
      data: buildSmartCalcTheme(themeMode: _state.settings.themeMode),
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (isLandscape)
                ScientificKeypad(
                  angleModeLabel: _state.angleMode.shortLabel,
                  onFunction: _handleFunction,
                  onConstant: _handleInput,
                  onPower: _handlePower,
                  onCycleAngleMode: _handleCycleAngleMode,
                ),
              Expanded(
                child: Column(
                  children: [
                    CalculatorDisplay(
                      expression: _state.expression,
                      display: _state.display,
                      angleMode: _state.angleMode,
                      settings: _state.settings,
                      errorMessage: _state.errorMessage,
                    ),
                    if (!isLandscape) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: SettingsPanel(
                          settings: _state.settings,
                          onThemeChanged: _handleThemeChanged,
                          onTextScaleChanged: _handleTextScaleChanged,
                          onPrecisionChanged: _handlePrecisionChanged,
                          onHapticsChanged: _handleHapticsChanged,
                          onSoundChanged: _handleSoundChanged,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: MemoryToolbar(
                          memoryValue: _state.memoryValue,
                          onMemoryClear: _handleMemoryClear,
                          onMemoryRecall: _handleMemoryRecall,
                          onMemoryAdd: _handleMemoryAdd,
                          onMemorySubtract: _handleMemorySubtract,
                          onMemoryStore: _handleMemoryStore,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: HistoryPanel(
                          history: _state.history,
                          onRecall: _handleRecallHistory,
                          onDelete: _handleDeleteHistory,
                          onClearAll: _handleClearHistory,
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                      child: CalculatorKeypad(
                        onInput: _handleInput,
                        onEvaluate: _handleEvaluate,
                        onClear: _handleClear,
                        onPercent: _handlePercent,
                        onToggleSign: _handleToggleSign,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleInput(String value) {
    setState(() {
      _controller.append(value);
    });
  }

  void _handleEvaluate() {
    setState(() {
      _controller.evaluate();
    });
  }

  void _handleClear() {
    setState(() {
      _controller.clear();
    });
  }

  void _handlePercent() {
    setState(() {
      _controller.applyPercent();
    });
  }

  void _handleToggleSign() {
    setState(() {
      _controller.toggleSign();
    });
  }

  void _handleFunction(String functionName) {
    setState(() {
      _controller.applyFunction(functionName);
    });
  }

  void _handlePower() {
    setState(() {
      _controller.appendPower();
    });
  }

  void _handleCycleAngleMode() {
    setState(() {
      _controller.cycleAngleMode();
    });
  }

  void _handleRecallHistory(int index) {
    setState(() {
      _controller.recallHistory(index);
    });
  }

  void _handleDeleteHistory(int index) {
    setState(() {
      _controller.deleteHistoryEntry(index);
    });
  }

  void _handleClearHistory() {
    setState(() {
      _controller.clearHistory();
    });
  }

  void _handleMemoryStore() {
    setState(() {
      _controller.memoryStore();
    });
  }

  void _handleMemoryRecall() {
    setState(() {
      _controller.memoryRecall();
    });
  }

  void _handleMemoryClear() {
    setState(() {
      _controller.memoryClear();
    });
  }

  void _handleMemoryAdd() {
    setState(() {
      _controller.memoryAdd();
    });
  }

  void _handleMemorySubtract() {
    setState(() {
      _controller.memorySubtract();
    });
  }

  void _handleThemeChanged(CalculatorThemeMode themeMode) {
    setState(() {
      _controller.updateThemeMode(themeMode);
    });
  }

  void _handleTextScaleChanged(TextScalePreference textScale) {
    setState(() {
      _controller.updateTextScale(textScale);
    });
  }

  void _handlePrecisionChanged(int precision) {
    setState(() {
      _controller.updateDecimalPrecision(precision);
    });
  }

  void _handleHapticsChanged(bool isEnabled) {
    setState(() {
      _controller.updateHapticsEnabled(isEnabled);
    });
  }

  void _handleSoundChanged(bool isEnabled) {
    setState(() {
      _controller.updateSoundEnabled(isEnabled);
    });
  }
}

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../application/calculator_controller.dart';
import '../application/calculator_state.dart';
import '../domain/angle_mode.dart';
import '../../memory/application/memory_controller.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../memory/presentation/memory_toolbar.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_screen.dart';
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

  late final SettingsController _settingsController = SettingsController(
    settingsRepository: _controller.settingsRepository,
  );

  late final MemoryController _memoryController = MemoryController(
    memoryRepository: _controller.memoryRepository,
    historyRepository: _controller.historyRepository,
  );

  CalculatorState get _state => _controller.state;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Theme(
      data: buildSmartCalcTheme(themeMode: _state.settings.themeMode),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Settings icon — top left
          leading: IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.tune_rounded),
            onPressed: _openSettings,
          ),
          // Memory & History icon — top right
          actions: [
            IconButton(
              tooltip: 'Memory & History',
              icon: const Icon(Icons.history_rounded),
              onPressed: _openMemory,
            ),
          ],
        ),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: MemoryToolbar(
                        memoryValue: _state.memoryValue,
                        onMemoryClear: () => setState(() => _controller.memoryClear()),
                        onMemoryRecall: () => setState(() => _controller.memoryRecall()),
                        onMemoryAdd: () => setState(() => _controller.memoryAdd()),
                        onMemorySubtract: () => setState(() => _controller.memorySubtract()),
                        onMemoryStore: () => setState(() => _controller.memoryStore()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                      child: CalculatorKeypad(
                        onInput: _handleInput,
                        onEvaluate: _handleEvaluate,
                        onBackspace: _handleBackspace,
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

  // ── Navigation ──────────────────────────────────────────────────────────────

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(controller: _settingsController),
      ),
    );
    // Rebuild so the calculator display picks up any setting changes.
    setState(() {
      _controller.updateThemeMode(_settingsController.settings.themeMode);
      _controller.updateTextScale(_settingsController.settings.textScale);
      _controller.updateDecimalPrecision(
          _settingsController.settings.decimalPrecision);
      _controller
          .updateHapticsEnabled(_settingsController.settings.hapticsEnabled);
      _controller
          .updateSoundEnabled(_settingsController.settings.soundEnabled);
    });
  }

  Future<void> _openMemory() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (_) => MemoryScreen(
          controller: _memoryController,
          themeMode: _state.settings.themeMode,
        ),
      ),
    );
    
    // Sync state back to calculator state.
    setState(() {
      if (result is String) {
        _controller.pasteExpression(result);
      }
      _controller.refreshMemoryState();
    });
  }

  // ── Handlers ────────────────────────────────────────────────────────────────

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

  void _handleBackspace() {
    setState(() {
      _controller.backspace();
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
}

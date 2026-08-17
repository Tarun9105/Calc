import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../application/settings_controller.dart';
import '../presentation/settings_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.controller, super.key});

  /// Shared [SettingsController] passed from [CalculatorScreen] so that theme
  /// changes are reflected immediately in the parent.
  final SettingsController controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsController get _ctrl => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildSmartCalcTheme(themeMode: _ctrl.settings.themeMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SettingsPanel(
              settings: _ctrl.settings,
              onThemeChanged: (v) => setState(() => _ctrl.updateThemeMode(v)),
              onTextScaleChanged: (v) =>
                  setState(() => _ctrl.updateTextScale(v)),
              onPrecisionChanged: (v) =>
                  setState(() => _ctrl.updateDecimalPrecision(v)),
              onHapticsChanged: (v) =>
                  setState(() => _ctrl.updateHapticsEnabled(v)),
              onSoundChanged: (v) =>
                  setState(() => _ctrl.updateSoundEnabled(v)),
              onCustomOperatorColorChanged: (v) =>
                  setState(() => _ctrl.updateCustomOperatorColor(v)),
              onCustomButtonBackgroundTextChanged: (v) =>
                  setState(() => _ctrl.updateCustomButtonBackgroundText(v)),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../application/settings_controller.dart';
import '../presentation/settings_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.controller, super.key});

  final SettingsController controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsController get _ctrl => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildSmartCalcTheme(
        context,
        themeMode: _ctrl.settings.themeMode,
        customOperatorColor: _ctrl.settings.customOperatorColorValue != null
            ? Color(_ctrl.settings.customOperatorColorValue!)
            : null,
      ),
      child: Scaffold(
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

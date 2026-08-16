import 'package:flutter/material.dart';

import '../domain/app_settings.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    required this.settings,
    required this.onThemeChanged,
    required this.onTextScaleChanged,
    required this.onPrecisionChanged,
    required this.onHapticsChanged,
    required this.onSoundChanged,
    super.key,
  });

  final AppSettings settings;
  final ValueChanged<CalculatorThemeMode> onThemeChanged;
  final ValueChanged<TextScalePreference> onTextScaleChanged;
  final ValueChanged<int> onPrecisionChanged;
  final ValueChanged<bool> onHapticsChanged;
  final ValueChanged<bool> onSoundChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: muted, size: 18),
              const SizedBox(width: 8),
              Text(
                'Settings',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _themeMenu(),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _textScaleControl(),
              _precisionControl(),
              _switchControl(
                label: 'Haptics',
                value: settings.hapticsEnabled,
                onChanged: onHapticsChanged,
              ),
              _switchControl(
                label: 'Sound',
                value: settings.soundEnabled,
                onChanged: onSoundChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _themeMenu() {
    return DropdownButton<CalculatorThemeMode>(
      value: settings.themeMode,
      dropdownColor: const Color(0xFF1C1C1C),
      underline: const SizedBox.shrink(),
      style: const TextStyle(color: Colors.white),
      items: CalculatorThemeMode.values
          .map(
            (mode) => DropdownMenuItem(
              value: mode,
              child: Text(mode.label),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onThemeChanged(value);
        }
      },
    );
  }

  Widget _textScaleControl() {
    return SegmentedButton<TextScalePreference>(
      segments: TextScalePreference.values
          .map(
            (scale) => ButtonSegment(
              value: scale,
              label: Text(scale.label),
            ),
          )
          .toList(),
      selected: {settings.textScale},
      onSelectionChanged: (selection) => onTextScaleChanged(selection.first),
    );
  }

  Widget _precisionControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Precision',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: Slider(
            value: settings.decimalPrecision.toDouble(),
            min: 2,
            max: 10,
            divisions: 8,
            label: settings.decimalPrecision.toString(),
            onChanged: (value) => onPrecisionChanged(value.round()),
          ),
        ),
        Text(
          settings.decimalPrecision.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _switchControl({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

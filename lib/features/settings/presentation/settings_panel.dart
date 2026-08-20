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
    required this.onCustomOperatorColorChanged,
    required this.onCustomButtonBackgroundTextChanged,
    super.key,
  });

  final AppSettings settings;
  final ValueChanged<CalculatorThemeMode> onThemeChanged;
  final ValueChanged<TextScalePreference> onTextScaleChanged;
  final ValueChanged<int> onPrecisionChanged;
  final ValueChanged<bool> onHapticsChanged;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<int?> onCustomOperatorColorChanged;
  final ValueChanged<String?> onCustomButtonBackgroundTextChanged;

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
              _themeMenu(context),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _textScaleControl(),
              _precisionControl(context),
              _switchControl(
                context: context,
                label: 'Haptics',
                value: settings.hapticsEnabled,
                onChanged: onHapticsChanged,
              ),
              _switchControl(
                context: context,
                label: 'Sound',
                value: settings.soundEnabled,
                onChanged: onSoundChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _colorSelector(context),
          const SizedBox(height: 20),
          _backgroundTextInput(context),
        ],
      ),
    );
  }

  Widget _themeMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButton<CalculatorThemeMode>(
      value: settings.themeMode,
      dropdownColor: isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF2F2F7),
      underline: const SizedBox.shrink(),
      style: TextStyle(color: colorScheme.onSurface),
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

  Widget _precisionControl(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Precision',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
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
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _switchControl({
    required BuildContext context,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style:
                TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _colorSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = [
      null,
      Colors.blue.value,
      Colors.green.value,
      Colors.purple.value,
      Colors.pink.value,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operator Color',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: colors.map((cValue) {
              final color =
                  cValue == null ? const Color(0xFFFF9500) : Color(cValue);
              final isSelected = settings.customOperatorColorValue == cValue;
              return GestureDetector(
                onTap: () => onCustomOperatorColorChanged(cValue),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.onSurface
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _backgroundTextInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Button Watermark Text',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller:
              TextEditingController(text: settings.customButtonBackgroundText)
                ..selection = TextSelection.collapsed(
                    offset: settings.customButtonBackgroundText?.length ?? 0),
          onChanged: (v) =>
              onCustomButtonBackgroundTextChanged(v.isEmpty ? null : v),
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Enter text here',
            hintStyle:
                TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
            filled: true,
            fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}

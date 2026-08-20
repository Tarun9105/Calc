import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/services/sound_service.dart';
import 'features/history/domain/history_entry.dart';
import 'features/settings/domain/app_settings.dart';
import 'features/memory/domain/memory_value.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HistoryEntryAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
  Hive.registerAdapter(CalculatorThemeModeAdapter());
  Hive.registerAdapter(TextScalePreferenceAdapter());
  Hive.registerAdapter(MemoryValueAdapter());

  await Hive.openBox<HistoryEntry>('history');
  await Hive.openBox<AppSettings>('settings');
  await Hive.openBox<MemoryValue>('memory');

  final savedSettings = Hive.box<AppSettings>('settings').get('settings');
  await SoundService.instance.init();
  SoundService.instance.setEnabled(savedSettings?.soundEnabled ?? false);

  runApp(const SmartCalcApp());
}

import 'package:hive/hive.dart';
import '../../settings/domain/app_settings.dart';
import 'settings_repository.dart';

class HiveSettingsRepository implements SettingsRepository {
  HiveSettingsRepository() : _box = Hive.box<AppSettings>('settings');
  
  final Box<AppSettings> _box;

  @override
  AppSettings load() {
    return _box.get('settings') ?? const AppSettings();
  }

  @override
  AppSettings save(AppSettings settings) {
    _box.put('settings', settings);
    return settings;
  }
}

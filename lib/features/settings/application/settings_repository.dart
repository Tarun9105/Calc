import '../domain/app_settings.dart';

abstract class SettingsRepository {
  AppSettings load();
  AppSettings save(AppSettings settings);
}

class InMemorySettingsRepository implements SettingsRepository {
  AppSettings _settings = const AppSettings();

  @override
  AppSettings load() {
    return _settings;
  }

  @override
  AppSettings save(AppSettings settings) {
    _settings = settings;
    return _settings;
  }
}


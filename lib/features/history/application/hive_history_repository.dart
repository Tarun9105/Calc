import 'package:hive/hive.dart';
import '../../history/domain/history_entry.dart';
import 'history_repository.dart';

class HiveHistoryRepository implements HistoryRepository {
  HiveHistoryRepository() : _box = Hive.box<HistoryEntry>('history');

  final Box<HistoryEntry> _box;

  @override
  List<HistoryEntry> load() {
    return _box.values.toList().cast<HistoryEntry>();
  }

  @override
  List<HistoryEntry> saveEntry(HistoryEntry entry) {
    _box.add(entry);
    return load();
  }

  @override
  List<HistoryEntry> deleteAt(int index) {
    _box.deleteAt(index);
    return load();
  }

  @override
  List<HistoryEntry> clear() {
    _box.clear();
    return [];
  }
}

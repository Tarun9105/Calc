import '../domain/history_entry.dart';

abstract class HistoryRepository {
  List<HistoryEntry> load();
  List<HistoryEntry> saveEntry(HistoryEntry entry);
  List<HistoryEntry> deleteAt(int index);
  List<HistoryEntry> clear();
}

class InMemoryHistoryRepository implements HistoryRepository {
  final List<HistoryEntry> _entries = <HistoryEntry>[];

  @override
  List<HistoryEntry> clear() {
    _entries.clear();
    return List.unmodifiable(_entries);
  }

  @override
  List<HistoryEntry> deleteAt(int index) {
    if (index < 0 || index >= _entries.length) {
      return List.unmodifiable(_entries);
    }

    _entries.removeAt(index);
    return List.unmodifiable(_entries);
  }

  @override
  List<HistoryEntry> load() {
    return List.unmodifiable(_entries);
  }

  @override
  List<HistoryEntry> saveEntry(HistoryEntry entry) {
    _entries.insert(0, entry);
    return List.unmodifiable(_entries);
  }
}


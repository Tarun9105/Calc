import '../../history/domain/history_entry.dart';
import '../../memory/application/memory_repository.dart';
import '../../history/application/history_repository.dart';


class MemoryController {
  MemoryController({
    MemoryRepository? memoryRepository,
    HistoryRepository? historyRepository,
  })  : _memoryRepository =
            memoryRepository ?? InMemoryMemoryRepository(),
        _historyRepository =
            historyRepository ?? InMemoryHistoryRepository() {
    _memoryValue = _memoryRepository.load()?.value;
    _history = _historyRepository.load();
  }

  final MemoryRepository _memoryRepository;
  final HistoryRepository _historyRepository;

  double? _memoryValue;
  List<HistoryEntry> _history = const [];

  double? get memoryValue => _memoryValue;
  List<HistoryEntry> get history => _history;


  void memoryClear() {
    _memoryRepository.clear();
    _memoryValue = null;
  }

  double? memoryRecall() {
    final mv = _memoryRepository.load();
    if (mv == null) return null;
    _memoryValue = mv.value;
    return mv.value;
  }

  void memoryAdd(double currentValue) {
    final next = (_memoryRepository.load()?.value ?? 0) + currentValue;
    _memoryRepository.save(next);
    _memoryValue = next;
  }

  void memorySubtract(double currentValue) {
    final next = (_memoryRepository.load()?.value ?? 0) - currentValue;
    _memoryRepository.save(next);
    _memoryValue = next;
  }

  void memoryStore(double value) {
    final saved = _memoryRepository.save(value);
    _memoryValue = saved.value;
  }

  String? recallHistory(int index) {
    if (index < 0 || index >= _history.length) return null;
    return _history[index].expression;
  }

  void deleteHistory(int index) {
    _history = _historyRepository.deleteAt(index);
  }

  void clearHistory() {
    _history = _historyRepository.clear();
  }

  void refreshHistory() {
    _history = _historyRepository.load();
  }
}

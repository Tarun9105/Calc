import '../../history/domain/history_entry.dart';
import '../../memory/application/memory_repository.dart';
import '../../memory/domain/memory_value.dart';
import '../../history/application/history_repository.dart';

/// Controller that owns memory and history state for the Memory screen.
///
/// This controller is created by [CalculatorController] and shares the same
/// underlying repository instances so that changes made here are reflected in
/// calculator state when the user navigates back.
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

  // ── Memory operations ──────────────────────────────────────────────────────

  void memoryClear() {
    _memoryRepository.clear();
    _memoryValue = null;
  }

  void memoryRecall(void Function(double value) onRecalled) {
    final mv = _memoryRepository.load();
    if (mv == null) return;
    _memoryValue = mv.value;
    onRecalled(mv.value);
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

  // ── History operations ─────────────────────────────────────────────────────

  /// Returns the expression string of the recalled entry (caller decides what
  /// to do with it, e.g. paste into calculator).
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

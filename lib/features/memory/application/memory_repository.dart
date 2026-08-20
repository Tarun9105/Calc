import '../domain/memory_value.dart';

abstract class MemoryRepository {
  MemoryValue? load();
  MemoryValue save(double value);
  MemoryValue? clear();
}

class InMemoryMemoryRepository implements MemoryRepository {
  MemoryValue? _memoryValue;

  @override
  MemoryValue? clear() {
    _memoryValue = null;
    return _memoryValue;
  }

  @override
  MemoryValue? load() {
    return _memoryValue;
  }

  @override
  MemoryValue save(double value) {
    _memoryValue = MemoryValue(value);
    return _memoryValue!;
  }
}

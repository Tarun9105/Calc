import 'package:hive/hive.dart';
import '../../memory/domain/memory_value.dart';
import 'memory_repository.dart';

class HiveMemoryRepository implements MemoryRepository {
  HiveMemoryRepository() : _box = Hive.box<MemoryValue>('memory');
  
  final Box<MemoryValue> _box;

  @override
  MemoryValue? load() {
    return _box.get('memory');
  }

  @override
  MemoryValue save(double value) {
    final memoryValue = MemoryValue(value);
    _box.put('memory', memoryValue);
    return memoryValue;
  }

  @override
  MemoryValue? clear() {
    _box.delete('memory');
    return null;
  }
}

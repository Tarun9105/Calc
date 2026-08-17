import 'package:hive/hive.dart';

part 'memory_value.g.dart';

@HiveType(typeId: 4)
class MemoryValue {
  const MemoryValue(this.value);

  @HiveField(0)
  final double value;
}


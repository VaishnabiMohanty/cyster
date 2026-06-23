import 'package:floor/floor.dart';
import '../../features/cycle/cycle_entry.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class FlowLevelConverter extends TypeConverter<FlowLevel, String> {
  @override
  FlowLevel decode(String databaseValue) {
    return FlowLevel.values.firstWhere((e) => e.name == databaseValue);
  }

  @override
  String encode(FlowLevel value) {
    return value.name;
  }
}

class CycleColorConverter extends TypeConverter<CycleColor, String> {
  @override
  CycleColor decode(String databaseValue) {
    return CycleColor.values.firstWhere((e) => e.name == databaseValue);
  }

  @override
  String encode(CycleColor value) {
    return value.name;
  }
}

class ClotPresenceConverter extends TypeConverter<ClotPresence, String> {
  @override
  ClotPresence decode(String databaseValue) {
    return ClotPresence.values.firstWhere((e) => e.name == databaseValue);
  }

  @override
  String encode(ClotPresence value) {
    return value.name;
  }
}

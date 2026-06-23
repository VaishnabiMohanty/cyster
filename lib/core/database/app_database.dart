import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../features/cycle/cycle_entry.dart';
import '../../features/symptoms/symptom_log.dart';
import '../../features/journal/journal_entry.dart';
import 'type_converters.dart';

part 'app_database.g.dart'; // This will be generated

@TypeConverters([
  DateTimeConverter,
  FlowLevelConverter,
  CycleColorConverter,
  ClotPresenceConverter,
])
@Database(version: 1, entities: [CycleEntry, SymptomLog, JournalEntry])
abstract class AppDatabase extends FloorDatabase {
  CycleDao get cycleDao;
  SymptomDao get symptomDao;
  JournalDao get journalDao;
}

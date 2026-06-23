import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/database/database_provider.dart';
import 'symptom_log.dart';

part 'symptom_provider.g.dart';

@riverpod
class SymptomList extends _$SymptomList {
  @override
  Future<List<SymptomLog>> build() async {
    final db = ref.watch(databaseProvider);
    return db.symptomDao.findAllSymptoms();
  }

  Future<void> addLog(SymptomLog log) async {
    final db = ref.read(databaseProvider);
    await db.symptomDao.insertSymptom(log);
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<SymptomLog>> symptomHistory(SymptomHistoryRef ref, {required DateTime start, required DateTime end}) async {
  final db = ref.watch(databaseProvider);
  return db.symptomDao.findSymptomsInRange(start, end);
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/database/database_provider.dart';
import 'cycle_entry.dart';
import 'cycle_predictor.dart';

part 'cycle_provider.g.dart';

@riverpod
class CycleList extends _$CycleList {
  @override
  Future<List<CycleEntry>> build() async {
    final db = ref.watch(databaseProvider);
    return db.cycleDao.findAllCycles();
  }

  Future<void> addEntry(CycleEntry entry) async {
    final db = ref.read(databaseProvider);
    await db.cycleDao.insertCycle(entry);
    ref.invalidateSelf();
  }

  Future<void> deleteEntry(CycleEntry entry) async {
    final db = ref.read(databaseProvider);
    await db.cycleDao.deleteCycle(entry);
    ref.invalidateSelf();
  }
}

@riverpod
PredictionResult cyclePrediction(CyclePredictionRef ref) {
  final cyclesAsync = ref.watch(cycleListProvider);
  return cyclesAsync.maybeWhen(
    data: (cycles) => calculatePrediction(cycles),
    orElse: () => const NotEnoughData(3),
  );
}

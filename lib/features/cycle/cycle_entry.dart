import 'package:floor/floor.dart';

enum FlowLevel { light, medium, heavy }

enum CycleColor { brightRed, darkRed, brown, pink }

enum ClotPresence { none, small, large }

@entity
class CycleEntry {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final DateTime date;
  final int duration; // in days
  final FlowLevel flow;
  final CycleColor color;
  final ClotPresence clots;

  CycleEntry({
    this.id,
    required this.date,
    required this.duration,
    required this.flow,
    required this.color,
    required this.clots,
  });
}

@dao
abstract class CycleDao {
  @Query('SELECT * FROM CycleEntry ORDER BY date DESC')
  Future<List<CycleEntry>> findAllCycles();

  @Query('SELECT * FROM CycleEntry WHERE date BETWEEN :start AND :end ORDER BY date ASC')
  Future<List<CycleEntry>> findCyclesInRange(DateTime start, DateTime end);

  @insert
  Future<void> insertCycle(CycleEntry cycle);

  @delete
  Future<void> deleteCycle(CycleEntry cycle);
}

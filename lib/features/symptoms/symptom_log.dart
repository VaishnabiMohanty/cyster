import 'package:floor/floor.dart';

@entity
class SymptomLog {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final DateTime date;
  
  // 0-5 scale for intensity
  final int acne;      
  final int hairLoss;  
  final int bloating;  
  final int fatigue;   
  final int cravings;  
  
  final double? weight;
  final int sleepHours;

  SymptomLog({
    this.id,
    required this.date,
    this.acne = 0,
    this.hairLoss = 0,
    this.bloating = 0,
    this.fatigue = 0,
    this.cravings = 0,
    this.weight,
    this.sleepHours = 0,
  });
}

@dao
abstract class SymptomDao {
  @Query('SELECT * FROM SymptomLog ORDER BY date DESC')
  Future<List<SymptomLog>> findAllSymptoms();

  @Query('SELECT * FROM SymptomLog WHERE date BETWEEN :start AND :end ORDER BY date ASC')
  Future<List<SymptomLog>> findSymptomsInRange(DateTime start, DateTime end);

  @insert
  Future<void> insertSymptom(SymptomLog symptom);

  @delete
  Future<void> deleteSymptom(SymptomLog symptom);
}

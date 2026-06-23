import '../cycle/cycle_entry.dart';
import '../journal/journal_entry.dart';
import '../symptoms/symptom_log.dart';

class ReportDataSummary {
  final DateTime startDate;
  final DateTime endDate;
  final List<CycleEntry> cycles;
  final List<SymptomLog> symptoms;
  final List<JournalEntry> journalEntries;

  ReportDataSummary({
    required this.startDate,
    required this.endDate,
    required this.cycles,
    required this.symptoms,
    required this.journalEntries,
  });

  // Symptom frequency/severity aggregation
  Map<String, SymptomStats> get symptomStats {
    final stats = <String, SymptomStats>{};
    
    for (var log in symptoms) {
      _updateStats(stats, 'Acne', log.acne);
      _updateStats(stats, 'Hair Loss', log.hairLoss);
      _updateStats(stats, 'Bloating', log.bloating);
      _updateStats(stats, 'Fatigue', log.fatigue);
      _updateStats(stats, 'Cravings', log.cravings);
    }
    
    return stats;
  }

  void _updateStats(Map<String, SymptomStats> stats, String name, int intensity) {
    if (intensity > 0) {
      final s = stats.putIfAbsent(name, () => SymptomStats());
      s.count++;
      s.totalIntensity += intensity;
    }
  }

  // Mood frequency aggregation
  Map<MoodTag, int> get moodCounts {
    final counts = <MoodTag, int>{};
    for (var entry in journalEntries) {
      for (var mood in entry.moods) {
        counts[mood] = (counts[mood] ?? 0) + 1;
      }
    }
    return counts;
  }
}

class SymptomStats {
  int count = 0;
  int totalIntensity = 0;
  double get averageIntensity => count == 0 ? 0 : totalIntensity / count;
}

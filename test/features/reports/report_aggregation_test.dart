import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/reports/report_models.dart';
import 'package:cyster/features/cycle/cycle_entry.dart';
import 'package:cyster/features/symptoms/symptom_log.dart';
import 'package:cyster/features/journal/journal_entry.dart';

void main() {
  group('ReportDataSummary Aggregation', () {
    final start = DateTime(2023, 1, 1);
    final end = DateTime(2023, 3, 1);

    test('correctly aggregates symptom stats', () {
      final symptoms = [
        SymptomLog(date: DateTime(2023, 1, 5), acne: 3, bloating: 2),
        SymptomLog(date: DateTime(2023, 1, 10), acne: 5, bloating: 0),
        SymptomLog(date: DateTime(2023, 2, 1), fatigue: 4),
      ];

      final summary = ReportDataSummary(
        startDate: start,
        endDate: end,
        cycles: [],
        symptoms: symptoms,
        journalEntries: [],
      );

      final stats = summary.symptomStats;

      expect(stats['Acne']?.count, 2);
      expect(stats['Acne']?.totalIntensity, 8);
      expect(stats['Acne']?.averageIntensity, 4.0);
      
      expect(stats['Bloating']?.count, 1);
      expect(stats['Fatigue']?.count, 1);
      expect(stats['Hair Loss'], isNull); // Never logged
    });

    test('correctly aggregates mood counts', () {
      final entries = [
        JournalEntry(date: DateTime(2023, 1, 1), content: '...', moodTags: 'good,okay', prompt: '...'),
        JournalEntry(date: DateTime(2023, 1, 2), content: '...', moodTags: 'good', prompt: '...'),
        JournalEntry(date: DateTime(2023, 1, 3), content: '...', moodTags: 'anxious', prompt: '...'),
      ];

      final summary = ReportDataSummary(
        startDate: start,
        endDate: end,
        cycles: [],
        symptoms: [],
        journalEntries: entries,
      );

      final counts = summary.moodCounts;

      expect(counts[MoodTag.good], 2);
      expect(counts[MoodTag.okay], 1);
      expect(counts[MoodTag.anxious], 1);
      expect(counts[MoodTag.foggy], isNull);
    });

    test('handles empty data gracefully', () {
      final summary = ReportDataSummary(
        startDate: start,
        endDate: end,
        cycles: [],
        symptoms: [],
        journalEntries: [],
      );

      expect(summary.symptomStats, isEmpty);
      expect(summary.moodCounts, isEmpty);
    });
  });
}

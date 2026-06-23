import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/cycle/cycle_entry.dart';
import 'package:cyster/features/cycle/cycle_predictor.dart';

void main() {
  group('calculatePrediction', () {
    test('returns NotEnoughData when history has < 3 entries', () {
      final history = [
        CycleEntry(
          date: DateTime(2023, 1, 1),
          duration: 5,
          flow: FlowLevel.medium,
          color: CycleColor.brightRed,
          clots: ClotPresence.none,
        ),
      ];

      final result = calculatePrediction(history);

      expect(result, isA<NotEnoughData>());
      expect((result as NotEnoughData).cyclesNeeded, 2);
    });

    test('returns tight range for regular cycles (std dev < threshold)', () {
      // 28 days interval exactly
      final history = [
        CycleEntry(date: DateTime(2023, 1, 1), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
        CycleEntry(date: DateTime(2023, 1, 29), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
        CycleEntry(date: DateTime(2023, 2, 26), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
        CycleEntry(date: DateTime(2023, 3, 26), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
      ];

      final result = calculatePrediction(history);

      expect(result, isA<PredictableCycle>());
      final predictable = result as PredictableCycle;
      expect(predictable.isIrregular, isFalse);
      expect(predictable.averageCycleLength, 28);
      expect(predictable.message, contains('Around Day 28, ±2 days.'));
    });

    test('returns wide range for irregular cycles (std dev >= threshold)', () {
      // Intervals: 28, 40, 32. Mean: 33.3. StdDev: ~4.98
      final history = [
        CycleEntry(date: DateTime(2023, 1, 1), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
        CycleEntry(date: DateTime(2023, 1, 29), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
        CycleEntry(date: DateTime(2023, 3, 10), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
        CycleEntry(date: DateTime(2023, 4, 11), duration: 5, flow: FlowLevel.medium, color: CycleColor.brightRed, clots: ClotPresence.none),
      ];

      final result = calculatePrediction(history);

      expect(result, isA<PredictableCycle>());
      final predictable = result as PredictableCycle;
      expect(predictable.isIrregular, isTrue);
      expect(predictable.message, contains('based on your recent cycles.'));
      expect(predictable.message, contains('Day'));
    });
  });
}

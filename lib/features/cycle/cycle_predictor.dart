import 'dart:math';
import 'cycle_entry.dart';

/// The threshold in days for standard deviation to consider a cycle "irregular".
const double IRREGULARITY_THRESHOLD = 4.0;

/// The minimum number of completed cycles required to generate a prediction.
const int MIN_CYCLES_FOR_PREDICTION = 3;

sealed class PredictionResult {
  const PredictionResult();
}

class NotEnoughData extends PredictionResult {
  final int cyclesNeeded;
  const NotEnoughData(this.cyclesNeeded);
}

class PredictableCycle extends PredictionResult {
  final int averageCycleLength;
  final int stdDev;
  final bool isIrregular;
  final DateTime nextEstimatedDate;

  const PredictableCycle({
    required this.averageCycleLength,
    required this.stdDev,
    required this.isIrregular,
    required this.nextEstimatedDate,
  });

  String get message {
    if (isIrregular) {
      final minDays = averageCycleLength - stdDev.clamp(2, 10);
      final maxDays = averageCycleLength + stdDev.clamp(2, 10);
      return "Day $minDays–$maxDays based on your recent cycles.";
    } else {
      return "Around Day $averageCycleLength, ±2 days.";
    }
  }
}

/// Pure function to calculate cycle prediction based on history.
/// 
/// Tiering Logic:
/// 1. < 3 cycles -> NotEnoughData
/// 2. >= 3 cycles, stdDev < IRREGULARITY_THRESHOLD -> Tight estimate
/// 3. >= 3 cycles, stdDev >= IRREGULARITY_THRESHOLD -> Wide honest range
PredictionResult calculatePrediction(List<CycleEntry> history) {
  if (history.length < MIN_CYCLES_FOR_PREDICTION) {
    return NotEnoughData(MIN_CYCLES_FOR_PREDICTION - history.length);
  }

  // Sort by date ascending to calculate intervals
  final sortedHistory = List<CycleEntry>.from(history)..sort((a, b) => a.date.compareTo(b.date));
  
  final List<int> cycleLengths = [];
  for (int i = 0; i < sortedHistory.length - 1; i++) {
    final length = sortedHistory[i + 1].date.difference(sortedHistory[i].date).inDays;
    cycleLengths.add(length);
  }

  if (cycleLengths.isEmpty) {
    return NotEnoughData(MIN_CYCLES_FOR_PREDICTION);
  }

  final double avg = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
  final double variance = cycleLengths.map((l) => pow(l - avg, 2)).reduce((a, b) => a + b) / cycleLengths.length;
  final double stdDev = sqrt(variance);

  final lastCycleDate = sortedHistory.last.date;
  final nextDate = lastCycleDate.add(Duration(days: avg.round()));

  return PredictableCycle(
    averageCycleLength: avg.round(),
    stdDev: stdDev.round(),
    isIrregular: stdDev >= IRREGULARITY_THRESHOLD,
    nextEstimatedDate: nextDate,
  );
}

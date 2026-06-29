import 'package:flutter/material.dart' show DateTimeRange;
import '../../features/cycle/cycle_entry.dart';
import '../../features/cycle/cycle_predictor.dart';

/// The four broad phases of a menstrual cycle, used for fertility estimates,
/// notification scheduling, and phase-aware tips throughout the app.
enum CyclePhase { menstrual, follicular, ovulation, luteal }

extension CyclePhaseInfo on CyclePhase {
  String get label {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Menstrual Phase';
      case CyclePhase.follicular:
        return 'Follicular Phase';
      case CyclePhase.ovulation:
        return 'Ovulation Phase';
      case CyclePhase.luteal:
        return 'Luteal Phase';
    }
  }

  String get shortDescription {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Your period — the uterine lining sheds.';
      case CyclePhase.follicular:
        return 'Follicles mature and estrogen rises.';
      case CyclePhase.ovulation:
        return 'An egg may be released — your most fertile window.';
      case CyclePhase.luteal:
        return 'Post-ovulation — progesterone rises, PMS may appear.';
    }
  }
}

/// A single estimated phase window with start/end dates.
class PhaseWindow {
  final CyclePhase phase;
  final DateTime start;
  final DateTime end;

  const PhaseWindow({required this.phase, required this.start, required this.end});

  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }
}

/// Estimates phase windows for the *current* cycle based on cycle history.
///
/// Important PCOS caveat: ovulation timing is frequently irregular or absent
/// in PCOS, so these are estimates for planning/awareness, not a diagnostic
/// or contraceptive tool. This is reflected in the UI copy wherever this
/// class's outputs are shown.
class CyclePhaseEstimator {
  /// Average luteal phase length is far more consistent (commonly 12-14
  /// days) than the follicular phase, even in irregular cycles — so we
  /// anchor ovulation estimates by counting backward from the *next*
  /// period rather than forward from the last one.
  static const int defaultLutealLength = 14;
  static const int defaultPeriodLength = 5;
  static const int fertileWindowDaysBeforeOvulation = 5;

  /// Returns estimated phase windows for the user's current cycle, or null
  /// if there isn't enough history to estimate anything.
  static List<PhaseWindow>? estimateCurrentCyclePhases(List<CycleEntry> history) {
    if (history.isEmpty) return null;

    final sorted = List<CycleEntry>.from(history)..sort((a, b) => a.date.compareTo(b.date));
    final lastPeriod = sorted.last;
    final periodLength = lastPeriod.duration > 0 ? lastPeriod.duration : defaultPeriodLength;

    final prediction = calculatePrediction(history);
    int cycleLength;
    switch (prediction) {
      case PredictableCycle(averageCycleLength: var avg):
        cycleLength = avg;
      case NotEnoughData():
        // Fall back to a clinically-typical 28 day cycle so we can still
        // show *something* useful, clearly framed as a rough estimate.
        cycleLength = 28;
    }

    final periodStart = DateTime(lastPeriod.date.year, lastPeriod.date.month, lastPeriod.date.day);
    final periodEnd = periodStart.add(Duration(days: periodLength - 1));

    final nextPeriodStart = periodStart.add(Duration(days: cycleLength));
    final ovulationDay = nextPeriodStart.subtract(const Duration(days: defaultLutealLength));

    final follicularStart = periodEnd.add(const Duration(days: 1));
    final follicularEnd = ovulationDay.subtract(const Duration(days: 1));

    final ovulationStart = ovulationDay.subtract(const Duration(days: 1));
    final ovulationEnd = ovulationDay.add(const Duration(days: 1));

    // Luteal phase: ovulation end -> next period start (exclusive)
    final lutealStart = ovulationEnd.add(const Duration(days: 1));
    final lutealEnd = nextPeriodStart.subtract(const Duration(days: 1));

    final windows = <PhaseWindow>[
      PhaseWindow(phase: CyclePhase.menstrual, start: periodStart, end: periodEnd),
      if (!follicularEnd.isBefore(follicularStart))
        PhaseWindow(phase: CyclePhase.follicular, start: follicularStart, end: follicularEnd),
      PhaseWindow(phase: CyclePhase.ovulation, start: ovulationStart, end: ovulationEnd),
      if (!lutealEnd.isBefore(lutealStart))
        PhaseWindow(phase: CyclePhase.luteal, start: lutealStart, end: lutealEnd),
    ];

    return windows;
  }

  /// The fertile window is the ovulation day plus the ~5 days before it,
  /// when sperm can survive long enough to fertilize a released egg.
  static DateTimeRange? estimateFertileWindow(List<CycleEntry> history) {
    final windows = estimateCurrentCyclePhases(history);
    if (windows == null) return null;

    PhaseWindow? ovulation;
    for (final w in windows) {
      if (w.phase == CyclePhase.ovulation) {
        ovulation = w;
        break;
      }
    }
    if (ovulation == null) return null;

    final fertileStart = ovulation.start.subtract(
      Duration(days: fertileWindowDaysBeforeOvulation - 1),
    );
    return DateTimeRange(start: fertileStart, end: ovulation.end);
  }

  static CyclePhase? phaseForDate(List<CycleEntry> history, DateTime date) {
    final windows = estimateCurrentCyclePhases(history);
    if (windows == null) return null;
    for (final w in windows) {
      if (w.contains(date)) return w.phase;
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cycle_phase/cycle_phase_estimator.dart';
import '../../features/cycle/cycle_provider.dart';

/// Shows an in-app card when today falls within a newly-estimated phase
/// window — a visible, always-available complement to the system push
/// notification (some users keep system notifications muted, or want a
/// quick glance without leaving the app).
class PhaseBanner extends ConsumerWidget {
  const PhaseBanner({super.key});

  Color _colorFor(CyclePhase phase, ColorScheme scheme) {
    switch (phase) {
      case CyclePhase.menstrual:
        return scheme.primary;
      case CyclePhase.follicular:
        return const Color(0xFFFFB562);
      case CyclePhase.ovulation:
        return const Color(0xFF6FCF97);
      case CyclePhase.luteal:
        return const Color(0xFF9B8AE6);
    }
  }

  IconData _iconFor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Icons.water_drop;
      case CyclePhase.follicular:
        return Icons.eco;
      case CyclePhase.ovulation:
        return Icons.favorite;
      case CyclePhase.luteal:
        return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleListAsync = ref.watch(cycleListProvider);
    final theme = Theme.of(context);

    return cycleListAsync.maybeWhen(
      data: (cycles) {
        if (cycles.length < 3) return const SizedBox.shrink();

        final windows = CyclePhaseEstimator.estimateCurrentCyclePhases(cycles);
        if (windows == null) return const SizedBox.shrink();

        final today = DateTime.now();
        // Only show the banner on the first day of a phase window so it
        // reads as a "just started" alert rather than a permanent fixture.
        final justStarted = windows.where((w) {
          final start = DateTime(w.start.year, w.start.month, w.start.day);
          final t = DateTime(today.year, today.month, today.day);
          return start == t;
        }).toList();

        if (justStarted.isEmpty) return const SizedBox.shrink();
        final phase = justStarted.first.phase;
        final color = _colorFor(phase, theme.colorScheme);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(_iconFor(phase), color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${phase.label} is estimated to start today',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(phase.shortDescription, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

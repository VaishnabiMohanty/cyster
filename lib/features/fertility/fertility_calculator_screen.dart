import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/cycle_phase/cycle_phase_estimator.dart';
import '../cycle/cycle_provider.dart';
import '../cycle/cycle_predictor.dart';

/// Returns the first element matching [test], or null if [list] is null,
/// empty, or has no match. A small null-safe stand-in for collection
/// package's firstWhereOrNull, kept local to avoid adding a new dependency.
T? _firstWhereOrNull<T>(List<T>? list, bool Function(T) test) {
  if (list == null) return null;
  for (final item in list) {
    if (test(item)) return item;
  }
  return null;
}

class FertilityCalculatorScreen extends ConsumerWidget {
  const FertilityCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleListAsync = ref.watch(cycleListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Fertility Calculator')),
      body: cycleListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (cycles) {
          if (cycles.length < 3) {
            return _NotEnoughHistory(cyclesLogged: cycles.length);
          }

          final windows = CyclePhaseEstimator.estimateCurrentCyclePhases(cycles);
          final fertileWindow = CyclePhaseEstimator.estimateFertileWindow(cycles);
          final prediction = calculatePrediction(cycles);
          final isIrregular = switch (prediction) {
            PredictableCycle(isIrregular: var irregular) => irregular,
            NotEnoughData() => false,
          };

          final ovulationWindow = _firstWhereOrNull(
            windows,
            (w) => w.phase == CyclePhase.ovulation,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isIrregular) _IrregularityNotice(theme: theme),
                if (fertileWindow != null)
                  _FertileWindowCard(
                    fertileWindow: fertileWindow,
                    ovulationDay: ovulationWindow?.start.add(const Duration(days: 1)),
                  ),
                if (windows != null) _PhaseTimelineCard(windows: windows),
                const _ConceptionOddsCard(),
                const _PcosFertilityNote(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotEnoughHistory extends StatelessWidget {
  final int cyclesLogged;
  const _NotEnoughHistory({required this.cyclesLogged});

  @override
  Widget build(BuildContext context) {
    final needed = 3 - cyclesLogged;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Log $needed more cycle${needed == 1 ? '' : 's'} to unlock fertility estimates.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'We use your recent cycle history to estimate your ovulation and fertile window. Head to the Cycles tab to log a period.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _IrregularityNotice extends StatelessWidget {
  final ThemeData theme;
  const _IrregularityNotice({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.tertiaryContainer.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your cycles have shown irregularity, common with PCOS. Treat this estimate as a wide, rough guide rather than a precise prediction.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FertileWindowCard extends StatelessWidget {
  final DateTimeRange fertileWindow;
  final DateTime? ovulationDay;

  const _FertileWindowCard({required this.fertileWindow, this.ovulationDay});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('MMM d');
    final today = DateTime.now();
    final inWindow = !today.isBefore(fertileWindow.start) && !today.isAfter(fertileWindow.end);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Estimated Fertile Window', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${fmt.format(fertileWindow.start)} – ${fmt.format(fertileWindow.end)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (ovulationDay != null) ...[
              const SizedBox(height: 4),
              Text(
                'Estimated ovulation around ${fmt.format(ovulationDay!)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (inWindow) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_active, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      "You're in your estimated fertile window today",
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PhaseTimelineCard extends StatelessWidget {
  final List<PhaseWindow> windows;
  const _PhaseTimelineCard({required this.windows});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('MMM d');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This Cycle, Phase by Phase', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            ...windows.map((w) {
              final color = _colorFor(w.phase, theme.colorScheme);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.phase.label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            '${fmt.format(w.start)} – ${fmt.format(w.end)}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(w.phase.shortDescription, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ConceptionOddsCard extends StatelessWidget {
  const _ConceptionOddsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('How Conception Timing Works', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            const _OddsRow(label: 'Days before ovulation (sperm waiting)', value: 'Good odds, rising'),
            const _OddsRow(label: 'Day of ovulation', value: 'Highest odds'),
            const _OddsRow(label: '1 day after ovulation', value: 'Odds drop sharply'),
            const _OddsRow(label: '2+ days after ovulation', value: 'Very low odds'),
            const SizedBox(height: 12),
            Text(
              'The egg only survives about 12–24 hours after release, while sperm can survive up to 5 days — which is why the fertile window starts before ovulation, not after.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _OddsRow extends StatelessWidget {
  final String label;
  final String value;
  const _OddsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PcosFertilityNote extends StatelessWidget {
  const _PcosFertilityNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A note for PCOS cysters', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'PCOS can make ovulation irregular, delayed, or occasionally absent in a given cycle, so this estimate is a starting point, not a guarantee. '
              'Tracking basal body temperature, ovulation predictor kits (LH strips), or cervical mucus changes alongside this calculator can sharpen accuracy. '
              'If you have been trying to conceive for 6–12 months without success, it is worth speaking with a gynecologist or fertility specialist.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

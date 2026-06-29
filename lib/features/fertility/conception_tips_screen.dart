import 'package:flutter/material.dart';
import 'conception_tips_data.dart';

IconData _iconFor(String key) {
  switch (key) {
    case 'calendar':
      return Icons.calendar_month;
    case 'water_drop':
      return Icons.water_drop_outlined;
    case 'thermostat':
      return Icons.thermostat;
    case 'favorite':
      return Icons.favorite_outline;
    case 'monitor_weight':
      return Icons.monitor_weight_outlined;
    case 'restaurant':
      return Icons.restaurant_outlined;
    case 'directions_walk':
      return Icons.directions_walk;
    case 'bedtime':
      return Icons.bedtime_outlined;
    case 'no_drinks':
      return Icons.no_drinks_outlined;
    case 'medication':
      return Icons.medication_outlined;
    case 'science':
      return Icons.science_outlined;
    case 'medical_services':
      return Icons.medical_services_outlined;
    case 'support_agent':
      return Icons.support_agent;
    case 'self_improvement':
      return Icons.self_improvement;
    case 'diversity_3':
      return Icons.diversity_3;
    default:
      return Icons.lightbulb_outline;
  }
}

class ConceptionTipsScreen extends StatelessWidget {
  const ConceptionTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Conception Tips')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'General educational tips for people with PCOS trying to conceive. Always tailor your approach with a doctor familiar with your history.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          for (final category in conceptionTipCategories) _CategorySection(category: category),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final ConceptionTipCategory category;
  const _CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            category.title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...category.tips.map((tip) => _TipTile(tip: tip)),
      ],
    );
  }
}

class _TipTile extends StatelessWidget {
  final ConceptionTip tip;
  const _TipTile({required this.tip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconFor(tip.icon), color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(tip.body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

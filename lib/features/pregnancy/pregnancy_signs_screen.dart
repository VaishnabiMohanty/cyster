import 'package:flutter/material.dart';
import 'pregnancy_signs_data.dart';

IconData _iconFor(String key) {
  switch (key) {
    case 'event_busy':
      return Icons.event_busy;
    case 'sick':
      return Icons.sick_outlined;
    case 'favorite_border':
      return Icons.favorite_border;
    case 'bedtime':
      return Icons.bedtime_outlined;
    case 'wc':
      return Icons.wc;
    case 'restaurant':
      return Icons.restaurant_outlined;
    case 'water_drop_outlined':
      return Icons.water_drop_outlined;
    case 'mood':
      return Icons.mood_outlined;
    case 'circle_outlined':
      return Icons.circle_outlined;
    case 'air':
      return Icons.air;
    case 'thermostat':
      return Icons.thermostat;
    default:
      return Icons.info_outline;
  }
}

class PregnancySignsScreen extends StatefulWidget {
  const PregnancySignsScreen({super.key});

  @override
  State<PregnancySignsScreen> createState() => _PregnancySignsScreenState();
}

class _PregnancySignsScreenState extends State<PregnancySignsScreen> {
  final Set<String> _checked = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = _checked.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Early Pregnancy Signs')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              color: theme.colorScheme.primary.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Important note for PCOS cysters', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(pcosPregnancySignsCaveat, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text('Tap any signs you are noticing', style: theme.textTheme.bodyMedium),
                const Spacer(),
                if (count > 0)
                  Chip(
                    label: Text('$count noted'),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  ),
              ],
            ),
          ),
          ...earlyPregnancySigns.map((sign) => _SignTile(
                sign: sign,
                checked: _checked.contains(sign.title),
                onToggle: () => setState(() {
                  if (_checked.contains(sign.title)) {
                    _checked.remove(sign.title);
                  } else {
                    _checked.add(sign.title);
                  }
                }),
              )),
          if (count >= 2)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You've noted a few signs. If your period is late or absent, a home pregnancy test is the most reliable next step — symptoms alone can't confirm or rule it out.",
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SignTile extends StatelessWidget {
  final PregnancySign sign;
  final bool checked;
  final VoidCallback onToggle;

  const _SignTile({required this.sign, required this.checked, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: checked ? theme.colorScheme.primary.withOpacity(0.08) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: checked
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconFor(sign.icon),
                  color: checked ? Colors.white : theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sign.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(sign.description, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                checked ? Icons.check_circle : Icons.radio_button_unchecked,
                color: checked ? theme.colorScheme.primary : theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

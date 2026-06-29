import 'package:flutter/material.dart';
import '../fertility/fertility_calculator_screen.dart';
import '../fertility/conception_tips_screen.dart';
import '../pregnancy/pregnancy_signs_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../settings/settings_screen.dart';

class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(title: 'Fertility & Conception', theme: theme),
          _HubTile(
            icon: Icons.favorite,
            title: 'Fertility Calculator',
            subtitle: 'Estimate your fertile window and ovulation',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FertilityCalculatorScreen())),
          ),
          _HubTile(
            icon: Icons.tips_and_updates_outlined,
            title: 'Conception Tips',
            subtitle: 'Evidence-informed tips for trying to conceive with PCOS',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConceptionTipsScreen())),
          ),
          _HubTile(
            icon: Icons.child_friendly_outlined,
            title: 'Early Pregnancy Signs',
            subtitle: 'A general-education checklist of common early signs',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PregnancySignsScreen())),
          ),
          const Divider(height: 24),
          _SectionHeader(title: 'Nutrition', theme: theme),
          _HubTile(
            icon: Icons.restaurant_menu,
            title: 'PCOS-Friendly Food & Recipes',
            subtitle: 'Guidance, recipes by cuisine, and a pantry matcher',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionScreen())),
          ),
          const Divider(height: 24),
          _SectionHeader(title: 'App', theme: theme),
          _HubTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Theme and notification preferences',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HubTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

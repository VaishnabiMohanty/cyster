import 'package:flutter/material.dart';
import 'recipe_models.dart';

class RecipeDetailScreen extends StatelessWidget {
  final PcosRecipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(recipe.cuisine.flagEmoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 6),
                    Text(recipe.cuisine.label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Icon(Icons.schedule, size: 16, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('${recipe.totalMinutes} min', style: theme.textTheme.bodyMedium),
                    const SizedBox(width: 12),
                    Icon(Icons.people_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('${recipe.servings} servings', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 10),
                Text(recipe.description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: recipe.tags
                      .map((t) => Chip(
                            label: Text(t.label, style: const TextStyle(fontSize: 11)),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Card(
            color: theme.colorScheme.secondaryContainer.withOpacity(0.35),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.favorite_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(recipe.whyItHelps, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Ingredients', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      Text('Serves ${recipe.servings}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...recipe.ingredients.map((ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 7, right: 10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium,
                                  children: [
                                    TextSpan(text: '${ing.amount}  ', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    TextSpan(text: ing.name),
                                    if (ing.note != null) TextSpan(text: ' (${ing.note})', style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Method', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...recipe.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(step, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

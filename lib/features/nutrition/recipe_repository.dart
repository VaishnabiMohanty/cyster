import 'recipe_models.dart';
import 'recipes_indian.dart';
import 'recipes_mediterranean.dart';
import 'recipes_east_asian.dart';
import 'recipes_western.dart';

/// Combined, queryable list of all PCOS-friendly recipes across cuisines.
class RecipeRepository {
  RecipeRepository._();

  static final List<PcosRecipe> all = [
    ...indianRecipes,
    ...mediterraneanRecipes,
    ...eastAsianRecipes,
    ...westernRecipes,
  ];

  static List<PcosRecipe> byCuisine(Cuisine cuisine) =>
      all.where((r) => r.cuisine == cuisine).toList();

  static List<PcosRecipe> byMealType(MealType mealType) =>
      all.where((r) => r.mealType == mealType).toList();

  /// "What can I make?" — returns recipes where at least [minMatchCount]
  /// ingredients (by simple substring match) are present in the user's
  /// available ingredient list. Recipes are ranked by how many of their
  /// ingredients are matched, most-matched first.
  static List<PcosRecipe> matchByAvailableIngredients(
    List<String> availableIngredients, {
    int minMatchCount = 1,
  }) {
    final normalizedAvailable = availableIngredients.map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();
    if (normalizedAvailable.isEmpty) return [];

    final scored = <(PcosRecipe, int)>[];
    for (final recipe in all) {
      int matches = 0;
      for (final ingredientName in recipe.ingredientKeywords) {
        final isMatch = normalizedAvailable.any(
          (have) => ingredientName.contains(have) || have.contains(ingredientName),
        );
        if (isMatch) matches++;
      }
      if (matches >= minMatchCount) {
        scored.add((recipe, matches));
      }
    }

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }

  static List<PcosRecipe> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((r) =>
        r.title.toLowerCase().contains(q) ||
        r.description.toLowerCase().contains(q) ||
        r.ingredientKeywords.any((i) => i.contains(q))).toList();
  }
}

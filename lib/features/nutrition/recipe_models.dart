/// Cuisine categories for the PCOS-friendly recipe library.
enum Cuisine { indian, mediterranean, eastAsian, western }

extension CuisineInfo on Cuisine {
  String get label {
    switch (this) {
      case Cuisine.indian:
        return 'Indian';
      case Cuisine.mediterranean:
        return 'Mediterranean';
      case Cuisine.eastAsian:
        return 'East Asian';
      case Cuisine.western:
        return 'Western';
    }
  }

  String get flagEmoji {
    switch (this) {
      case Cuisine.indian:
        return '🇮🇳';
      case Cuisine.mediterranean:
        return '🫒';
      case Cuisine.eastAsian:
        return '🥢';
      case Cuisine.western:
        return '🌽';
    }
  }
}

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeInfo on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }
}

/// Why a given recipe is considered PCOS-friendly — shown as small tags.
enum PcosTag { lowGi, highFiber, antiInflammatory, highProtein, hormoneSupportive, lowDairy }

extension PcosTagInfo on PcosTag {
  String get label {
    switch (this) {
      case PcosTag.lowGi:
        return 'Low GI';
      case PcosTag.highFiber:
        return 'High Fiber';
      case PcosTag.antiInflammatory:
        return 'Anti-inflammatory';
      case PcosTag.highProtein:
        return 'High Protein';
      case PcosTag.hormoneSupportive:
        return 'Hormone Support';
      case PcosTag.lowDairy:
        return 'Low Dairy';
    }
  }
}

class RecipeIngredient {
  final String name;
  final String amount; // kept as a display string ("1 cup", "200 g", "2 medium") for flexibility across unit systems
  final String? note;

  const RecipeIngredient({required this.name, required this.amount, this.note});
}

class PcosRecipe {
  final String id;
  final String title;
  final Cuisine cuisine;
  final MealType mealType;
  final List<PcosTag> tags;
  final String description;
  final int prepMinutes;
  final int cookMinutes;
  final int servings;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String whyItHelps;

  const PcosRecipe({
    required this.id,
    required this.title,
    required this.cuisine,
    required this.mealType,
    required this.tags,
    required this.description,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.servings,
    required this.ingredients,
    required this.steps,
    required this.whyItHelps,
  });

  int get totalMinutes => prepMinutes + cookMinutes;

  /// Lowercased ingredient name list, used for the "what can I make"
  /// pantry-matching feature.
  List<String> get ingredientKeywords => ingredients.map((i) => i.name.toLowerCase()).toList();
}

class FoodGuidanceGroup {
  final String title;
  final String icon;
  final List<String> items;
  const FoodGuidanceGroup({required this.title, required this.icon, required this.items});
}

/// High-level "favor" and "limit" food groups for PCOS, framed as general
/// dietary patterns rather than strict rules — individual needs vary and a
/// dietitian/doctor should personalize this.
final List<FoodGuidanceGroup> pcosFoodsToFavor = [
  FoodGuidanceGroup(
    title: 'High-fiber carbohydrates',
    icon: 'grass',
    items: ['Whole grains (oats, brown rice, quinoa, millets)', 'Legumes (lentils, chickpeas, beans)', 'Whole fruits with skin (apples, berries, pears)', 'Starchy vegetables in moderation (sweet potato)'],
  ),
  FoodGuidanceGroup(
    title: 'Lean & plant proteins',
    icon: 'egg',
    items: ['Eggs', 'Fish, especially fatty fish (salmon, sardines, mackerel)', 'Skinless poultry', 'Tofu, tempeh, paneer', 'Lentils and beans'],
  ),
  FoodGuidanceGroup(
    title: 'Healthy fats',
    icon: 'water_drop',
    items: ['Extra virgin olive oil', 'Nuts and seeds (walnuts, flaxseed, chia, almonds)', 'Avocado', 'Fatty fish'],
  ),
  FoodGuidanceGroup(
    title: 'Non-starchy vegetables',
    icon: 'eco',
    items: ['Leafy greens (spinach, kale)', 'Broccoli and cauliflower', 'Bell peppers', 'Cucumber, zucchini'],
  ),
  FoodGuidanceGroup(
    title: 'Anti-inflammatory extras',
    icon: 'spa',
    items: ['Turmeric', 'Ginger', 'Cinnamon', 'Green tea', 'Berries (antioxidants)'],
  ),
];

final List<FoodGuidanceGroup> pcosFoodsToLimit = [
  FoodGuidanceGroup(
    title: 'Refined carbohydrates & added sugar',
    icon: 'cookie',
    items: ['White bread, white rice, refined pasta', 'Sugary cereals and pastries', 'Sweetened beverages and packaged fruit juice', 'Candy and desserts in excess'],
  ),
  FoodGuidanceGroup(
    title: 'Processed & fried foods',
    icon: 'fastfood',
    items: ['Deep-fried snacks', 'Processed meats (sausages, deli meats)', 'Packaged instant foods high in trans fats'],
  ),
  FoodGuidanceGroup(
    title: 'Excess dairy (for some people)',
    icon: 'icecream',
    items: ['Some people with PCOS report fewer symptoms (especially acne) reducing high-dairy intake — this varies person to person and isn\'t universal'],
  ),
];

const String pcosNutritionPhilosophy =
    'There is no single "PCOS diet" that works for everyone — but a pattern that emphasizes fiber, lean and plant '
    'protein, healthy fats, and minimally processed carbohydrates is consistently linked with better insulin '
    'sensitivity, which is relevant for most PCOS phenotypes. Building meals around the plate method — half '
    'vegetables, a quarter protein, a quarter whole-grain carbs, plus a thumb of healthy fat — is an easy way to '
    'apply this without obsessive calorie tracking.';

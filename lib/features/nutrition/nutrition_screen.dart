import 'package:flutter/material.dart';
import 'food_guidance_data.dart';
import 'recipe_models.dart';
import 'recipe_repository.dart';
import 'recipe_detail_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCOS Nutrition'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Guidance'),
            Tab(text: 'Recipes'),
            Tab(text: 'What Can I Make?'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _GuidanceTab(),
          _RecipeBrowserTab(),
          _PantryMatchTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Guidance tab
// ---------------------------------------------------------------------------

class _GuidanceTab extends StatelessWidget {
  const _GuidanceTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Card(
            color: theme.colorScheme.primary.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(pcosNutritionPhilosophy, style: theme.textTheme.bodyMedium),
            ),
          ),
        ),
        _GuidanceSection(
          title: 'Foods to favor',
          color: theme.colorScheme.primary,
          groups: pcosFoodsToFavor,
        ),
        _GuidanceSection(
          title: 'Foods to limit',
          color: const Color(0xFFD64550),
          groups: pcosFoodsToLimit,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'This is general education, not a personalized meal plan. A registered dietitian can tailor this further to your labs, preferences, and any other conditions.',
            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

class _GuidanceSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<FoodGuidanceGroup> groups;

  const _GuidanceSection({required this.title, required this.color, required this.groups});

  IconData _iconFor(String key) {
    switch (key) {
      case 'grass':
        return Icons.grass;
      case 'egg':
        return Icons.egg_outlined;
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'eco':
        return Icons.eco_outlined;
      case 'spa':
        return Icons.spa_outlined;
      case 'cookie':
        return Icons.cookie_outlined;
      case 'fastfood':
        return Icons.fastfood_outlined;
      case 'icecream':
        return Icons.icecream_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ),
        ...groups.map((g) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_iconFor(g.icon), size: 18, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(g.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...g.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.circle, size: 6, color: color),
                              const SizedBox(width: 8),
                              Expanded(child: Text(item, style: theme.textTheme.bodySmall)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Recipe browser tab
// ---------------------------------------------------------------------------

class _RecipeBrowserTab extends StatefulWidget {
  const _RecipeBrowserTab();

  @override
  State<_RecipeBrowserTab> createState() => _RecipeBrowserTabState();
}

class _RecipeBrowserTabState extends State<_RecipeBrowserTab> {
  Cuisine? _cuisineFilter;
  MealType? _mealTypeFilter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<PcosRecipe> recipes = _query.isNotEmpty ? RecipeRepository.search(_query) : RecipeRepository.all;
    if (_cuisineFilter != null) recipes = recipes.where((r) => r.cuisine == _cuisineFilter).toList();
    if (_mealTypeFilter != null) recipes = recipes.where((r) => r.mealType == _mealTypeFilter).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search recipes or ingredients...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChip(
                label: 'All Cuisines',
                selected: _cuisineFilter == null,
                onTap: () => setState(() => _cuisineFilter = null),
              ),
              ...Cuisine.values.map((c) => _FilterChip(
                    label: '${c.flagEmoji} ${c.label}',
                    selected: _cuisineFilter == c,
                    onTap: () => setState(() => _cuisineFilter = _cuisineFilter == c ? null : c),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChip(
                label: 'All Meals',
                selected: _mealTypeFilter == null,
                onTap: () => setState(() => _mealTypeFilter = null),
              ),
              ...MealType.values.map((m) => _FilterChip(
                    label: m.label,
                    selected: _mealTypeFilter == m,
                    onTap: () => setState(() => _mealTypeFilter = _mealTypeFilter == m ? null : m),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: recipes.isEmpty
              ? Center(
                  child: Text('No recipes match your filters yet.', style: theme.textTheme.bodyMedium),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) => _RecipeCard(recipe: recipes[index]),
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final PcosRecipe recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(recipe.cuisine.flagEmoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(recipe.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(recipe.description, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${recipe.totalMinutes} min', style: theme.textTheme.bodySmall),
                  const SizedBox(width: 12),
                  Icon(Icons.restaurant_menu, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(recipe.mealType.label, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: recipe.tags
                    .take(3)
                    .map((t) => Chip(
                          label: Text(t.label, style: const TextStyle(fontSize: 10)),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pantry match ("What can I make?") tab
// ---------------------------------------------------------------------------

class _PantryMatchTab extends StatefulWidget {
  const _PantryMatchTab();

  @override
  State<_PantryMatchTab> createState() => _PantryMatchTabState();
}

class _PantryMatchTabState extends State<_PantryMatchTab> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _ingredients = [];
  List<PcosRecipe> _results = [];
  bool _searched = false;

  void _addIngredient(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _ingredients.add(trimmed);
      _controller.clear();
    });
  }

  void _removeIngredient(String value) {
    setState(() => _ingredients.remove(value));
  }

  void _findRecipes() {
    setState(() {
      _results = RecipeRepository.matchByAvailableIngredients(_ingredients);
      _searched = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            'Add the ingredients you have on hand, and we\'ll suggest PCOS-friendly recipes that use them.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'e.g. tofu, spinach, chickpeas',
              prefixIcon: const Icon(Icons.add),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => _addIngredient(_controller.text),
              ),
            ),
            onSubmitted: _addIngredient,
          ),
        ),
        if (_ingredients.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ingredients
                  .map((i) => InputChip(
                        label: Text(i),
                        onDeleted: () => _removeIngredient(i),
                      ))
                  .toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _ingredients.isEmpty ? null : _findRecipes,
              icon: const Icon(Icons.search),
              label: const Text('Find Recipes'),
            ),
          ),
        ),
        Expanded(
          child: !_searched
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Your matched recipes will appear here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : _results.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No close matches yet — try adding a few more ingredients like onion, garlic, or a protein source.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _results.length,
                      itemBuilder: (context, index) => _RecipeCard(recipe: _results[index]),
                    ),
        ),
      ],
    );
  }
}

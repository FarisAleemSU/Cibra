import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe.dart';
import '../data/dummy_data.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> _recipes = [];
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _recipes = [...dummyRecipes];
  }

  void _addRecipe(Recipe recipe) {
    setState(() {
      _recipes.add(recipe);
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      final index = _recipes.indexWhere((r) => r.id == id);
      if (index != -1) {
        final updated = _recipes[index].copyWith(isFavorite: !_recipes[index].isFavorite);
        _recipes[index] = updated;
      }
    });
  }

  void _removeRecipe(String id) {
    setState(() {
      _recipes.removeWhere((r) => r.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = _recipes.where((r) => r.isFavorite).toList();
    final otherRecipes = _recipes.where((r) => !r.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: Icon(
              _isDeleting ? Icons.delete_forever : Icons.delete_outline,
              color: _isDeleting ? Colors.red : const Color.fromARGB(255, 108, 8, 125),
            ),
            onPressed: () {
              setState(() => _isDeleting = !_isDeleting);
            },
          )
        ],
      ),
      body: ListView(
        children: [
          if (favoriteRecipes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                '❤️ Favorites',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ...favoriteRecipes.map((r) => _buildRecipeTile(r)).toList(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(thickness: 1),
            ),
          ],
          ...otherRecipes.map((r) => _buildRecipeTile(r)).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final recipe = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipe()),
          );
          if (recipe != null) _addRecipe(recipe);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecipeTile(Recipe r) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            r.title,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          ),
          onTap: () async {
            if (_isDeleting) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Recipe'),
                  content: const Text('Are you sure you want to delete this recipe?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) _removeRecipe(r.id);
              return;
            }

            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: r),
              ),
            );
            if (updated != null && updated is Recipe) {
              setState(() {
                final index = _recipes.indexWhere((el) => el.id == updated.id);
                if (index != -1) _recipes[index] = updated;
              });
            }
          },
          trailing: IconButton(
            icon: Icon(
              r.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: r.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => _toggleFavorite(r.id),
          ),
        ),
      ),
    );
  }
}

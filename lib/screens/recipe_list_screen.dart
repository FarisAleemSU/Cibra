import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import 'add_recipe.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoriteRecipes = recipeProvider.recipes.where((r) => r.isFavorite).toList();
    final otherRecipes = recipeProvider.recipes.where((r) => !r.isFavorite).toList();

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
      body: recipeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                  ...favoriteRecipes.map((r) => _buildRecipeTile(r, recipeProvider)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(thickness: 1),
                  ),
                ],
                ...otherRecipes.map((r) => _buildRecipeTile(r, recipeProvider)),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
          );
          if (newRecipe != null && newRecipe is Recipe) {
            await recipeProvider.addRecipe(newRecipe);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecipeTile(Recipe r, RecipeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: r.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    r.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                )
              : const Icon(Icons.image),
          title: Text(
            r.title,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          ),
          onTap: () async {
            if (_isDeleting) {
              final confirm = await showDialog<bool>(
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
              if (confirm == true) await provider.deleteRecipe(r.id);
              return;
            }

            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: r),
              ),
            );
            if (updated != null && updated is Recipe) {
              await provider.updateRecipe(updated);
            }
          },
          trailing: IconButton(
            icon: Icon(
              r.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: r.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => provider.toggleFavorite(r.id),
          ),
        ),
      ),
    );
  }
}

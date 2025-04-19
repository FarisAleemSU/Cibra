import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/recipe.dart';
import '../utils/styles.dart';
import 'package:flutter_application_1/screens/recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  final bool showFavorites;
  
  const RecipeListScreen({
    super.key,
    this.showFavorites = false
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> _recipes = [
    Recipe(
      id: '1',
      title: 'Vegetarian Pasta',
      time: '30 mins',
      difficulty: 'Medium',
      ingredients: ['Pasta', 'Tomatoes', 'Basil', 'Olive Oil'],
      instructions: '1. Boil pasta...',
      imageUrl: 'https://picsum.photos/200/300?food=1',
      isFavorite: true,
    ),
    Recipe(
      id: '2',
      title: 'Chicken Curry',
      time: '45 mins',
      difficulty: 'Hard',
      ingredients: ['Chicken', 'Curry Powder', 'Coconut Milk'],
      instructions: '1. Cook chicken...',
      imageUrl: 'https://picsum.photos/200/300?food=2',
      isFavorite: false,
    ),
    Recipe(
      id: '3',
      title: 'Caesar Salad',
      time: '15 mins',
      difficulty: 'Easy',
      ingredients: ['Lettuce', 'Croutons', 'Parmesan', 'Dressing'],
      instructions: '1. Mix ingredients...',
      imageUrl: 'https://picsum.photos/200/300?food=3',
      isFavorite: true,
    ),
  ];

  List<Recipe> get _displayRecipes {
    return widget.showFavorites
        ? _recipes.where((recipe) => recipe.isFavorite).toList()
        : _recipes;
  }

  void _removeRecipe(String id) {
    setState(() {
      _recipes.removeWhere((recipe) => recipe.id == id);
    });
  }

  void _toggleFavorite(String recipeId) {
    setState(() {
      _recipes = _recipes.map((recipe) {
        if (recipe.id == recipeId) {
          return recipe.copyWith(isFavorite: !recipe.isFavorite);
        }
        return recipe;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.showFavorites ? 'Favorite Recipes' : 'All Recipes',
          style: Styles.heading1
        ),
        backgroundColor: Styles.backgroundColor,
      ),
      body: ListView.builder(
        itemCount: _displayRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _displayRecipes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Slidable(
              key: Key(recipe.id),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (context) => _removeRecipe(recipe.id),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              child: Card(
                child: ListTile(
              leading: const Icon(Icons.restaurant_menu,
                  color: Styles.primaryColor),
              title: Text(recipe.title,
                  style: const TextStyle(
                      fontFamily: Styles.fontFamily,
                      fontWeight: FontWeight.w500)),
              subtitle: Text(  // Fixed this section
                '${recipe.time} • ${recipe.difficulty}',
                style: const TextStyle(fontFamily: Styles.fontFamily),
              ),  // Added closing parenthesis
              trailing: Icon(
                recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onTap: () async {
                final updatedRecipe = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                  ),  // Added closing parenthesis
                );
                
                if (updatedRecipe != null) {
                  _toggleFavorite(updatedRecipe.id);
                }
              },
            ),
                
            ),
          )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add recipe functionality
        },
        backgroundColor: Styles.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
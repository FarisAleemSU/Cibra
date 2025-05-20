import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'base_screen.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipeService _recipeService = RecipeService();

  final String _userId = 'testuser123'; // Temporary user placeholder

  String title = '';
  String time = '';
  String difficulty = '';
  String instructions = '';
  String imageUrl = '';
  List<String> ingredients = [];

  final TextEditingController _ingredientController = TextEditingController();

  void _submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Recipe newRecipe = Recipe(
        id: '',
        title: title,
        time: time,
        difficulty: difficulty,
        instructions: instructions,
        imageUrl: imageUrl,
        ingredients: ingredients,
        isFavorite: false,
      );

      try {
        await _recipeService.addRecipe(newRecipe, _userId);
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BaseScreen(initialIndex: 2)),
          (route) => false,
        );
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding recipe: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value!,
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Time'),
                onSaved: (value) => time = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Difficulty'),
                onSaved: (value) => difficulty = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => imageUrl = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Instructions'),
                onSaved: (value) => instructions = value!,
                maxLines: 3,
              ),
              TextFormField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Add Ingredient (e.g. 2 tbsp sugar)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_ingredientController.text.trim().isNotEmpty) {
                        setState(() {
                          ingredients.add(_ingredientController.text.trim());
                          _ingredientController.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: ingredients
                    .map((ingredient) => Chip(
                          label: Text(ingredient),
                          onDeleted: () {
                            setState(() {
                              ingredients.remove(ingredient);
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRecipe,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

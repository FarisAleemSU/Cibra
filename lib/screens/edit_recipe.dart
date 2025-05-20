import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'base_screen.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipeService _recipeService = RecipeService();

  late String title;
  late String time;
  late String difficulty;
  late String instructions;
  late String imageUrl;
  late List<String> ingredients;

  final TextEditingController _ingredientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    title = widget.recipe.title;
    time = widget.recipe.time;
    difficulty = widget.recipe.difficulty;
    instructions = widget.recipe.instructions;
    imageUrl = widget.recipe.imageUrl;
    ingredients = List.from(widget.recipe.ingredients);
  }

  void _submitEdit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Recipe updated = widget.recipe.copyWith(
        title: title,
        time: time,
        difficulty: difficulty,
        instructions: instructions,
        imageUrl: imageUrl,
        ingredients: ingredients,
      );

      try {
        await _recipeService.updateRecipe(widget.recipe.id, updated);
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BaseScreen(initialIndex: 2)),
          (route) => false,
        );
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating recipe: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                initialValue: time,
                decoration: const InputDecoration(labelText: 'Time'),
                onSaved: (value) => time = value!,
              ),
              TextFormField(
                initialValue: difficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                onSaved: (value) => difficulty = value!,
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => imageUrl = value!,
              ),
              TextFormField(
                initialValue: instructions,
                decoration: const InputDecoration(labelText: 'Instructions'),
                onSaved: (value) => instructions = value!,
                maxLines: 3,
              ),
              TextFormField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Add Ingredient',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_ingredientController.text.isNotEmpty) {
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
                onPressed: _submitEdit,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

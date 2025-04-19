import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'recipe_detail_screen.dart';
import '../models/recipe.dart';

List<File> recipeImages = [];
String recipeName = '';
String prepTime = '';
String servings = '';
String calories = '';
List<Map<String, String>> ingredients = [];
List<String> steps = [];

final ImagePicker _picker = ImagePicker();

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => AddRecipeState();
}

class AddRecipeState extends State<AddRecipe> {
  File? recipeImage;
  String selectedUnit = 'g';
  final List<String> units = ['g', 'cups', 'tbsp'];
  List<bool> portionErrors = [];

  final Color burntOrange = const Color(0xFFCC5500);
  final Color rustOrange = const Color(0xFF8B4000);

  Widget recipeDetailInput(String hint, Function(String) onChanged) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: burntOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget ingredientNameInput({
    required String hint,
    required String value,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: rustOrange,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

  Widget ingredientPortionInput({
    required String hint,
    required String value,
    required Function(String) onChanged,
    required bool showError,
    required int index,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: rustOrange,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (val) {
              final isValid = RegExp(r'^\d*\.?\d*$').hasMatch(val) && val.isNotEmpty;
              onChanged(val);
              setState(() {
                portionErrors[index] = !isValid;
              });
            },
          ),
        ),
        if (showError)
          const Padding(
            padding: EdgeInsets.only(top: 4.0, left: 4),
            child: Text(
              'Please enter a number',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void addImage() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        recipeImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      recipeImages.removeAt(index);
    });
  }

  bool validatePortions() {
    for (int i = 0; i < ingredients.length; i++) {
      String value = ingredients[i]['amount']!;
      bool isValid = RegExp(r'^\d*\.?\d*$').hasMatch(value) && value.isNotEmpty;
      if (!isValid) return false;
    }
    return true;
  }

  void handleSubmit() {
    if (!validatePortions()) {
      setState(() {
        portionErrors = List.generate(ingredients.length, (index) {
          final value = ingredients[index]['amount']!;
          return !(RegExp(r'^\d*\.?\d*$').hasMatch(value) && value.isNotEmpty);
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix portion errors before submitting.')),
      );
      return;
    }

      final newRecipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: recipeName,
      time: prepTime,
      difficulty: _getDifficulty(), // Add this helper method
      ingredients: ingredients.map((i) => i['name']!).toList(),
      instructions: steps.join('\n'),
      imageUrl: recipeImages.isNotEmpty ? recipeImages.first.path : '',
      isFavorite: false,
    );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: newRecipe),
      )
      );
    }


    String _getDifficulty() {
      if (prepTime.contains('30')) return 'Medium';
      if (prepTime.contains('45')) return 'Hard';
      return 'Easy'; 
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 160, 40),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: rustOrange,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Recipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: handleSubmit,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recipeImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == recipeImages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150,
                          color: Colors.grey[800],
                          child: InkWell(
                            onTap: addImage,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Tap + to add images", style: TextStyle(fontSize: 12, color: Colors.white70)),
                                SizedBox(height: 8),
                                Icon(Icons.add, size: 36, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(recipeImages[index], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => removeImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: burntOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter recipe name',
                      hintStyle: TextStyle(color: Colors.white70),
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    onChanged: (value) => setState(() => recipeName = value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(child: recipeDetailInput("Prep Time", (val) => setState(() => prepTime = val))),
                    const SizedBox(width: 8),
                    Expanded(child: recipeDetailInput("Servings", (val) => setState(() => servings = val))),
                    const SizedBox(width: 8),
                    Expanded(child: recipeDetailInput("Calories", (val) => setState(() => calories = val))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: burntOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ingredients.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(8),
                              fillColor: Colors.grey[800],
                              selectedColor: Colors.white,
                              color: Colors.white70,
                              isSelected: units.map((u) => u == selectedUnit).toList(),
                              onPressed: (int index) {
                                setState(() {
                                  selectedUnit = units[index];
                                });
                              },
                              children: units.map((unit) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(unit),
                              )).toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (ingredients.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("List your ingredients here", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
                          ),
                        )
                      else
                        ...ingredients.asMap().entries.map((entry) {
                          int index = entry.key;
                          var ingredient = entry.value;
                          if (portionErrors.length < ingredients.length) {
                            portionErrors.add(false);
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      ingredients.removeAt(index);
                                      portionErrors.removeAt(index);
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  flex: 4,
                                  child: ingredientNameInput(
                                    hint: "Ingredient",
                                    value: ingredient['name']!,
                                    onChanged: (val) => setState(() => ingredient['name'] = val),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: ingredientPortionInput(
                                    hint: selectedUnit,
                                    value: ingredient['amount']!,
                                    onChanged: (val) => setState(() => ingredient['amount'] = val),
                                    showError: portionErrors[index],
                                    index: index,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            ingredients.add({"name": "", "amount": ""});
                            portionErrors.add(false);
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text("Add Ingredient", style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: burntOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: steps.isEmpty
                            ? const Center(
                                child: Text("List your steps here", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
                              )
                            : ListView.builder(
                                itemCount: steps.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("\u2022 ", style: TextStyle(fontSize: 18, color: Colors.white)),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: "Step ${index + 1}",
                                              hintStyle: const TextStyle(color: Colors.white70),
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor: rustOrange,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                            ),
                                            maxLines: null,
                                            style: const TextStyle(color: Colors.white),
                                            onChanged: (val) => setState(() => steps[index] = val),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ElevatedButton(
                          onPressed: () => setState(() => steps.add("")),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text("Add Step", style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/recipe.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final servingsController = TextEditingController();
  final caloriesController = TextEditingController();

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> unitOptions = ['g', 'ml', 'cups', 'tbsp', 'tsp', 'unit'];
  String selectedDifficulty = 'Easy';

  List<Map<String, String>> ingredients = [
    {'name': '', 'amount': '', 'unit': 'g'}
  ];

  List<String> steps = [''];
  List<bool> portionErrors = [];

  void pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

bool validatePortions() {
  for (var i = 0; i < ingredients.length; i++) {
    final value = ingredients[i]['amount'] ?? '';
    final isValid = RegExp(r'^\d*\.?\d+$').hasMatch(value);  // ✅ fixed
    if (!isValid) return false;
  }
  return true;
}

  void handleSubmit() {
    if (!validatePortions()) {
      setState(() {
        portionErrors = List.generate(ingredients.length, (i) {
          final val = ingredients[i]['amount'] ?? '';
          return !(RegExp(r'^\d*\.?\d+$').hasMatch(val));  // ✅ fixed
          });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix portion inputs.')),
      );
      return;
    }

    final recipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      time: timeController.text,
      servings: servingsController.text,
      calories: caloriesController.text,
      difficulty: selectedDifficulty,
      imageUrl: imageFile?.path ?? '',
      ingredients: ingredients.map((i) {
        final amount = i['amount'] ?? '';
        final unit = i['unit'];
        final name = i['name'] ?? '';
        return '$amount${unit != null && unit != 'unit' ? ' $unit' : ''} $name'.trim();
      }).toList(),
      instructions: steps.join('\n'),
      isFavorite: false,
    );

    Navigator.pop(context, recipe);
  }

  Widget _buildEditableChip({required IconData icon, required Widget inputWidget}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          inputWidget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text('Add Recipe', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: handleSubmit,
            icon: Icon(Icons.check, color: primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildEditableChip(
                  icon: Icons.timer_outlined,
                  inputWidget: SizedBox(
                    width: 60,
                    child: TextField(
                      controller: timeController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Time'),
                    ),
                  ),
                ),
                _buildEditableChip(
                  icon: Icons.restaurant_menu,
                  inputWidget: SizedBox(
                    width: 60,
                    child: TextField(
                      controller: servingsController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Servings'),
                    ),
                  ),
                ),
                _buildEditableChip(
                  icon: Icons.local_fire_department,
                  inputWidget: SizedBox(
                    width: 60,
                    child: TextField(
                      controller: caloriesController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Calories'),
                    ),
                  ),
                ),
                _buildEditableChip(
                  icon: Icons.speed,
                  inputWidget: DropdownButton<String>(
                    value: selectedDifficulty,
                    underline: const SizedBox(),
                    onChanged: (val) => setState(() => selectedDifficulty = val!),
                    items: difficulties.map((level) => DropdownMenuItem(value: level, child: Text(level))).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 8),
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageFile!, height: 100, width: 100, fit: BoxFit.cover),
              ),

            const SizedBox(height: 20),
            Text("Ingredients", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            ...ingredients.asMap().entries.map((entry) {
              final i = entry.key;
              return Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Ingredient'),
                      onChanged: (val) => ingredients[i]['name'] = val,
                      controller: TextEditingController(text: ingredients[i]['name']),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        errorText: (portionErrors.length > i && portionErrors[i]) ? 'Invalid' : null,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) => ingredients[i]['amount'] = val,
                      controller: TextEditingController(text: ingredients[i]['amount']),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: ingredients[i]['unit'],
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: unitOptions.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) => setState(() => ingredients[i]['unit'] = val!),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => setState(() => ingredients.removeAt(i)),
                  ),
                ],
              );
            }),
            TextButton(
              onPressed: () => setState(() => ingredients.add({'name': '', 'amount': '', 'unit': 'g'})),
              child: Text("Add Ingredient", style: TextStyle(color: primaryColor)),
            ),

            const SizedBox(height: 16),
            Text("Instructions", style: Theme.of(context).textTheme.titleMedium),
            ...steps.asMap().entries.map((entry) {
              final i = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Step'),
                      onChanged: (val) => steps[i] = val,
                      controller: TextEditingController(text: steps[i]),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => setState(() => steps.removeAt(i)),
                  ),
                ],
              );
            }),
            TextButton(
              onPressed: () => setState(() => steps.add('')),
              child: Text("Add Step", style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}

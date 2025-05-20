import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController titleController;
  late TextEditingController timeController;
  late TextEditingController servingsController;
  late TextEditingController caloriesController;
  List<Map<String, String>> ingredients = [];
  List<String> steps = [];
  List<File> imageFiles = [];
  late String selectedDifficulty;

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> unitOptions = ['g', 'ml', 'cups', 'tbsp', 'tsp', 'unit'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.recipe.title);
    timeController = TextEditingController(text: widget.recipe.time);
    servingsController = TextEditingController(text: widget.recipe.servings);
    caloriesController = TextEditingController(text: widget.recipe.calories);
    selectedDifficulty = widget.recipe.difficulty;

    ingredients = widget.recipe.ingredients.map((entry) {
      final parts = entry.split(' ');
      if (parts.length >= 2 && unitOptions.contains(parts[1])) {
        return {
          'amount': parts[0],
          'unit': parts[1],
          'name': parts.sublist(2).join(' ')
        };
      } else {
        return {
          'amount': parts[0],
          'unit': 'unit',
          'name': parts.sublist(1).join(' ')
        };
      }
    }).toList();

    steps = widget.recipe.instructions.split('\n');

    if (!widget.recipe.imageUrl.startsWith('http') && widget.recipe.imageUrl.isNotEmpty) {
      imageFiles = [File(widget.recipe.imageUrl)];
    }
  }

  void updateRecipe() {
    final updatedRecipe = widget.recipe.copyWith(
      title: titleController.text,
      time: timeController.text,
      servings: servingsController.text,
      calories: caloriesController.text,
      difficulty: selectedDifficulty,
      ingredients: ingredients.map((i) {
        final amount = i['amount'] ?? '';
        final unit = i['unit'];
        final name = i['name'] ?? '';
        return '$amount${unit != null && unit != 'unit' ? ' $unit' : ''} $name'.trim();
      }).toList(),
      instructions: steps.join('\n'),
      imageUrl: imageFiles.isNotEmpty
      ? imageFiles.first.path
      : widget.recipe.imageUrl, // fallback to existing URL
    );
    Navigator.pop(context, updatedRecipe);
  }

  void addImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFiles = [File(picked.path)]);
    }
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
        title: Text('Edit Recipe', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: updateRecipe,
            icon: Icon(Icons.check, color: primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: addImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Select Image"),
                ),
                const SizedBox(height: 8),
                if (imageFiles.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imageFiles.first, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 20),
                Text("Ingredients", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                ...ingredients.asMap().entries.map((entry) {
                  final i = entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            decoration: const InputDecoration(hintText: 'Ingredient'),
                            onChanged: (val) => ingredients[i]['name'] = val,
                            controller: TextEditingController(text: ingredients[i]['name']),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: const InputDecoration(hintText: 'Amt'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (val) => ingredients[i]['amount'] = val,
                            controller: TextEditingController(text: ingredients[i]['amount']),
                          ),
                        ),
                        Expanded(
                          flex: 2,
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
                    ),
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
        ),
      ),
    );
  }
}

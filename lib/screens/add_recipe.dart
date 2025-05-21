import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import 'base_screen.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final servingsController = TextEditingController();
  final caloriesController = TextEditingController();
  final imageUrlController = TextEditingController();

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> unitOptions = ['g', 'ml', 'cups', 'tbsp', 'tsp', 'unit'];
  String? selectedDifficulty = 'Easy';

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
      final isValid = RegExp(r'^\d*\.?\d+$').hasMatch(value);
      if (!isValid) return false;
    }
    return true;
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!validatePortions()) {
      setState(() {
        portionErrors = List.generate(ingredients.length, (i) {
          final val = ingredients[i]['amount'] ?? '';
          return !(RegExp(r'^\d*\.?\d+$').hasMatch(val));
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix portion inputs.')),
      );
      return;
    }

    if (selectedDifficulty == null || !difficulties.contains(selectedDifficulty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid difficulty.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final recipe = Recipe(
      id: '',
      title: titleController.text.trim(),
      time: timeController.text.trim(),
      servings: servingsController.text.trim(),
      calories: caloriesController.text.trim(),
      difficulty: selectedDifficulty!,
      imageUrl: imageUrlController.text.trim().isNotEmpty
          ? imageUrlController.text.trim()
          : imageFile?.path ?? '',
      ingredients: ingredients.map((i) {
        final amount = i['amount'] ?? '';
        final unit = i['unit'];
        final name = i['name'] ?? '';
        return '$amount${unit != null && unit != 'unit' ? ' $unit' : ''} $name'.trim();
      }).toList(),
      instructions: steps.join('\n'),
      isFavorite: false,
      createdBy: user.uid,
      createdAt: DateTime.now(),
    );

    try {
      await Provider.of<RecipeProvider>(context, listen: false).addRecipe(recipe);
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Recipe'),
        actions: [
          IconButton(
            onPressed: handleSubmit,
            icon: Icon(Icons.check, color: primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildEditableChip(
                    icon: Icons.timer_outlined,
                    inputWidget: SizedBox(
                      width: 60,
                      child: TextFormField(
                        controller: timeController,
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Time'),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ),
                  _buildEditableChip(
                    icon: Icons.restaurant_menu,
                    inputWidget: SizedBox(
                      width: 60,
                      child: TextFormField(
                        controller: servingsController,
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Servings'),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ),
                  _buildEditableChip(
                    icon: Icons.local_fire_department,
                    inputWidget: SizedBox(
                      width: 60,
                      child: TextFormField(
                        controller: caloriesController,
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Calories'),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ),
                  _buildEditableChip(
                    icon: Icons.speed,
                    inputWidget: DropdownButton<String>(
                      value: selectedDifficulty,
                      underline: const SizedBox(),
                      onChanged: (val) => setState(() => selectedDifficulty = val),
                      items: difficulties
                          .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL (optional)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Select Image'),
              ),
              if (imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imageFile!, height: 100, width: 100, fit: BoxFit.cover),
                  ),
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
                        value: unitOptions.contains(ingredients[i]['unit']) ? ingredients[i]['unit'] : unitOptions.first,
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
      ),
    );
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
}
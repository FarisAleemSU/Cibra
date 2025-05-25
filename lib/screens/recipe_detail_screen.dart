import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'edit_recipe.dart';
import 'dart:io';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _recipe.title,
                style: const TextStyle(fontSize: 16.0),
              ),
              background: _buildHeroImage(),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final updatedRecipe = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditRecipeScreen(recipe: _recipe),
                    ),
                  );
                  if (updatedRecipe != null) {
                    setState(() {
                      _recipe = updatedRecipe;
                    });
                  }
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context),
                  const SizedBox(height: 10),
                  _buildPublicStatusChip(context), // ✅ Added public/private status
                  const SizedBox(height: 20),
                  _buildSectionTitle(context, 'Ingredients'),
                  _buildIngredientsCard(context),
                  const SizedBox(height: 20),
                  _buildSectionTitle(context, 'Instructions'),
                  _buildInstructionsCard(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    final imageUrl = _recipe.imageUrl;

    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
      );
    }

    return imageUrl.startsWith('http')
        ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imageFallback())
        : Image.file(File(imageUrl), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imageFallback());
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final List<Widget> infoChips = [];

    if (_recipe.time.isNotEmpty) {
      infoChips.add(_buildInfoChip(context, Icons.timer_outlined, _recipe.time));
    }
    if (_recipe.difficulty.isNotEmpty) {
      infoChips.add(_buildInfoChip(context, Icons.speed, _recipe.difficulty));
    }
    if (_recipe.servings != null && _recipe.servings!.isNotEmpty) {
      infoChips.add(_buildInfoChip(context, Icons.restaurant_menu, '${_recipe.servings} servings'));
    }
    if (_recipe.calories != null && _recipe.calories!.isNotEmpty) {
      infoChips.add(_buildInfoChip(context, Icons.local_fire_department, '${_recipe.calories} kcal'));
    }

    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: infoChips,
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicStatusChip(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _recipe.isPublic
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _recipe.isPublic ? Colors.green : Colors.red,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _recipe.isPublic ? Icons.public : Icons.lock,
              size: 18,
              color: _recipe.isPublic ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 6),
            Text(
              _recipe.isPublic ? "Public Recipe" : "Private Recipe",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: _recipe.isPublic ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildIngredientsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _recipe.ingredients.map((ingredient) {
            final parts = ingredient.split(' ');
            String amount = '';
            String unit = '';
            String name = '';

            if (parts.isNotEmpty) amount = parts[0];
            if (parts.length >= 2 && ['g', 'ml', 'cups', 'tbsp', 'tsp'].contains(parts[1])) {
              unit = parts[1];
              name = parts.sublist(2).join(' ');
            } else {
              unit = '';
              name = parts.sublist(1).join(' ');
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.circle, size: 6, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ),
                  Text(
                    '$amount${unit.isNotEmpty ? ' $unit' : ''}',
                    style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard(BuildContext context) {
    final steps = _recipe.instructions
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: steps
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

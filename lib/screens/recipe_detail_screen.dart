import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../utils/styles.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  
  const RecipeDetailScreen({
    super.key,
    required this.recipe
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title, style: Styles.heading1),
        backgroundColor: Styles.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, recipe.copyWith(
              isFavorite: !recipe.isFavorite
            )),
      )
      ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            const SizedBox(height: 20),
            _buildTimeDifficultyRow(),
            const SizedBox(height: 20),
            _buildSectionTitle('Ingredients'),
            _buildIngredientsList(),
            const SizedBox(height: 20),
            _buildSectionTitle('Instructions'),
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  // Keep your friend's helper methods but update styling
  Widget _buildHeroImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(recipe.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTimeDifficultyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoChip(Icons.timer, recipe.time),
        _buildInfoChip(Icons.speed, recipe.difficulty),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Styles.primaryColor),
      label: Text(text, style: TextStyle(
        fontFamily: Styles.fontFamily,
        color: Colors.grey.shade700
      )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Styles.primaryColor,
        fontFamily: Styles.fontFamily,
      ),
    );
  }

  Widget _buildIngredientsList() {
  return Column(
    children: recipe.ingredients
        .map((ingredient) => ListTile(
              leading: Icon(
                Icons.circle,
                size: 8,
                color: Styles.primaryColor,
              ),
              title: Text(
                ingredient,
                style: TextStyle(fontFamily: Styles.fontFamily),
              ),
            ))
        .toList(),
  );
}
  Widget _buildInstructions() {
    return Text(
      recipe.instructions,
      style: TextStyle(
        fontSize: 16, 
        height: 1.5,
        fontFamily: Styles.fontFamily
      ),
    );
  }
}
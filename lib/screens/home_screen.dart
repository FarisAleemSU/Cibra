import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/recipe_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'CIBRA',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.primary.withOpacity(0.08),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/recipe-search');
                },
              ),
              const SizedBox(height: 20),

              // Recipes Heading
              const Text(
                'Recipes you can make now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),

              // Recipes Grid from Firestore
              StreamBuilder<List<Recipe>>(
                stream: _recipeService.streamRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recipes available.'));
                  }

                  // Filter recipes by 'Easy' difficulty
                  final recipes = snapshot.data!
                      .where((r) => r.difficulty.toLowerCase() == 'easy')
                      .toList();

                  if (recipes.isEmpty) {
                    return const Center(child: Text('No easy recipes available.'));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                                child: recipe.imageUrl.isNotEmpty
                                    ? Image.network(
                                        recipe.imageUrl,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                      )
                                    : Container(
                                        height: 100,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image_not_supported),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          recipe.time,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

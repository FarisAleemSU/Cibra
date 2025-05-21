import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/app_drawer.dart';
import '../services/recipe_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  String _searchText = '';
  Timer? _debounce;

  List<TextSpan> highlightMatches(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];
    final matches = RegExp(RegExp.escape(query), caseSensitive: false).allMatches(text);

    if (matches.isEmpty) return [TextSpan(text: text)];

    final spans = <TextSpan>[];
    int last = 0;

    for (final match in matches) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ));
      last = match.end;
    }

    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    return spans;
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchText = value.trim();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search your recipes',
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchText = '';
                });
              },
            ),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: _onSearchChanged,
          onSubmitted: (value) {
            setState(() {
              _searchText = value.trim();
            });
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recently Searched',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Recipe>>(
                stream: _recipeService.streamRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading recipes: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recipes found.'));
                  }

                  final q = _searchText.toLowerCase();

                  final filtered = snapshot.data!.where((r) {
                    final title = r.title.toLowerCase();
                    final ingredients = (r.ingredients ?? []).join(' ').toLowerCase();
                    final instructions = (r.instructions ?? '').toLowerCase();
                    return title.contains(q) || ingredients.contains(q) || instructions.contains(q);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No matching recipes.'));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final recipe = filtered[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: recipe.imageUrl.isNotEmpty
                                        ? NetworkImage(recipe.imageUrl)
                                        : const AssetImage('assets/images/placeholder.png')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                    onError: (_, __) {},
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: highlightMatches(recipe.title, _searchText),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
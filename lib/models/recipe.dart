class Recipe {
  final String id;
  final String title;
  final String time;
  final String difficulty;
  final String? servings;
  final String? calories;
  final List<String> ingredients;
  final String instructions;
  final String imageUrl;
  final bool isFavorite;
  final String? category; // ✅ Made optional

  Recipe({
    required this.id,
    required this.title,
    required this.time,
    required this.difficulty,
    this.servings,
    this.calories,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.isFavorite,
    this.category, // ✅ Optional so not required in Add/Edit screens
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? time,
    String? difficulty,
    String? servings,
    String? calories,
    List<String>? ingredients,
    String? instructions,
    String? imageUrl,
    bool? isFavorite,
    String? category,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }
}

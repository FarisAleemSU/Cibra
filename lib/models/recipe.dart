class Recipe {
  final String id;
  final String title;
  final String time;
  final String difficulty;
  final List<String> ingredients;
  final String instructions;
  final String imageUrl;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.time,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.isFavorite 
  });

  Recipe copyWith({
    bool? isFavorite,
  }) {
    return Recipe(
      id: id,
      title: title,
      time: time,
      difficulty: difficulty,
      ingredients: ingredients,
      instructions: instructions,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
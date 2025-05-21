import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String? category;
  final String? createdBy;
  final DateTime? createdAt;

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
    this.category,
    this.createdBy,
    this.createdAt,
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
    String? createdBy,
    DateTime? createdAt,
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
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'difficulty': difficulty,
      'servings': servings,
      'calories': calories,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'category': category,
      if (createdBy != null) 'createdBy': createdBy,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  static Recipe fromMap(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      time: data['time'] ?? '',
      difficulty: data['difficulty'] ?? '',
      servings: data['servings'],
      calories: data['calories'],
      ingredients: List<String>.from(data['ingredients'] ?? []),
      instructions: data['instructions'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      category: data['category'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

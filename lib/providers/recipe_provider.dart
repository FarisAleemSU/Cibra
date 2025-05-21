import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  final List<Recipe> _recipes = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _filterByUser = false; // Toggle for user-specific filtering

  RecipeProvider() {
    _startListeningToRecipes();
  }

  List<Recipe> get recipes => [..._recipes];
  bool get isLoading => _isLoading;

  void _startListeningToRecipes() {
    _isLoading = true;
    notifyListeners();

    _db
        .collection('recipes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final userId = _auth.currentUser?.uid;

      final List<Recipe> loaded = snapshot.docs
          .map((doc) => Recipe.fromMap(doc.data(), doc.id))
          .where((recipe) =>
              !_filterByUser || (userId != null && recipe.createdBy == userId))
          .toList();

      _recipes
        ..clear()
        ..addAll(loaded);

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addRecipe(Recipe recipe) async {
    final userId = _auth.currentUser?.uid;
    final data = {
      ...recipe.toMap(),
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _retryWithBackoff(() => _db.collection('recipes').add(data));
  }

  Future<void> deleteRecipe(String id) async {
    await _retryWithBackoff(() => _db.collection('recipes').doc(id).delete());
  }

  Future<void> updateRecipe(Recipe updatedRecipe) async {
    await _retryWithBackoff(() =>
        _db.collection('recipes').doc(updatedRecipe.id).update(updatedRecipe.toMap()));
  }

  Future<void> toggleFavorite(String id) async {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      final current = _recipes[index];
      final updated = current.copyWith(isFavorite: !current.isFavorite);
      await updateRecipe(updated);
    }
  }

  void enableUserFiltering(bool enable) {
    _filterByUser = enable;
    _startListeningToRecipes(); // restart stream
  }

  // 🔁 Exponential backoff wrapper for Firestore actions
  Future<void> _retryWithBackoff(Future<void> Function() action,
      {int maxRetries = 3}) async {
    int delayMs = 500;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await action();
        return; // Success
      } catch (e) {
        if (attempt == maxRetries - 1) {
          rethrow; // Final failure
        }
        await Future.delayed(Duration(milliseconds: delayMs));
        delayMs *= 2; // Exponential backoff
      }
    }
  }
}

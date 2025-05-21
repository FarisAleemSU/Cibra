import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference<Map<String, dynamic>> _recipes =
      FirebaseFirestore.instance.collection('recipes').withConverter<Map<String, dynamic>>(
            fromFirestore: (snapshot, _) => snapshot.data()!,
            toFirestore: (data, _) => data,
          );

  /// Real-time stream of recipes sorted by creation date (newest first)
  Stream<List<Recipe>> streamRecipes() {
    return _recipes.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Recipe.fromMap(doc.data(), doc.id);
        }).toList();
      },
    );
  }

  /// Add a new recipe with user ID and server timestamp
  Future<void> addRecipe(Recipe recipe, String userId) async {
    await _recipes.add({
      ...recipe.toMap(),
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update an existing recipe
  Future<void> updateRecipe(String id, Recipe recipe) async {
    await _recipes.doc(id).update(recipe.toMap());
  }

  /// Delete a recipe by ID
  Future<void> deleteRecipe(String id) async {
    await _recipes.doc(id).delete();
  }
}

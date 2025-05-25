import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference<Map<String, dynamic>> _recipes =
      FirebaseFirestore.instance.collection('recipes').withConverter<Map<String, dynamic>>(
            fromFirestore: (snapshot, _) => snapshot.data()!,
            toFirestore: (data, _) => data,
          );

  /// Real-time stream of recipes with optional filtering
  Stream<List<Recipe>> streamRecipes({bool filterPublic = false, String? userId}) {
    Query<Map<String, dynamic>> query = _recipes.orderBy('createdAt', descending: true);

    if (filterPublic) {
      query = query.where('isPublic', isEqualTo: true);
    } else if (userId != null) {
      query = query.where('createdBy', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Add a new recipe with metadata
  Future<void> addRecipe(Recipe recipe, String userId) async {
    await _recipes.add({
      ...recipe.toMap(),
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'isPublic': recipe.isPublic, // Make sure Recipe model has this
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

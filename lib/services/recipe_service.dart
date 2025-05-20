import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');

  Stream<List<Recipe>> streamRecipes() {
    return _recipes.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Recipe.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  Future<void> addRecipe(Recipe recipe, String userId) async {
  await _recipes.add({
    ...recipe.toFirestore(),
    'createdBy': userId,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

  Future<void> updateRecipe(String id, Recipe recipe) async {
    await _recipes.doc(id).update(recipe.toFirestore());
  }

  Future<void> deleteRecipe(String id) async {
    await _recipes.doc(id).delete();
  }
}
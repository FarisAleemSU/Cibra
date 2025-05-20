import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Temporary test user ID
  final String userId = 'test_user';

  Future<void> saveList(String type, List<Map<String, String>> items) async {
    final docRef = _db.collection('users').doc(userId);
    await docRef.set({type: items}, SetOptions(merge: true));
  }

  Future<List<Map<String, String>>> loadList(String type) async {
    final docRef = _db.collection('users').doc(userId);
    final snapshot = await docRef.get();
    if (snapshot.exists && snapshot.data()![type] != null) {
      List<dynamic> rawList = snapshot.data()![type];
      return rawList.map((e) => Map<String, String>.from(e)).toList();
    } else {
      return [];
    }
  }
}

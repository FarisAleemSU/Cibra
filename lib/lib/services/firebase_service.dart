
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String testUserId = 'testuser123';

  Future<void> saveInventory(List<Map<String, String>> inventory) async {
    await _db.collection('users').doc(testUserId).set({
      'inventory': inventory,
    }, SetOptions(merge: true));
  }

  Future<void> saveGrocery(List<Map<String, String>> grocery) async {
    await _db.collection('users').doc(testUserId).set({
      'grocery': grocery,
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, String>>> loadInventory() async {
    final doc = await _db.collection('users').doc(testUserId).get();
    final data = doc.data();
    return data != null && data['inventory'] != null
        ? List<Map<String, String>>.from(data['inventory'])
        : [];
  }

  Future<List<Map<String, String>>> loadGrocery() async {
    final doc = await _db.collection('users').doc(testUserId).get();
    final data = doc.data();
    return data != null && data['grocery'] != null
        ? List<Map<String, String>>.from(data['grocery'])
        : [];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  Future<void> saveInventory(List<Map<String, String>> inventory) async {
    await _db.collection('users').doc(_userId).set({
      'inventory': inventory,
    }, SetOptions(merge: true));
  }

  Future<void> saveGrocery(List<Map<String, String>> grocery) async {
    await _db.collection('users').doc(_userId).set({
      'grocery': grocery,
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, String>>> loadInventory() async {
    final doc = await _db.collection('users').doc(_userId).get();
    final data = doc.data();
    return data != null && data['inventory'] != null
        ? List<Map<String, String>>.from(data['inventory'])
        : [];
  }

  Future<List<Map<String, String>>> loadGrocery() async {
    final doc = await _db.collection('users').doc(_userId).get();
    final data = doc.data();
    return data != null && data['grocery'] != null
        ? List<Map<String, String>>.from(data['grocery'])
        : [];
  }
}
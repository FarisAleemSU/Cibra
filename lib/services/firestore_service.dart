import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID with null check
  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  Future<void> saveList(String type, List<Map<String, String>> items) async {
    try {
      final docRef = _db.collection('users').doc(_userId);
      await docRef.set({type: items}, SetOptions(merge: true));
      debugPrint('Saved $type list for user $_userId');
    } on FirebaseException catch (e) {
      debugPrint('Save error (${e.code}): ${e.message}');
      rethrow;
    }
  }

  Future<List<Map<String, String>>> loadList(String type) async {
    try {
      final docRef = _db.collection('users').doc(_userId);
      final snapshot = await docRef.get();
      
      if (snapshot.exists && snapshot.data()?[type] != null) {
        List<dynamic> rawList = snapshot.data()![type];
        return rawList.map((e) => Map<String, String>.from(e)).toList();
      }
      return [];
    } on FirebaseException catch (e) {
      debugPrint('Load error (${e.code}): ${e.message}');
      rethrow;
    }
  }
}
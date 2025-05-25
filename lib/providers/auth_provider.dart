import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/authservices.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  firebase_auth.User? _user;
  bool _isLoading = true;
  String? _userBio;
  String? _userId;


  AuthProvider(this._authService) {
    _initAuth();
    
  }
  

  firebase_auth.User? get user => _user;
  bool get isLoading => _isLoading;
  String? get userBio => _userBio;
  String? get userId => _userId;

  Future<void> _initAuth() async {
  _authService.authStateChanges.listen((firebase_auth.User? user) async {
    _user = user;
    _userId = user?.uid;
    _isLoading = false;

    if (user != null) {
      // Check if user document exists
      final doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!doc.exists) {
        // Create basic user document for new users
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName ?? 'New User',
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      await _loadUserProfile(user.uid);
    }
    
    notifyListeners();
  });
}

  Future<void> _loadUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _userBio = doc.data()?['bio'];
      }
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signIn(email, password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed');
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _userBio = null;
      _userId = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
  Future<void> signUp(String email, String password, String displayName) async {
  try {
    // 1. Create Firebase Auth user
    final userCredential = await _authService.signUp(email, password);
    
    // 2. Create Firestore user document
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    // 3. Update local state
    _user = userCredential.user;
    _userId = userCredential.user!.uid;
    _userBio = null;
    notifyListeners();

  } on firebase_auth.FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'Signup failed');
  }
}

  Future<void> updateUserProfile({
  required String displayName,
  String? bio,
}) async {
  try {
    await _user?.updateDisplayName(displayName);
    await _user?.reload();  // Add this to refresh user data
    _user = _authService.currentUser;
    
    await _firestore.collection('users').doc(_user?.uid).set({
      'displayName': displayName,
      'bio': bio,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    notifyListeners();
  } catch (e) {
    print('Error updating profile: $e');
    rethrow;
  }
}
}
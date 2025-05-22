import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/authservices.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  firebase_auth.User? _user;
  bool _isLoading = true;
  String? _userBio;

  String? get userBio => _userBio;

  AuthProvider(this._authService) {
    initAuth();
  }

  firebase_auth.User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> initAuth() async {
    _authService.authStateChanges.listen((firebase_auth.User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
  Future<void> updateUserProfile({
    required String displayName,
    String? bio,
  }) async {
    try {
      // Update Firebase user
      await _authService.updateDisplayName(displayName);
      
      // Update local state
      _user = _authService.currentUser;
      _userBio = bio;
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
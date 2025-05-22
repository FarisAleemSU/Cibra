import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to track authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email/password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code); // Use your error handler
    }
  }

  // Sign up with email/password
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = 
        await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  Future<void> updateDisplayName(String displayName) async {
    await _auth.currentUser?.updateDisplayName(displayName);
  }

  // Check if user is logged in (using Firebase Auth)
  User? get currentUser => _auth.currentUser;

  // Error message handling
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Password is too weak (min 6 characters)';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-not-found':
        return 'No account found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}
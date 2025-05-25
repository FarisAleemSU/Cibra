import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Stream to track authentication state changes
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
  
  
  // Sign up with email/password
  Future<firebase_auth.UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  
  
  // Sign in with email/password
  Future<firebase_auth.User?> signIn(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await firebase_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return result.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code); // Use your error handler
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
  firebase_auth.User? get currentUser => _auth.currentUser;

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
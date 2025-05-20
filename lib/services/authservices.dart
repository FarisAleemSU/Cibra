import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _isLoggedInKey = 'isLoggedIn';

  Future<bool> login(String email, String password) async {
    // TODO: Add real authentication logic
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    return true;
  }

  Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false; 
}

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }
}
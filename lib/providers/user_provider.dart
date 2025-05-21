import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _username;

  bool get isLoggedIn => _userId != null;
  String? get userId => _userId;
  String? get username => _username;

  void login(String userId, String username) {
    _userId = userId;
    _username = username;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _username = null;
    notifyListeners();
  }
}
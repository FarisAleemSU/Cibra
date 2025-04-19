import 'package:flutter/material.dart';
import 'services/authservices.dart';
import 'screens/base_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recipe_list_screen.dart';
import 'screens/recipe_search_screen.dart';
import 'screens/grocery_edit_screen.dart';
import 'screens/inventory_edit_screen.dart';
import 'screens/setting_p.dart';
import 'screens/smart_inv_mainscreen.dart';
import 'screens/unit_conv_p.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cibra',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
      ),
      home: const AuthWrapper(), // This should be the only entry point
      routes: {
        '/base': (context) => const BaseScreen(),
        '/home': (context) => const HomeScreen(),
        '/smart-inventory': (context) => const SmartInventoryMainScreen(),
        '/recipes': (context) => const RecipeListScreen(),
        '/grocery-edit': (context) => const GroceryEditScreen(),
        '/inventory-edit': (context) => const InventoryEditScreen(),
        '/recipe-search': (context) => const RecipeSearchScreen(),
        '/settings': (context) => const SettingP(),
        '/unit-converter': (context) => const UnitConvP(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found!')),
          ),
        );
      },
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        // Add debug logs
        print('Auth check - Connection state: ${snapshot.connectionState}');
        print('Auth check - Logged in: ${snapshot.data}');
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final isLoggedIn = snapshot.data ?? false;
        
        return isLoggedIn 
            ? const BaseScreen() 
            : const LoginScreen();
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'theme.dart'; 
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
import 'package:firebase_core/firebase_core.dart';
import 'screens/signup_screen.dart';
import 'providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        // Add other providers here
      ],
      child: const MyApp(),
    ),);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(AuthService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cibra',
        theme: appTheme,
        home: const AuthWrapper(),
        routes: {
        '/base': (context) => const BaseScreen(),
        '/home': (context) => const HomeScreen(),
        '/smart-inventory': (context) => const SmartInventoryMainScreen(),
        '/recipes': (context) => const RecipeListScreen(),
        '/recipe-search': (context) => const RecipeSearchScreen(),
        '/settings': (context) => const SettingP(),
        '/unit-converter': (context) => const UnitConvP(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup' : (context) => const SignupScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found!')),
          ),
        );
      },
    ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return authProvider.user != null 
        ? const BaseScreen() 
        : const LoginScreen();
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'services/authservices.dart';
import 'screens/base_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recipe_list_screen.dart';
import 'screens/recipe_search_screen.dart';
import 'screens/setting_p.dart';
import 'screens/smart_inv_mainscreen.dart';
import 'screens/unit_conv_p.dart';

import 'providers/user_provider.dart';
import 'providers/recipe_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
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
          '/recipes': (context) => RecipeListScreen(),
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
      ),
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const BaseScreen() : const LoginScreen();
      },
    );
  }
}  
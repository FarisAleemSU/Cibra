import 'package:flutter/material.dart';
import '../screens/base_screen.dart';
import '../screens/setting_p.dart';
import '../screens/unit_conv_p.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'CIBRA',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const BaseScreen(initialIndex: 0),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const BaseScreen(initialIndex: 3),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingP()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Unit Converter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UnitConvP()),
              );
            },
          ),
        ],
      ),
    );
  }
}
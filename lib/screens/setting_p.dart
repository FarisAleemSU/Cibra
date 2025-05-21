import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'unit_conv_p.dart';

class SettingP extends StatefulWidget {
  const SettingP({super.key});

  @override
  State<SettingP> createState() => _SettingPState();
}

class _SettingPState extends State<SettingP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Unit Conversion Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UnitConvP()));
            },
            child: const Center(
              child: Text(
                "Unit Conversion",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // User Manual Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("User Manual"),
                  content: const Text(
                    "• Use the Smart Inventory screen to track what you have.\n"
                    "• The Grocery List screen lets you manage items to buy.\n"
                    "• Recipes can be searched and saved with custom ingredients.\n"
                    "• Use Unit Conversion to switch between measurement types.\n\n"
                    "Explore each screen from the drawer menu!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    )
                  ],
                ),
              );
            },
            child: const Center(
              child: Text(
                "User Manual",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Credits Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Credits"),
                  content: const Text(
                    "Smart Inventory App\n"
                    "Version: 1.0.0\n\n"
                    "Developed by: Cibra Development Team\n"
                    "Special thanks to:\n"
                    "- Flutter Community\n"
                    "- Firebase Team",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    )
                  ],
                ),
              );
            },
            child: const Center(
              child: Text(
                "Credits",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
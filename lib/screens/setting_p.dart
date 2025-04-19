// lib/pages/setting_p.dart
import '../widgets/app_drawer.dart';
import 'unit_conv_p.dart';
import 'package:flutter/material.dart';

class SettingP extends StatefulWidget {
  const SettingP({super.key});

  @override
  State<SettingP> createState() => _SettingPState();
}

class _SettingPState extends State<SettingP> {
  bool inventorySync = true;
  bool darkMode = true;
  bool includeNuts = false;
  bool includeDairy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Offline Mode
          Card(
            color: Colors.grey.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Offline Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text("Download all recipes for offline use"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text("Download", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Inventory Sync
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: const Text("Inventory Sync", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Backup to cloud every 24 hours"),
              trailing: Switch(
                value: inventorySync,
                onChanged: (val) => setState(() => inventorySync = val),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dietary Preferences
          Card(
            color: Colors.grey.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dietary Preferences", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Text("Include nuts"),
                      const Spacer(),
                      Checkbox(value: includeNuts, onChanged: (val) => setState(() => includeNuts = val!)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Include dairy"),
                      const Spacer(),
                      Checkbox(value: includeDairy, onChanged: (val) => setState(() => includeDairy = val!)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Unit Conversion Button
          ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UnitConvP())),
                        child: const Center(child: Text("Unit Conversion", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                      ),
        ],
      ),

      // wrap nav in darker container
      bottomNavigationBar: Container(
        color: Colors.orange.shade700,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'inventory_edit_screen.dart';
import 'grocery_edit_screen.dart';
import '../theme.dart';
import '../services/firestore_service.dart';

class SmartInventoryMainScreen extends StatefulWidget {
  const SmartInventoryMainScreen({super.key});

  @override
  State<SmartInventoryMainScreen> createState() => _SmartInventoryMainScreenState();
}

class _SmartInventoryMainScreenState extends State<SmartInventoryMainScreen> {
  List<Map<String, String>> inventoryItems = [];
  List<Map<String, String>> groceryItems = [];
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final inventory = await _firestoreService.loadList('inventory');
    final grocery = await _firestoreService.loadList('grocery');
    setState(() {
      inventoryItems = inventory;
      groceryItems = grocery;
    });
  }

  void _navigateToEditInventory() async {
    final result = await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(builder: (_) => InventoryEditScreen(initialItems: inventoryItems)),
    );
    if (result != null) {
      setState(() => inventoryItems = result);
      await _firestoreService.saveList('inventory', inventoryItems);
    }
  }

  void _navigateToEditGrocery() async {
    final result = await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(builder: (_) => GroceryEditScreen(initialItems: groceryItems)),
    );
    if (result != null) {
      setState(() => groceryItems = result);
      await _firestoreService.saveList('grocery', groceryItems);
    }
  }

  Widget _buildSection(String title, List<Map<String, String>> items, VoidCallback onEdit) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              ],
            ),
            const SizedBox(height: 8),
            for (var item in items)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(item['name']!),
                subtitle: Text(item['quantity']!),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Smart Inventory'),
      ),
      body: ListView(
        children: [
          _buildSection("Inventory", inventoryItems, _navigateToEditInventory),
          _buildSection("Grocery List", groceryItems, _navigateToEditGrocery),
        ],
      ),
    );
  }
}

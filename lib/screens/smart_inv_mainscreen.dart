import 'package:flutter/material.dart';
// import '../widgets/app_drawer.dart';
class SmartInventoryMainScreen extends StatefulWidget {
  const SmartInventoryMainScreen({super.key});

  @override
  State<SmartInventoryMainScreen> createState() => _SmartInventoryMainScreenState();
}

class _SmartInventoryMainScreenState extends State<SmartInventoryMainScreen> {
  final List<Map<String, String>> inventoryItems = [
    {'name': 'Milk', 'quantity': '800 ml'},
    {'name': 'American Cheese', 'quantity': '4 slices'},
    {'name': 'Eggs', 'quantity': '12'},
    {'name': 'Basmati Rice', 'quantity': '500 gram'},
    {'name': 'Butter', 'quantity': '300 gram'},
  ];

  final List<Map<String, String>> groceryItems = [
    {'name': 'Chicken Breasts', 'quantity': '800 gram'},
    {'name': 'Beef', 'quantity': '1500 gram'},
    {'name': 'Cereal', 'quantity': '1000 gram'},
    {'name': 'Olive Oil', 'quantity': '500 ml'},
    {'name': 'Onions', 'quantity': '4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        elevation: 0,
        title: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Search Recipes...',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context), 
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.menu),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade200, Colors.orange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        constraints: const BoxConstraints.expand(), // ✅ fills screen
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/inventory'),
                child: _buildSection(title: 'Inventory', items: inventoryItems),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/grocery'),
                child: _buildSection(title: 'Grocery List', items: groceryItems),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> items,
  }) {
    final previewLimit = 4;
    final displayedItems = items.length > previewLimit
        ? items.take(previewLimit).toList()
        : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in displayedItems)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    '${item['name']}   ${item['quantity']}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              if (items.length > previewLimit)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    '...',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.add_circle,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
class GroceryEditScreen extends StatefulWidget {
  const GroceryEditScreen({super.key});

  @override
  State<GroceryEditScreen> createState() => _GroceryEditScreenState();
}

class _GroceryEditScreenState extends State<GroceryEditScreen> {
  List<Map<String, String>> groceryItems = [
    {'name': 'Chicken Breasts', 'quantity': '800 gram'},
    {'name': 'Beef', 'quantity': '1500 gram'},
    {'name': 'Cereal', 'quantity': '1000 gram'},
    {'name': 'Olive Oil', 'quantity': '500 ml'},
    {'name': 'Onions', 'quantity': '4'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Grocery Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _quantityController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final quantity = _quantityController.text.trim();

                if (name.isEmpty || quantity.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Invalid Input'),
                        content: const Text('Please fill in both fields before adding the item.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    groceryItems.add({'name': name, 'quantity': quantity});
                  });
                  _nameController.clear();
                  _quantityController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      groceryItems.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return Card(
            color: Colors.orange.shade100,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(item['name']!),
              subtitle: Text(item['quantity']!),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: () => _removeItem(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

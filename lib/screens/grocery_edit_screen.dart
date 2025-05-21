
import 'package:flutter/material.dart';
import '../theme.dart';

class GroceryEditScreen extends StatefulWidget {
  final List<Map<String, String>> initialItems;
  const GroceryEditScreen({required this.initialItems, super.key});

  @override
  State<GroceryEditScreen> createState() => _GroceryEditScreenState();
}

class _GroceryEditScreenState extends State<GroceryEditScreen> {
  late List<Map<String, String>> groceryItems;

  @override
  void initState() {
    super.initState();
    groceryItems = List.from(widget.initialItems);
  }

  void _deleteItem(int index) {
    setState(() => groceryItems.removeAt(index));
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name')),
              TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                final qty = qtyController.text.trim();
                if (name.isNotEmpty && qty.isNotEmpty) {
                  setState(() => groceryItems.add({'name': name, 'quantity': qty}));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Edit Grocery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, groceryItems),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return ListTile(
            title: Text(item['name']!),
            subtitle: Text(item['quantity']!),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deleteItem(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

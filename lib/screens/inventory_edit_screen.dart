
import 'package:flutter/material.dart';

class InventoryEditScreen extends StatefulWidget {
  final List<Map<String, String>> initialItems;
  const InventoryEditScreen({required this.initialItems, super.key});

  @override
  State<InventoryEditScreen> createState() => _InventoryEditScreenState();
}

class _InventoryEditScreenState extends State<InventoryEditScreen> {
  late List<Map<String, String>> inventoryItems;

  @override
  void initState() {
    super.initState();
    inventoryItems = List.from(widget.initialItems);
  }

  void _deleteItem(int index) {
    setState(() => inventoryItems.removeAt(index));
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
                  setState(() => inventoryItems.add({'name': name, 'quantity': qty}));
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
        title: const Text('Edit Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, inventoryItems),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          final item = inventoryItems[index];
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

// lib/pages/unit_conv_p.dart

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
class UnitConvP extends StatefulWidget {
  const UnitConvP({super.key});

  @override
  _UnitConvPState createState() => _UnitConvPState();
}

class _UnitConvPState extends State<UnitConvP> {
  final TextEditingController _valueController = TextEditingController();
  final List<String> _ingredients = ['Flour', 'Sugar', 'Butter', 'Milk', 'Water'];
  String? _selectedIngredient;
  final List<String> _units = ['g', 'kg', 'cup', 'tbsp', 'tsp'];
  String? _fromUnit;
  String? _toUnit;
  String _result = '';

  void _calculate() {
    final val = double.tryParse(_valueController.text);
    if (val != null &&
        _selectedIngredient != null &&
        _fromUnit != null &&
        _toUnit != null) {
      setState(() {
        _result = '${_valueController.text} $_fromUnit = ? $_toUnit';
      });
    } else {
      setState(() {
        _result = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Unit Conversion',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _valueController,
                      decoration: InputDecoration(
                        hintText: 'Enter value',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedIngredient,
                      decoration: InputDecoration(
                        hintText: 'Choose ingredient',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      items: _ingredients
                          .map((ing) => DropdownMenuItem(value: ing, child: Text(ing)))
                          .toList(),
                      onChanged: (val) {
                        setState(() => _selectedIngredient = val);
                        _calculate();
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('From'), Text('To')],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromUnit,
                            decoration: InputDecoration(
                              hintText: 'Unit',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                            onChanged: (val) {
                              setState(() => _fromUnit = val);
                              _calculate();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toUnit,
                            decoration: InputDecoration(
                              hintText: 'Unit',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                            onChanged: (val) {
                              setState(() => _toUnit = val);
                              _calculate();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(_result),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Favorite Conversions',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                title: Text('1 cup Flour = 120g'),
                trailing: Icon(Icons.star, color: Colors.blue),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                title: Text('1 cup Sugar = 200g'),
                trailing: Icon(Icons.star, color: Colors.blue),
              ),
            ),
          ],
        ),
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

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}

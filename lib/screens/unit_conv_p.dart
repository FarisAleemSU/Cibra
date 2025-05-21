import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme.dart';

class UnitConvP extends StatefulWidget {
  const UnitConvP({super.key});

  @override
  _UnitConvPState createState() => _UnitConvPState();
}

class _UnitConvPState extends State<UnitConvP> {
  final TextEditingController _valueController = TextEditingController();

  final List<String> massUnits = ['g', 'kg'];
  final List<String> volumeUnits = ['ml', 'l', 'cup', 'tbsp', 'tsp'];
  String? _fromUnit;
  String? _toUnit;
  String _conversionType = 'Mass';
  String _result = '';
  List<String> _favorites = [];

  final Map<String, double> unitFactors = {
    'g': 1,
    'kg': 1000,
    'ml': 1,
    'l': 1000,
    'cup': 240,
    'tbsp': 15,
    'tsp': 5,
  };

  void _calculate() {
    final val = double.tryParse(_valueController.text);
    if (val == null || _fromUnit == null || _toUnit == null) {
      setState(() => _result = '');
      return;
    }

    final fromFactor = unitFactors[_fromUnit!]!;
    final toFactor = unitFactors[_toUnit!]!;
    final converted = val * fromFactor / toFactor;

    setState(() {
      _result = '$val $_fromUnit = ${converted.toStringAsFixed(2)} $_toUnit';
    });
  }

  void _toggleFavorite() {
    if (_result.isEmpty) return;
    setState(() {
      if (_favorites.contains(_result)) {
        _favorites.remove(_result);
      } else {
        _favorites.add(_result);
      }
    });
  }

  bool _isFavorite(String item) => _favorites.contains(item);
  List<String> _filteredUnits() => _conversionType == 'Mass' ? massUnits : volumeUnits;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final units = _filteredUnits();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Unit Conversion',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
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
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _conversionType,
                      decoration: InputDecoration(
                        labelText: 'Conversion Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      items: ['Mass', 'Volume']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _conversionType = val!;
                          _fromUnit = null;
                          _toUnit = null;
                          _calculate();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _valueController,
                      decoration: InputDecoration(
                        hintText: 'Enter value',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                            onChanged: (val) {
                              setState(() {
                                _fromUnit = val;
                                _calculate();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toUnit,
                            decoration: InputDecoration(
                              hintText: 'Unit',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                            onChanged: (val) {
                              setState(() {
                                _toUnit = val;
                                _calculate();
                              });
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
                        Expanded(child: Text(_result)),
                        IconButton(
                          icon: Icon(
                            _isFavorite(_result) ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_favorites.isNotEmpty) ...[
              const Text(
                'Favorite Conversions',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._favorites.map((fav) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(fav),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() => _favorites.remove(fav));
                        },
                      ),
                    ),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}

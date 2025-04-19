import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _recipes = [
    {'name': 'Pasta Carbonara', 'image': 'assets/images/PastaCarbonara.jpg'},
    {'name': 'Chicken Curry', 'image': 'assets/images/istockphoto-579767430-612x612.jpg'},
    {'name': 'Garden Salad', 'image': 'assets/images/228823-quick-beef-stir-fry-DDMFS-4x3-1f79b031d3134f02ac27d79e967dfef5.jpg'},
    {'name': 'Beef Stir-Fry', 'image': 'assets/images/360_F_293220207_aSKIua6mTAymZDbIJOSOApeJ7vNoD6Zd.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        title: const Text('Recipe Finder', 
          style: TextStyle(
            fontFamily: Styles.fontFamily,
            color: Colors.black87,
          )),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/recipe-search');
                },
              ),
              const SizedBox(height: 20),
              
              // Recipes Heading
              const Text(
                'Recipes you can make now', 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  fontFamily: Styles.fontFamily
                ),
              ),
              const SizedBox(height: 15),
              
              // Recipe Cards (Horizontal Scroll)
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recipes.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 160,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15.0)),
                              child: Image.asset(
                                _recipes[index]['image'],
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _recipes[index]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Styles.fontFamily
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              
              // Smart Inventory Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/smart-inventory');
                  },
                  icon: const Icon(Icons.inventory_2),
                  label: const Text('Smart Inventory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
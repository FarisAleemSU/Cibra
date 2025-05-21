import '../models/recipe.dart';

final List<Recipe> dummyRecipes = [
  Recipe(
    id: '1',
    title: 'Vegetarian Pasta',
    time: '30 mins',
    difficulty: 'Medium',
    ingredients: ['200 g Pasta', '3 pcs Tomatoes', '5 leaves Basil', '2 tbsp Olive Oil'],
    instructions: 'Boil pasta...\nAdd sauce...\nServe.',
    imageUrl: 'https://source.unsplash.com/featured/?vegetarian,pasta',
    isFavorite: true,
  ),
  Recipe(
    id: '2',
    title: 'Chicken Curry',
    time: '45 mins',
    difficulty: 'Hard',
    ingredients: ['500 g Chicken', '2 tbsp Curry Powder', '200 ml Coconut Milk'],
    instructions: 'Sauté chicken...\nAdd spices...\nSimmer.',
    imageUrl: 'https://source.unsplash.com/featured/?chicken,curry',
    isFavorite: false,
  ),
  Recipe(
    id: '3',
    title: 'Caesar Salad',
    time: '15 mins',
    difficulty: 'Easy',
    ingredients: ['100 g Lettuce', '50 g Croutons', '30 g Parmesan', '3 tbsp Dressing'],
    instructions: 'Chop lettuce...\nToss with toppings...',
    imageUrl: 'https://source.unsplash.com/featured/?caesar,salad',
    isFavorite: true,
  ),
];

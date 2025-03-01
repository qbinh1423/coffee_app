import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/favoriteProvider.dart';

class FavoritePage extends StatefulWidget {
  final List<Widget> favoriteBeans;
  final List<Widget> favoriteDrinks;
  final List<Widget> favoriteTools;

  const FavoritePage({
    super.key,
    required this.favoriteBeans,
    required this.favoriteDrinks,
    required this.favoriteTools,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<String> categories = ["Beans", "Drinks", "Brewing Tools"];
  String selectedCategory = "Beans";

  @override
  Widget build(BuildContext context) {
    var favoriteProvider = Provider.of<FavoriteProvider>(context);

    List<Widget> currentFavorites = [];

    if (selectedCategory == "Beans") {
      currentFavorites = favoriteProvider.favoriteBeans;
    } else if (selectedCategory == "Drinks") {
      currentFavorites = favoriteProvider.favoriteDrinks;
    } else if (selectedCategory == "Brewing Tools") {
      currentFavorites = favoriteProvider.favoriteTools;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButtonFormField(
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: currentFavorites.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: currentFavorites.length,
                    itemBuilder: (context, index) {
                      return currentFavorites[index];
                    },
                  )
                : const Center(
                    child: Text(
                      "No favorites yet!",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

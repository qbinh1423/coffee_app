import 'package:flutter/material.dart';
import 'beansCard.dart';
import 'drinksCard.dart';
import 'brewingToolsCard.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, String>> _favoriteBeansData = [];
  final List<Map<String, String>> _favoriteDrinksData = [];
  final List<Map<String, String>> _favoriteToolsData = [];

  List<Widget> get favoriteBeans => _favoriteBeansData.map((data) {
        return BeansCard(
          beanName: data["beanName"]!,
          imageUrl: data["imageUrl"]!,
          altitude: "",
          climate: "",
          caffeine: "",
          description: data["description"],
        );
      }).toList();

  List<Widget> get favoriteDrinks => _favoriteDrinksData.map((data) {
        return DrinksCard(
          drinkName: data['drinkName']!,
          imageUrl: data['imageUrl']!,
          tool: "",
          origin: "",
          caffeine: "",
          description: data["description"]!,
          ingredient: "",
        );
      }).toList();

  List<Widget> get favoriteTools => _favoriteToolsData.map((data) {
        return BrewingToolsCard(
          toolName: data["toolName"]!,
          imageUrl: data["imageUrl"]!,
          description: data["description"],
        );
      }).toList();

  void addFavoriteItem(String category, Map<String, String> item) {
    if (category == "Beans") {
      _favoriteBeansData.add(item);
    } else if (category == "Drinks") {
      _favoriteDrinksData.add(item);
    } else if (category == "BrewingTools") {
      _favoriteToolsData.add(item);
    }
    notifyListeners();
  }

  void removeFavoriteItem(String category, String itemName) {
    if (category == "Beans") {
      _favoriteBeansData.removeWhere((bean) => bean["beanName"] == itemName);
    } else if (category == "Drinks") {
      _favoriteDrinksData
          .removeWhere((drink) => drink["drinkName"] == itemName);
    } else if (category == "BrewingTools") {
      _favoriteToolsData.removeWhere((tool) => tool["toolName"] == itemName);
    }
    notifyListeners();
  }
}

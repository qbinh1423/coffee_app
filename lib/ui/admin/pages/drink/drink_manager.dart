import 'package:coffee_app/models/drink.dart';
import 'package:flutter/foundation.dart';

import '../../../../services/drink_service.dart';

class DrinkManager with ChangeNotifier {
  final DrinkService _drinkService = DrinkService();
  
  List<Drink> _items = [];


  int get itemCount {
    return _items.length;
  }

  List<Drink> get items {
    return [..._items];

  }

  List<Drink> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Drink? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> addDrink(Drink drink, String userId, String toolId) async {
    final newDrink = await _drinkService.addDrink(drink, userId, toolId);
    if(newDrink != null) {
      _items.add(newDrink);
      notifyListeners();
    }
  }

    Future<void> updateDrink(Drink drink, String userId, String toolId) async {
    final index = _items.indexWhere((item) => item.id == drink.id);
    if (index >= 0) {
      final updatedDrink = await _drinkService.updateDrink(drink, userId, toolId);
      if (updatedDrink != null) {
        _items[index] = updatedDrink;
      }
      notifyListeners();
    }
  }

  Future<void> deleteDrink(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0 && !await _drinkService.deleteDrink(id)) {
      _items.removeAt(index);
      notifyListeners();
    }
  }


  Future<void> fetchDrink() async {
    _items = await _drinkService.fetchDrink();
    notifyListeners();
  }

  Future<void> fetchUserDrinks() async {
    _items = await _drinkService.fetchDrink(
      filteredByUser: true,
    );
    notifyListeners();
  }
}
import 'dart:convert';

import 'package:coffee_app/models/drink.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/drink_service.dart';

class DrinkManager with ChangeNotifier {
  final DrinkService _drinkService = DrinkService();
  
  DrinkManager() {
    loadDrink();
  }
  
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

  Future<void> addDrink(Drink drink, String toolId) async {
    final newDrink = await _drinkService.addDrink(drink, toolId);
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

  Future<bool> deleteDrink(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      bool isDeleted = await _drinkService.deleteDrink(id);
      if (isDeleted) {
        _items.removeAt(index);
        notifyListeners();
      }
      return isDeleted;
    }
    return false;
  }


  Future<void> fetchDrink() async {
    _items = await _drinkService.fetchDrink();
    notifyListeners();
  }

  Future<void> fetchUserDrinks() async {
    _items = await _drinkService.fetchDrink(
      filteredByUser: true,
    );
    await saveDrinkToLocalStorage(); 
    notifyListeners();
  }

  Future<void> saveDrinkToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final drinkJson = _items.map((drink) => drink.toJson()).toList();
    await prefs.setString('drink', jsonEncode(drinkJson));
  }

  Future<void> loadDrink() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final drinkData = prefs.getString('drink');

      if (drinkData != null) {
        final List<dynamic> decoded = jsonDecode(drinkData);
        _items = decoded.map((data) => Drink.fromJson(data)).toList();
        notifyListeners();
      }

      await fetchUserDrinks();
    } catch (error) {
      print('Error loading drink: $error');
    }
  }
}
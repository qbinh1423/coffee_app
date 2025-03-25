import 'dart:convert';

import 'package:coffee_app/models/store.dart';
import 'package:coffee_app/services/store_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreManager with ChangeNotifier {
  final StoreService _storeService = StoreService();
  List<Store> _items = [];

  StoreManager() {
    loadStores();
  }

  int get itemCount {
    return _items.length;
  }

  List<Store> get items {
    return [..._items];
  }

  List<Store> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Store? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> addStore(Store store) async {
    final newStore = await _storeService.addStore(store);
    if (newStore != null) {
      _items.add(newStore);
      notifyListeners();
    }
  }

  Future<void> updateStore(Store store) async {
    final index = _items.indexWhere((item) => item.id == store.id);
    if (index >= 0) {
      final updatedStore = await _storeService.updateStore(store);
      if (updatedStore != null) {
        _items[index] = updatedStore;
        notifyListeners();
      }
    }
  }

  Future<void> fetchStores() async {
    final fetchedStores = await _storeService.fetchStore();
    _items = fetchedStores;

    notifyListeners();
  }

  Future<void> fetchUserStore() async {
    final fetchedStores = await _storeService.fetchStore(filteredByUser: true);
    _items = fetchedStores;
    await saveStoresToLocalStorage();
    notifyListeners();
  }

  Future<void> saveStoresToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storesJson = _items.map((store) => store.toJson()).toList();
    await prefs.setString('stores', jsonEncode(storesJson));
  }

  Future<void> loadStores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storesData = prefs.getString('stores');

      if (storesData != null) {
        final List<dynamic> decoded = jsonDecode(storesData);
        _items = decoded.map((data) => Store.fromJson(data)).toList();
        notifyListeners();
      }

      await fetchUserStore();
    } catch (error) {
      print('Error loading store: $error');
    }
  }

  Future<bool> deleteStore(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      bool isDeleted = await _storeService.deleteStore(id);
      if (isDeleted) {
        _items.removeAt(index);
        notifyListeners();
      }
      return isDeleted;
    }
    return false;
  }
}

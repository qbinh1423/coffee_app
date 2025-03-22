import 'package:flutter/foundation.dart';
import '../../../../services/bean_service.dart';
import '../../../../models/bean.dart';

class BeansManager with ChangeNotifier {
  final BeansService _beansService = BeansService();
  
  List<Bean> _items = [];


  int get itemCount {
    return _items.length;
  }

  List<Bean> get items {
    return [..._items];

  }

  List<Bean> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Bean? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> addBean(Bean bean) async {
    final newBean = await _beansService.addBean(bean);
    if(newBean != null) {
      _items.add(newBean);
      notifyListeners();
    }
  }

  Future<void> updateBean(Bean bean) async {
    final index = _items.indexWhere((item) => item.id == bean.id);
    if(index >= 0 ) {
      final updatedBean = await _beansService.updateBean(bean);
      if(updatedBean != null) {
        _items[index] = updatedBean;
      }
      notifyListeners();
    }
  }

  Future<void> deleteBean(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if(index >= 0 && !await _beansService.deleteBean(id)) {
      _items.removeAt(index);
      notifyListeners();

    }
  }

  Future<void> fetchBeans() async {
    _items = await _beansService.fetchBeans();
    notifyListeners();
  }

  Future<void> fetchUserBeans() async {
    _items = await _beansService.fetchBeans(
      filteredByUser: true,
    );
    notifyListeners();
  }
}
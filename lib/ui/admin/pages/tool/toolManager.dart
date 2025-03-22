import 'package:coffee_app/models/tool.dart';
import 'package:coffee_app/services/toolService.dart';
import 'package:flutter/foundation.dart';

class ToolManager with ChangeNotifier {
  final ToolService _toolService = ToolService();
  List<Tool> _items = [];

  int get itemCount {
    return _items.length;
  }

  List<Tool> get items {
    return [..._items];
  }

  List<Tool> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Tool? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> addTool(Tool tool) async {
    final newTool = await _toolService.addTool(tool);
    if (newTool != null) {
      _items.add(newTool);
      notifyListeners();
    }
  }

  Future<void> updateTool(Tool tool) async {
    final index = _items.indexWhere((item) => item.id == tool.id);
    if (index >= 0) {
      final updatedTool = await _toolService.updateTool(tool);
      if (updatedTool != null) {
        _items[index] = updatedTool;
        notifyListeners();
      }
    }
  }

  Future<void> fetchTools() async {
    final fetchedTools = await _toolService.fetchTools();
    _items = fetchedTools;
    notifyListeners();
  }

  Future<void> fetchUserTool() async {
    final fetchedTools = await _toolService.fetchTools(filteredByUser: true);
    _items = fetchedTools;
    notifyListeners();
  }

  Future<void> deleteTool(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0 && await _toolService.deleteTool(id)) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}

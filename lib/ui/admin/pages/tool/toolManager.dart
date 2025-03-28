import 'dart:convert';

import 'package:coffee_app/models/tool.dart';
import 'package:coffee_app/services/toolService.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> fetchTool() async {
    try {
      final fetchedTools = await _toolService.fetchTools();
      if (fetchedTools.isNotEmpty) {
        _items = fetchedTools;
        notifyListeners();
      } else {
        print('No tools found');
      }
    } catch (e) {
      print('Error in fetchTools: $e');
    }
  }

  ToolManager() {
    loadTools();
  }

  Future<void> fetchUserTool() async {
    final fetchedTools = await _toolService.fetchTools();
    _items = fetchedTools;
    notifyListeners();
  }

  Future<void> saveToolToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final toolsJson = _items.map((tool) => tool.toJson()).toList();
    await prefs.setString('tools', jsonEncode(toolsJson));
  }

  Future<void> loadTools() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final toolsData = prefs.getString('tools');

      if (toolsData != null) {
        final List<dynamic> decoded = jsonDecode(toolsData);
        _items = decoded.map((data) => Tool.fromJson(data)).toList();
        notifyListeners();
      }

      await fetchUserTool();
    } catch (error) {
      print('Error loading tools: $error');
    }
  }

  Future<bool> deleteTool(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      bool isDeleted = await _toolService.deleteTool(id);
      if (isDeleted) {
        _items.removeAt(index);
        notifyListeners();
      }
      return isDeleted;
    }
    return false;
  }
}

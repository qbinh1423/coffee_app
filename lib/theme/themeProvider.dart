import 'package:coffee_app/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeButton.lightMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == ThemeButton.lightMode) {
      themeData = ThemeButton.darkMode;
    } else {
      themeData = ThemeButton.lightMode;
    }
  }
}

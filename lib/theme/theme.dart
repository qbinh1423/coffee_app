import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key, required this.changeThemeMode});

  final Function(bool) changeThemeMode;

  @override
  Widget build(BuildContext context) {
    bool isBright = Theme.of(context).brightness == Brightness.light;
    return IconButton(
      icon: Icon(
        isBright ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
      ),
      onPressed: () {
        changeThemeMode(!isBright);
      },
    );
  }

  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFBD906F),
      onPrimary: Colors.black,
      error: Colors.red.shade300,
      onError: Colors.black,
      surface: const Color(0xFFF3E9DC),
      onSurface: Colors.black,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF545550),
      onPrimary: Colors.white,
      error: Colors.red.shade300,
      onError: Colors.white,
      surface: const Color(0xFF000000),
      onSurface: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}

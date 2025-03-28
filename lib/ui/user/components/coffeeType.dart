import 'package:flutter/material.dart';

class CoffeeType extends StatelessWidget {
  final String coffeeType;
  final bool isSelected;
  const CoffeeType(
      {super.key, required this.coffeeType, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Text(
            coffeeType,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFFA16438)
                  : Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}

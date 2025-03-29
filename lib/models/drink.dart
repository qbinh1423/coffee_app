import 'dart:io';

class Drink {
  final String? id;
  final String name;
  final String origin;
  final List<String> toolId;
  final String ingredients;
  final String caffeine;
  final String description;
  final File? drinkImage;
  final String imageUrl;

  Drink({
    this.id,
    required this.name,
    required this.origin,
    required this.toolId,
    required this.ingredients,
    required this.caffeine,
    required this.description,
    this.drinkImage,
    this.imageUrl = '',
  });

  Drink copyWith({
    String? id,
    String? name,
    String? origin,
    List<String>? toolId,
    String? ingredients,
    String? caffeine,
    String? description,
    File? drinkImage,
    String? imageUrl,
  }) {
    return Drink(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      toolId: toolId ?? this.toolId,
      ingredients: ingredients ?? this.ingredients,
      caffeine: caffeine ?? this.caffeine,
      description: description ?? this.description,
      drinkImage: drinkImage ?? this.drinkImage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  bool hasDrinkImage() {
    return drinkImage != null || imageUrl.isNotEmpty;
  }

  Map<String, dynamic> toJson({String? userId}) {
    return {
      'name': name,
      'origin': origin,
      'toolId': toolId,
      'ingredients': ingredients,
      'caffeine': caffeine,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'],
      name: json['name'] ?? '',
      origin: json['origin'] ?? '',
      toolId: (json['toolID'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      ingredients: json['ingredients'] ?? '',
      caffeine: json['caffeine'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

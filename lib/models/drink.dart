import 'dart:io';

class Drink {
  final String? id;
  final String name;
  final String origin;
  final String? toolId;
  final List<dynamic> ingredients; 
  final String caffeine;
  final String description;
  final File? drinkImage;
  final String imageUrl;
  final bool isFavorite;
  final String? userId;

  Drink({
    this.id,
    required this.name,
    required this.origin,
    this.toolId,
    required this.ingredients,
    required this.caffeine,
    required this.description,
    this.drinkImage,
    this.imageUrl = '',
    this.isFavorite = false,
    this.userId,
  });

  Drink copyWith({
    String? id,
    String? name,
    String? origin,
    String? toolId,
    List<dynamic>? ingredients,
    String? caffeine,
    String? description,
    File? drinkImage,
    String? imageUrl,
    bool? isFavorite,
    String? userId,
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
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
    );
  }

  bool hasDrinkImage() {
    return drinkImage != null || imageUrl.isNotEmpty;
  }

  Map<String, dynamic> toJson({String? userId, String? toolId}) {
    return {
      'name': name,
      'origin': origin,
      'tool': toolId,
      'ingredients': ingredients,
      'caffeine': caffeine,
      'description': description,
      'isFavorite': isFavorite,
      'userId': userId,
      'imageUrl': imageUrl
    };
  }

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      toolId: json['tool'] as String?,
      ingredients: json['ingredients'] as List<dynamic>? ?? [],
      caffeine: json['caffeine'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      imageUrl: json['drinkImage'] as String? ?? '',
      userId: json['userId'] as String?,
    );
  }

    @override
  String toString() {
    return 'Drink(id: $id, name: $name, origin: $origin,  description: $description,  imageUrl: $imageUrl)';
  }
}

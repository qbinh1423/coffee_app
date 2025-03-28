import 'dart:io';

class Tool {
  final String? id;
  final String name;
  final String origin;
  final String type;
  final String material;
  final String description;
  final File? toolImage;
  final String imageUrl;
  final bool isFavorite;

  Tool({
    this.id,
    required this.name,
    required this.origin,
    required this.type,
    required this.material,
    required this.description,
    this.toolImage,
    this.imageUrl = '',
    this.isFavorite = false,
  });

  Tool copyWith({
    String? id,
    String? name,
    String? origin,
    String? type,
    String? material,
    String? description,
    File? toolImage,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Tool(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      type: type ?? this.type,
      material: material ?? this.material,
      description: description ?? this.description,
      toolImage: toolImage ?? this.toolImage,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  bool hasFeaturedImage() {
    return toolImage != null || imageUrl.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'origin': origin,
      'type': type,
      'material': material,
      'description': description,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json['id'],
      name: json['name'] ?? '',
      origin: json['origin'] ?? '',
      type: json['type'] ?? '',
      material: json['material'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

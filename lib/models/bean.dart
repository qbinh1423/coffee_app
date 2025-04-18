import 'dart:io';

class Bean {
  final String? id;
  final String name;
  final String altitude;
  final String climate; 
  final String caffeine;
  final String description;
  final String origin;
  final File? beanImage;
  final String imageUrl;

  Bean({
    this.id,
    required this.name,
    required this.altitude,
    required this.climate,
    required this.caffeine,
    required this.description,
    required this.origin,
    this.beanImage,
    this.imageUrl = '',
  });

  Bean copyWith({
    String? id,
    String? name,
    String? altitude,
    String? climate,
    String? caffeine,
    String? description,
    String? origin, 
    File? beanImage,
    String? imageUrl,
  }) {
    return Bean(
      id: id ?? this.id,
      name: name ?? this.name,
      altitude: altitude ?? this.altitude,
      climate: climate ?? this.climate,
      caffeine: caffeine ?? this.caffeine,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      beanImage: beanImage ?? this.beanImage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory Bean.fromJson(Map<String, dynamic> json) {
    return Bean(
      id: json['id'],
      name: json['name'] ?? '',
      altitude: json['altitude'] ?? '',
      climate: json['climate'] ?? '',
      caffeine: json['caffeine'] ?? '',
      description: json['description'] ?? '',
      origin: json['origin'] ?? '',
      imageUrl: json['imageUrl'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'altitude': altitude,
      'climate': climate,
      'caffeine': caffeine,
      'description': description,
      'origin': origin,
      'imageUrl': imageUrl,
    };
  }

  bool hasBeanImage() {
    return beanImage != null || imageUrl.isNotEmpty;
  }
}

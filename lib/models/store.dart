import 'dart:io';

class Store {
  final String? id;
  final String name;
  final String location;
  final String phone;
  final String startTime;
  final String endTime;
  final String description;
  final File? storeImage;
  final String imageUrl;

  Store({
    this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.startTime,
    required this.endTime,
    required this.description,
    this.storeImage,
    this.imageUrl = '',
  });

  Store copyWith({
    String? id,
    String? name,
    String? location,
    String? phone,
    String? startTime,
    String? endTime,
    String? description,
    File? storeImage,
    String? imageUrl,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      storeImage: storeImage ?? this.storeImage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'phone': phone,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
    };
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      phone: json['phone'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  bool hasStoreImage() {
    return storeImage != null || imageUrl.isNotEmpty;
  }
}

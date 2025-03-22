class User {
  final String id;
  final String email;
  final String? name;
  final String? avatar;

  User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

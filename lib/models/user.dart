class User {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final String? phone;
  final String? role;

  User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    this.phone,
    this.role,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
    );
  }
}

class Favorite {
  final String? id;
  final String? beanId;
  final String? drinkId;
  final String? storeId;
  final String? toolId;

  Favorite({
    this.id,
    this.beanId,
    this.drinkId,
    this.storeId,
    this.toolId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String?,
      beanId: json['beanId'] as String?,
      drinkId: json['drinkId'] as String?,
      storeId: json['storeId'] as String?,
      toolId: json['toolId'] as String?,
    );
  }

  Map<String, dynamic> toJson(String? userId) {
    return {
      'id': id,
      'userId': userId,
      'beanId': beanId,
      'drinkId': drinkId,
      'storeId': storeId,
      'toolId': toolId,
    };
  }
}

class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String type; // income / expense

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'type': type,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'expense',
    );
  }
}

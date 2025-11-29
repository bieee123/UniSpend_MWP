import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String userId;
  final String name;
  final double limit;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final DateTime createdAt;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.limit,
    this.spent = 0.0,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.createdAt,
  });

  // Convert BudgetModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'limit': limit,
      'spent': spent,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create BudgetModel from Firestore document
  factory BudgetModel.fromMap(Map<String, dynamic> map, String id) {
    return BudgetModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      limit: (map['limit'] ?? 0).toDouble(),
      spent: (map['spent'] ?? 0).toDouble(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      category: map['category'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Create BudgetModel from Firestore document snapshot
  factory BudgetModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BudgetModel.fromMap(data, snapshot.id);
  }

  @override
  String toString() {
    return 'BudgetModel(id: $id, userId: $userId, name: $name, limit: $limit, spent: $spent, startDate: $startDate, endDate: $endDate, category: $category, createdAt: $createdAt)';
  }
}
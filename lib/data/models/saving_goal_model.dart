import 'package:cloud_firestore/cloud_firestore.dart';

class SavingGoal {
  final String id;
  final String userId;
  final String name;
  final double targetAmount;
  final double unitAmount;
  final int totalUnits;
  final int completedUnits;
  final List<bool> checkboxStates;
  final DateTime createdAt;
  final DateTime? completedAt;

  SavingGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.unitAmount,
    required this.totalUnits,
    required this.completedUnits,
    required this.checkboxStates,
    required this.createdAt,
    this.completedAt,
  });

  double get savedAmount => completedUnits * unitAmount;
  double get remainingAmount => targetAmount - savedAmount;
  double get progressPercentage => targetAmount > 0 ? (savedAmount / targetAmount) * 100 : 0;
  bool get isCompleted => completedUnits == totalUnits;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'targetAmount': targetAmount,
      'unitAmount': unitAmount,
      'totalUnits': totalUnits,
      'completedUnits': completedUnits,
      'checkboxStates': checkboxStates,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  factory SavingGoal.fromMap(Map<String, dynamic> map, String id) {
    return SavingGoal(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      unitAmount: (map['unitAmount'] ?? 0).toDouble(),
      totalUnits: map['totalUnits']?.toInt() ?? 0,
      completedUnits: map['completedUnits']?.toInt() ?? 0,
      checkboxStates: List<bool>.from(map['checkboxStates'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
    );
  }

  SavingGoal copyWith({
    String? id,
    String? userId,
    String? name,
    double? targetAmount,
    double? unitAmount,
    int? totalUnits,
    int? completedUnits,
    List<bool>? checkboxStates,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      unitAmount: unitAmount ?? this.unitAmount,
      totalUnits: totalUnits ?? this.totalUnits,
      completedUnits: completedUnits ?? this.completedUnits,
      checkboxStates: checkboxStates ?? this.checkboxStates,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
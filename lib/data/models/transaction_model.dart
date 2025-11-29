import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String type; // "income" or "expense"
  final String note;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data, String id) {
    // Debug logging to see actual field names
    print("Parsing transaction data: $data");

    // Handle potential inconsistencies in field naming
    return TransactionModel(
      id: id,
      userId: data['user_id'] as String? ??
              data['userId'] as String? ??
              data['user_Id'] as String? ??
              data['user_ID'] as String? ?? '',
      categoryId: data['category_id'] as String? ??
                  data['categoryId'] as String? ??
                  data['category_Id'] as String? ??
                  data['categoryID'] as String? ?? '',
      amount: (data['amount'] as num? ?? 0).toDouble(),
      type: data['type'] as String? ?? 'expense',
      note: data['note'] as String? ?? '',
      date: ((data['date'] as Timestamp?)?.toDate()) ??
            (data['date'] as DateTime?) ??
            DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'note': note,
      'date': Timestamp.fromDate(date),
    };
  }
}

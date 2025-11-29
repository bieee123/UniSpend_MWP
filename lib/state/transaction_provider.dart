import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/firestore_service.dart';
import '../data/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final _firestore = FirestoreService();

  TransactionProvider();

  Future<void> addTransaction({
    required double amount,
    required String note,
    required String categoryId,
    required String type,
    required DateTime date,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser.uid,
      categoryId: categoryId,
      amount: amount,
      type: type,
      note: note,
      date: date,
    );

    try {
      print("Adding transaction with userId: ${transaction.userId}");
      print("Transaction data to be saved: ${transaction.toMap()}");
      await _firestore.addTransaction(transaction);
      print("Transaction added successfully");
      // Note: We DON'T call notifyListeners() here since Firestore streams
      // handle real-time updates automatically
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  Stream<List<TransactionModel>> streamTransactions() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No current user found");
      return Stream.value([]);
    }

    print("Querying transactions for user: ${currentUser.uid}");
    // Return the Firestore stream directly for real-time updates
    return _firestore.streamTransactions(currentUser.uid);
  }

  Future<void> updateTransaction({
    required String id,
    required double amount,
    required String note,
    required String categoryId,
    required String type,
    required DateTime date,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final transaction = TransactionModel(
      id: id,
      userId: currentUser.uid,
      categoryId: categoryId,
      amount: amount,
      type: type,
      note: note,
      date: date,
    );

    await _firestore.updateTransaction(id, transaction);
    // Note: We DON'T call notifyListeners() here since Firestore streams
    // handle real-time updates automatically
  }

  Future<void> deleteTransaction(String id) async {
    await _firestore.deleteTransaction(id);
    // Note: We DON'T call notifyListeners() here since Firestore streams
    // handle real-time updates automatically
  }

  Future<TransactionModel?> getTransaction(String id) async {
    return await _firestore.getTransaction(id);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Transaction Operations
  // Add transaction
  Future<void> addTransaction(TransactionModel transaction) {
    return _db
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toMap());
  }

  // Get all transactions for a user - supporting both possible field names
  Stream<List<TransactionModel>> streamTransactions(String userId) {
    print("Stream query for user_id: $userId");
    return _db
        .collection('transactions')
        .where('user_id', isEqualTo: userId)  // try the new standard format
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) {
          print("Received ${snap.docs.length} documents from Firestore");
          final transactions = <TransactionModel>[];
          for (final doc in snap.docs) {
            try {
              print("Processing document ${doc.id} with data: ${doc.data()}");
              final transaction = TransactionModel.fromMap(doc.data(), doc.id);
              transactions.add(transaction);
            } catch (e) {
              print('Error parsing transaction: $e');
              // Skip invalid transactions
              continue;
            }
          }
          print("Successfully parsed ${transactions.length} transactions");
          return transactions;
        });
  }

  // Update transaction
  Future<void> updateTransaction(String id, TransactionModel transaction) {
    return _db.collection('transactions').doc(id).update(transaction.toMap());
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) {
    return _db.collection('transactions').doc(id).delete();
  }

  // Get single transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    final doc = await _db.collection('transactions').doc(id).get();
    if (doc.exists) {
      return TransactionModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Category Operations
  // Add category
  Future<void> addCategory(CategoryModel category) {
    return _db.collection('categories').add(category.toMap());
  }

  // Get all categories for a user
  Stream<List<CategoryModel>> streamCategories(String userId) {
    return _db
        .collection('categories')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => CategoryModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  // Update category
  Future<void> updateCategory(String id, CategoryModel category) {
    return _db.collection('categories').doc(id).update(category.toMap());
  }

  // Delete category
  Future<void> deleteCategory(String id) {
    return _db.collection('categories').doc(id).delete();
  }

  // Get single category by ID
  Future<CategoryModel?> getCategory(String id) async {
    final doc = await _db.collection('categories').doc(id).get();
    if (doc.exists) {
      return CategoryModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}

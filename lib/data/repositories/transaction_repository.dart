import '../models/transaction_model.dart';
import '../services/firestore_service.dart';

class TransactionRepository {
  final FirestoreService firestore;

  TransactionRepository(this.firestore);

  Stream<List<TransactionModel>> getUserTransactions(String userId) {
    return firestore.streamTransactions(userId);
  }

  Future<void> add(TransactionModel transaction) => firestore.addTransaction(transaction);

  Future<void> update(String id, TransactionModel transaction) => firestore.updateTransaction(id, transaction);

  Future<void> delete(String id) => firestore.deleteTransaction(id);

  Future<TransactionModel?> getTransaction(String id) => firestore.getTransaction(id);
}

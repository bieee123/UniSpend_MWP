import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

class BudgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter to access _firestore from other classes
  FirebaseFirestore get firestore => _firestore;

  // Add a new budget
  Future<void> addBudget(BudgetModel budget) async {
    await _firestore
        .collection('budgets')
        .doc(budget.id)
        .set(budget.toMap());
  }

  // Update an existing budget
  Future<void> updateBudget(BudgetModel budget) async {
    await _firestore
        .collection('budgets')
        .doc(budget.id)
        .update(budget.toMap());
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    await _firestore.collection('budgets').doc(budgetId).delete();
  }

  // Get a single budget by ID
  Future<BudgetModel?> getBudget(String budgetId) async {
    final doc = await _firestore.collection('budgets').doc(budgetId).get();
    if (doc.exists) {
      return BudgetModel.fromSnapshot(doc);
    }
    return null;
  }

  // Stream a single budget by ID
  Stream<BudgetModel?> streamBudget(String budgetId) {
    return _firestore
        .collection('budgets')
        .doc(budgetId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return BudgetModel.fromSnapshot(snapshot);
      }
      return null;
    });
  }

  // Stream all budgets for a specific user
  Stream<List<BudgetModel>> streamBudgets(String userId) {
    return _firestore
        .collection('budgets')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BudgetModel.fromSnapshot(doc)).toList();
    });
  }

  // Get all budgets for a specific user
  Future<List<BudgetModel>> getBudgets(String userId) async {
    final querySnapshot = await _firestore
        .collection('budgets')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => BudgetModel.fromSnapshot(doc))
        .toList();
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repository.dart';
import '../data/models/transaction_model.dart';
import '../data/services/notification_service.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();
  final NotificationService _notificationService = NotificationService();

  List<BudgetModel> _budgets = [];
  double _globalBudgetLimit = 0.0;
  double _currentSpending = 0.0;
  String? _currentUserId;

  List<BudgetModel> get budgets => _budgets;
  double get globalBudgetLimit => _globalBudgetLimit;
  double get currentSpending => _currentSpending;
  double get remainingBudget => _globalBudgetLimit - _currentSpending;
  double get budgetPercentage => _globalBudgetLimit > 0 ? (_currentSpending / _globalBudgetLimit) * 100 : 0;

  BudgetProvider() {
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Listen to authentication state changes to handle account switching
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUserId = user?.uid;
      // Reset budgets when user changes
      _budgets = [];
      notifyListeners();

      if (_currentUserId != null) {
        _loadGlobalBudgetLimit();
        _loadCurrentSpending();
        _subscribeToBudgets();
        _subscribeToTransactions(); // Add transaction subscription to track expenses
      }
    });

    if (_currentUserId != null) {
      _loadGlobalBudgetLimit();
      _loadCurrentSpending();
      _subscribeToBudgets();
      _subscribeToTransactions(); // Add transaction subscription to track expenses
    }
  }

  // Subscribe to budgets stream to get real-time updates
  void _subscribeToBudgets() {
    if (_currentUserId != null) {
      _repository.streamBudgets(_currentUserId!).listen((budgets) {
        _budgets = budgets;
        notifyListeners();
      }).onError((error) {
        print('Error loading budgets: $error');
      });
    }
  }

  // Subscribe to transactions stream to update budget spending in real-time
  void _subscribeToTransactions() {
    if (_currentUserId != null) {
      _repository.firestore
          .collection('transactions')
          .where('user_id', isEqualTo: _currentUserId)
          .where('type', isEqualTo: 'expense')
          .snapshots()
          .listen((snapshot) {
        _updateBudgetSpentAmounts();
      }).onError((error) {
        print('Error listening to transactions: $error');
      });
    }
  }

  Future<void> _loadGlobalBudgetLimit() async {
    if (_currentUserId == null) return;

    final doc = await _repository.firestore
        .collection('app_settings')
        .doc(_currentUserId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      _globalBudgetLimit = (data?['budget_limit'] ?? 0).toDouble();
    }
    notifyListeners();
  }

  Future<void> _loadCurrentSpending() async {
    if (_currentUserId == null) return;

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    final querySnapshot = await _repository.firestore
        .collection('transactions')
        .where('user_id', isEqualTo: _currentUserId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
        .where('type', isEqualTo: 'expense')
        .get();

    _currentSpending = 0.0;
    for (final doc in querySnapshot.docs) {
      final transaction = TransactionModel.fromMap(doc.data(), doc.id);
      _currentSpending += transaction.amount;
    }

    // Check budget thresholds and send notifications if needed
    _checkBudgetThresholds();

    notifyListeners();
  }

  // Update the spent amount for all budgets based on transactions
  Future<void> _updateBudgetSpentAmounts() async {
    if (_currentUserId == null) return;

    // Get all expenses for the current user
    final querySnapshot = await _repository.firestore
        .collection('transactions')
        .where('user_id', isEqualTo: _currentUserId)
        .where('type', isEqualTo: 'expense')
        .get();

    final List<TransactionModel> transactions = [];
    for (final doc in querySnapshot.docs) {
      final transaction = TransactionModel.fromMap(doc.data(), doc.id);
      transactions.add(transaction);
    }

    // Update each budget's spent amount
    for (final budget in _budgets) {
      double budgetSpent = 0.0;

      // Calculate total spent for this specific budget category in its date range
      for (final transaction in transactions) {
        // Check if transaction category matches budget category and is within budget date range
        if (transaction.categoryId.toLowerCase() == budget.category.toLowerCase() &&
            transaction.date.isAfter(budget.startDate.subtract(const Duration(days: 1))) &&
            transaction.date.isBefore(budget.endDate.add(const Duration(days: 1)))) {
          budgetSpent += transaction.amount;
        }
      }

      // Update the budget's spent amount in Firestore
      if (budget.spent != budgetSpent) {
        final updatedBudget = BudgetModel(
          id: budget.id,
          userId: budget.userId,
          name: budget.name,
          limit: budget.limit,
          spent: budgetSpent,
          startDate: budget.startDate,
          endDate: budget.endDate,
          category: budget.category,
          createdAt: budget.createdAt,
        );

        try {
          await _repository.updateBudget(updatedBudget);
        } catch (e) {
          print('Error updating budget spent amount: $e');
        }
      }
    }
  }

  Future<void> setGlobalBudgetLimit(double limit) async {
    _globalBudgetLimit = limit;

    if (_currentUserId != null) {
      await _repository.firestore
          .collection('app_settings')
          .doc(_currentUserId)
          .set({'budget_limit': limit}, SetOptions(merge: true));
    }

    notifyListeners();
  }

  // Add a new budget
  Future<void> addBudget(BudgetModel budget) async {
    try {
      await _repository.addBudget(budget);
      // The budget will be added automatically via the stream listener
      // notifyListeners() is called in the stream listener
    } catch (e) {
      print('Error adding budget: $e');
      rethrow;
    }
  }

  // Update an existing budget
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _repository.updateBudget(budget);
      // The budget will be updated automatically via the stream listener
      // notifyListeners() is called in the stream listener
    } catch (e) {
      print('Error updating budget: $e');
      rethrow;
    }
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _repository.deleteBudget(budgetId);
      // The budget will be removed automatically via the stream listener
      // notifyListeners() is called in the stream listener
    } catch (e) {
      print('Error deleting budget: $e');
      rethrow;
    }
  }

  void _checkBudgetThresholds() async {
    if (_globalBudgetLimit <= 0) return;

    final percentage = budgetPercentage;

    // Send notification when reaching 75% of budget
    if (percentage >= 75 && percentage < 90) {
      await _notificationService.sendBudgetLimitNotification(
        "You've used ${percentage.toStringAsFixed(0)}% of your monthly budget!",
      );
    }
    // Send notification when reaching 90% of budget
    else if (percentage >= 90 && percentage < 100) {
      await _notificationService.sendBudgetLimitNotification(
        "You've used ${percentage.toStringAsFixed(0)}% of your monthly budget. Consider reducing expenses!",
      );
    }
    // Send notification when exceeding budget
    else if (percentage >= 100) {
      await _notificationService.sendBudgetLimitNotification(
        "You've exceeded your monthly budget by ${((percentage - 100) * _globalBudgetLimit / 100).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}!",
      );
    }
  }

  // Call this method when a new transaction is added to update spending
  Future<void> updateSpending() async {
    await _loadCurrentSpending();
    _updateBudgetSpentAmounts(); // Also update individual budget spent amounts
    notifyListeners();
  }
}
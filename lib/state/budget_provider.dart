import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/transaction_model.dart';
import '../data/services/notification_service.dart';

class BudgetProvider extends ChangeNotifier {
  double _budgetLimit = 0.0;
  double _currentSpending = 0.0;
  String? _currentUserId;
  final NotificationService _notificationService = NotificationService();

  double get budgetLimit => _budgetLimit;
  double get currentSpending => _currentSpending;
  double get remainingBudget => _budgetLimit - _currentSpending;
  double get budgetPercentage => _budgetLimit > 0 ? (_currentSpending / _budgetLimit) * 100 : 0;

  BudgetProvider() {
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_currentUserId != null) {
      _loadBudgetLimit();
      _loadCurrentSpending();
    }
  }

  Future<void> _loadBudgetLimit() async {
    if (_currentUserId == null) return;
    
    final doc = await FirebaseFirestore.instance
        .collection('app_settings')
        .doc(_currentUserId)
        .get();
    
    if (doc.exists) {
      final data = doc.data();
      _budgetLimit = (data?['budget_limit'] ?? 0).toDouble();
    }
    notifyListeners();
  }

  Future<void> _loadCurrentSpending() async {
    if (_currentUserId == null) return;
    
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    final querySnapshot = await FirebaseFirestore.instance
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

  Future<void> setBudgetLimit(double limit) async {
    _budgetLimit = limit;
    
    if (_currentUserId != null) {
      await FirebaseFirestore.instance
          .collection('app_settings')
          .doc(_currentUserId)
          .set({'budget_limit': limit}, SetOptions(merge: true));
    }
    
    notifyListeners();
  }

  void _checkBudgetThresholds() async {
    if (_budgetLimit <= 0) return;
    
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
        "You've exceeded your monthly budget by ${((percentage - 100) * _budgetLimit / 100).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}!",
      );
    }
  }

  // Call this method when a new transaction is added to update spending
  Future<void> updateSpending() async {
    await _loadCurrentSpending();
  }
}
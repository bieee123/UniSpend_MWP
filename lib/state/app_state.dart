import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/models/transaction_model.dart';

class AppState extends ChangeNotifier {
  UserModel? currentUser;
  List<TransactionModel> transactions = [];

  void setUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }

  void setTransactions(List<TransactionModel> items) {
    transactions = items;
    notifyListeners();
  }
}

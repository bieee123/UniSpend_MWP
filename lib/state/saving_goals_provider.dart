import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/saving_goal_model.dart';
import '../data/repositories/saving_goals_repository.dart';

class SavingGoalsProvider extends ChangeNotifier {
  final SavingGoalsRepository _repository = SavingGoalsRepository();
  String? _currentUserId;

  List<SavingGoal> _goals = [];
  List<SavingGoal> get goals => _goals;

  SavingGoalsProvider() {
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUserId = user?.uid;
      if (_currentUserId != null) {
        _subscribeToGoals();
      } else {
        _goals = [];
        notifyListeners();
      }
    });

    if (_currentUserId != null) {
      _subscribeToGoals();
    }
  }

  void _subscribeToGoals() {
    _repository.streamGoals().listen((goals) {
      _goals = goals;
      notifyListeners();
    }).onError((error) {
      print('Error loading saving goals: $error');
    });
  }

  // Add a manual refresh method to ensure data is loaded
  void refreshGoals() {
    if (_currentUserId != null) {
      _subscribeToGoals();
    }
  }

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    required double unitAmount,
  }) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final totalUnits = (targetAmount / unitAmount).ceil();
    final checkboxStates = List<bool>.generate(totalUnits, (index) => false);

    // Generate a unique ID for the document
    final goalId = DateTime.now().millisecondsSinceEpoch.toString();

    final goal = SavingGoal(
      id: goalId,
      userId: userId,
      name: name,
      targetAmount: targetAmount,
      unitAmount: unitAmount,
      totalUnits: totalUnits,
      completedUnits: 0,
      checkboxStates: checkboxStates,
      createdAt: DateTime.now(),
    );

    await _repository.addGoalWithId(goal, goalId);
  }


  Future<void> updateGoalCheckboxes(String goalId, int index, bool isChecked) async {
    final goal = _goals.firstWhere((g) => g.id == goalId, orElse: () => _goals.first);
    if (goal.id != goalId) return;

    final newCheckboxStates = List<bool>.from(goal.checkboxStates);
    newCheckboxStates[index] = isChecked;

    final newCompletedUnits = newCheckboxStates.where((state) => state).length;

    final updatedGoal = goal.copyWith(
      checkboxStates: newCheckboxStates,
      completedUnits: newCompletedUnits,
    );

    await _repository.updateGoalCheckboxes(goalId, newCheckboxStates, newCompletedUnits);
  }

  Future<void> resetGoalCheckboxes(String goalId) async {
    final goal = _goals.firstWhere((g) => g.id == goalId, orElse: () => _goals.first);
    if (goal.id != goalId) return;

    final resetStates = List<bool>.generate(goal.totalUnits, (index) => false);

    final updatedGoal = goal.copyWith(
      checkboxStates: resetStates,
      completedUnits: 0,
    );

    await _repository.updateGoal(updatedGoal);
  }

  Future<void> updateGoal(SavingGoal goal) async {
    await _repository.updateGoal(goal);
  }

  Future<void> deleteGoal(String goalId) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception('User must be authenticated to delete saving goals');
    }

    await _repository.deleteGoal(goalId);
  }

  SavingGoal? getGoalById(String goalId) {
    try {
      return _goals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      return null;
    }
  }
}
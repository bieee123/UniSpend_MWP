import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/saving_goal_model.dart';

class SavingGoalsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get _collection => 
      firestore.collection('saving_goals');

  Stream<List<SavingGoal>> streamGoals() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SavingGoal.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addGoalWithId(SavingGoal goal, String goalId) async {
    await _collection.doc(goalId).set(goal.toMap());
  }

  Future<void> addGoal(SavingGoal goal) async {
    await _collection.add(goal.toMap());
  }

  Future<void> updateGoal(SavingGoal goal) async {
    await _collection.doc(goal.id).update(goal.toMap());
  }

  Future<void> deleteGoal(String goalId) async {
    await _collection.doc(goalId).delete();
  }

  Future<void> updateGoalCheckboxes(String goalId, List<bool> checkboxStates, int completedUnits) async {
    await _collection.doc(goalId).update({
      'checkboxStates': checkboxStates,
      'completedUnits': completedUnits,
    });
  }

  Future<void> resetGoalCheckboxes(String goalId) async {
    await _collection.doc(goalId).update({
      'completedUnits': 0,
    });
  }
}
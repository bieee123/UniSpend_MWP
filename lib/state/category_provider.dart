import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/category_model.dart';
import '../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  CategoryProvider() {
    // Initialize default categories when provider is created
    _initializeDefaultCategories();
  }

  Future<void> _initializeDefaultCategories() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Wait a bit to ensure auth is fully loaded, then check for default categories
      await Future.delayed(const Duration(milliseconds: 100));
      await createDefaultCategoriesIfEmpty();
    }
  }

  Stream<List<CategoryModel>> streamCategories() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _repository.getUserCategories(currentUser.uid);
  }

  Future<void> addCategory(String name, String type) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final category = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser.uid,
      name: name,
      type: type,
    );

    await _repository.add(category);
    notifyListeners();
  }

  Future<void> updateCategory(String id, String name, String type) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final category = CategoryModel(
      id: id,
      userId: currentUser.uid,
      name: name,
      type: type,
    );

    await _repository.update(id, category);
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.delete(id);
    notifyListeners();
  }

  Future<CategoryModel?> getCategory(String id) async {
    return await _repository.getCategory(id);
  }

  Future<bool> createDefaultCategoriesIfEmpty() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    // Get current categories snapshot
    final categories = await streamCategories().first;

    // If no categories exist, create default ones
    if (categories.isEmpty) {
      final defaultCategories = [
        {"name": "Food", "type": "expense"},
        {"name": "Transport", "type": "expense"},
        {"name": "Shopping", "type": "expense"},
        {"name": "Entertainment", "type": "expense"},
        {"name": "Salary", "type": "income"},
        {"name": "Gift", "type": "income"},
      ];

      for (final catData in defaultCategories) {
        await addCategory(catData["name"]!, catData["type"]!);
      }
      return true;
    }
    return false;
  }
}

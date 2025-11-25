import '../models/category_model.dart';
import '../services/firestore_service.dart';

class CategoryRepository {
  final FirestoreService _firestore = FirestoreService();

  Stream<List<CategoryModel>> getUserCategories(String userId) {
    return _firestore.streamCategories(userId);
  }

  Future<void> add(CategoryModel category) => _firestore.addCategory(category);

  Future<void> update(String id, CategoryModel category) => _firestore.updateCategory(id, category);

  Future<void> delete(String id) => _firestore.deleteCategory(id);

  Future<CategoryModel?> getCategory(String id) => _firestore.getCategory(id);
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/category_model.dart';
import '../../state/category_provider.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../core/widgets/skeleton_loader.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/categories/add');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Force a refresh of data
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: StreamBuilder<List<CategoryModel>>(
          stream: provider.streamCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonList(itemCount: 3, hasCard: true);
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return const Center(
                child: Text('No categories yet. Add your first category!'),
              );
            }

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return AnimatedListItem(
                  index: index,
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(category.name),
                      subtitle: Text(category.type),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Category"),
                              content: const Text("Are you sure you want to delete this category?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await provider.deleteCategory(category.id);
                          }
                        },
                      ),
                      onTap: () {
                        // Navigate to edit category page (to be implemented)
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
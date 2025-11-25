import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/category_provider.dart';

class EditCategoryPage extends StatefulWidget {
  final String categoryId;
  
  const EditCategoryPage({super.key, required this.categoryId});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final nameCtrl = TextEditingController();
  String type = "expense";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    final provider = context.read<CategoryProvider>();
    final category = await provider.getCategory(widget.categoryId);
    
    if (category != null) {
      nameCtrl.text = category.name;
      type = category.type;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final provider = context.read<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Category")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Category Name"),
            ),
            const SizedBox(height: 16),
            
            // Radio buttons for income/expense
            const Text("Category Type"),
            Row(
              children: [
                Radio<String>(
                  value: "income",
                  groupValue: type,
                  onChanged: (val) => setState(() => type = val!),
                ),
                const Text("Income"),
                Radio<String>(
                  value: "expense",
                  groupValue: type,
                  onChanged: (val) => setState(() => type = val!),
                ),
                const Text("Expense"),
              ],
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isNotEmpty) {
                  await provider.updateCategory(widget.categoryId, nameCtrl.text.trim(), type);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Update Category"),
            ),
          ],
        ),
      ),
    );
  }
}
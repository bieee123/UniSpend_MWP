import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/category_provider.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final nameCtrl = TextEditingController();
  String type = "expense";

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
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
                  await provider.addCategory(nameCtrl.text.trim(), type);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Save Category"),
            ),
          ],
        ),
      ),
    );
  }
}
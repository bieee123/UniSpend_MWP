import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../state/transaction_provider.dart';
import '../../state/budget_provider.dart';

class EditTransactionPage extends StatefulWidget {
  final String transactionId;

  const EditTransactionPage({super.key, required this.transactionId});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String type = "expense";
  DateTime date = DateTime.now();
  String selectedCategory = "General";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    final provider = context.read<TransactionProvider>();
    final transaction = await provider.getTransaction(widget.transactionId);

    if (transaction != null) {
      amountCtrl.text = transaction.amount.toString();
      noteCtrl.text = transaction.note;
      type = transaction.type;
      date = transaction.date;
      selectedCategory = transaction.categoryId;
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

    final provider = context.read<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: "Note"),
            ),
            const SizedBox(height: 12),

            /// Radio Button
            const Text("Type"),
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

            /// Category Dropdown
            DropdownButton<String>(
              value: selectedCategory,
              items: ["General", "Food & Drink", "Transport", "Shopping", "Others", "Salary", "Extra Income"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
            ),
            const SizedBox(height: 12),

            /// Date Picker
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: date,
                );
                if (picked != null) setState(() => date = picked);
              },
              child: Text("Select Date: ${date.toString().split(' ')[0]}"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await provider.updateTransaction(
                  id: widget.transactionId,
                  amount: double.tryParse(amountCtrl.text) ?? 0,
                  note: noteCtrl.text,
                  categoryId: selectedCategory,
                  type: type,
                  date: date,
                );

                // Update budget spending to reflect the updated transaction
                final budgetProvider = context.read<BudgetProvider>();
                await budgetProvider.updateSpending();

                // Add a small delay to ensure the UI updates properly
                await Future.delayed(const Duration(milliseconds: 300));
                if (context.mounted) {
                  context.go('/transactions'); // Navigate to transactions page to refresh data
                }
              },
              child: const Text("Update Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
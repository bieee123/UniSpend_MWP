import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/transaction_provider.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String type = "expense";
  DateTime date = DateTime.now();
  String selectedCategory = "General";

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount (Rp)",
                prefixText: "Rp ",
              ),
              onChanged: (value) {
                // Format the number as rupiah when user finishes typing
                if (value.isNotEmpty) {
                  try {
                    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (cleanValue.isNotEmpty) {
                      int number = int.parse(cleanValue);
                      String formatted = number.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},');
                      amountCtrl.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: formatted.length),
                        ),
                      );
                    }
                  } catch (e) {
                    // If parsing fails, keep the value as is
                  }
                }
              },
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

            const SizedBox(height: 12),

            /// Category Dropdown
            DropdownButton<String>(
              value: selectedCategory,
              items: ["General", "Food", "Transport", "Shopping"]
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
                // Parse the amount by removing non-numeric characters
                String cleanAmountText = amountCtrl.text.replaceAll(RegExp(r'[Rp\s,]'), '');
                final amount = double.tryParse(cleanAmountText) ?? 0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Amount must be greater than 0')),
                  );
                  return;
                }

                await provider.addTransaction(
                  amount: amount,
                  note: noteCtrl.text,
                  categoryId: selectedCategory,
                  type: type,
                  date: date,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

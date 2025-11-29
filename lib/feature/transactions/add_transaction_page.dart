import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/transaction_provider.dart';
import '../../state/budget_provider.dart';

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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                // Select Transaction Type
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transaction Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => type = "expense"),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: type == "expense" ? Colors.red.withOpacity(0.1) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: type == "expense" ? Colors.red : Colors.grey,
                                    width: type == "expense" ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.money_off,
                                      color: type == "expense" ? Colors.red : Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Expenses",
                                      style: TextStyle(
                                        color: type == "expense" ? Colors.red : Colors.grey,
                                        fontWeight: type == "expense" ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => type = "income"),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: type == "income" ? Colors.green.withOpacity(0.1) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: type == "income" ? Colors.green : Colors.grey,
                                    width: type == "income" ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      color: type == "income" ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                        color: type == "income" ? Colors.green : Colors.grey,
                                        fontWeight: type == "income" ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Select Category
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: type == "expense"
                            ? [
                                _buildCategoryChip("Food & Drink", Icons.local_cafe, "Food & Drink"),
                                _buildCategoryChip("Transport", Icons.directions_car, "Transport"),
                                _buildCategoryChip("Shopping", Icons.shopping_bag, "Shopping"),
                                _buildCategoryChip("Others", Icons.category, "Others"),
                              ]
                            : [
                                _buildCategoryChip("Salary", Icons.work, "Salary"),
                                _buildCategoryChip("Extra Income", Icons.attach_money, "Extra Income"),
                              ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Amount Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Amount (Rp)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          prefix: const Text(
                            "Rp ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Select Date
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Day",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          "${date.day} ${_getMonthName(date.month)} ${date.year}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: date,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.green, // header background color
                                    onPrimary: Colors.white, // header text color
                                    onSurface: Colors.green, // body text color
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) setState(() => date = picked);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Write a Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Write a Note",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: noteCtrl,
                        decoration: InputDecoration(
                          hintText: "Add a description...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Add an Amount Button at the bottom
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.all(20), // Add padding to match the content padding
          child: ElevatedButton(
            onPressed: () async {
              // Validate all required fields before creating transaction
              if (FirebaseAuth.instance.currentUser == null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to add a transaction'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }

              // Parse the amount by removing non-numeric characters
              String cleanAmountText = amountCtrl.text.replaceAll(RegExp(r'[Rp\s,]'), '');
              final amount = double.tryParse(cleanAmountText) ?? 0;

              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount greater than 0'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Additional validation: check if category is selected
              if (selectedCategory.isEmpty || selectedCategory == "General") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a category for the transaction'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                await provider.addTransaction(
                  amount: amount,
                  note: noteCtrl.text,
                  categoryId: selectedCategory,
                  type: type,
                  date: date,
                );

                if (context.mounted) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Update budget spending to reflect the new transaction
                  final budgetProvider = context.read<BudgetProvider>();
                  await budgetProvider.updateSpending();

                  // Navigate to the transaction list page instead of just popping
                  if (context.mounted) {
                    context.go('/transactions');
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding transaction: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Add an Amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, String category) {
    bool isSelected = selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedCategory = category;
          }
        });
      },
      selectedColor: Colors.green.withOpacity(0.2),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.green : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }
}
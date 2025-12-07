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
  String selectedCategory = "Food & Drink"; // Default to the first expense category
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
      // Remove formatting from amount for display
      String cleanAmount = transaction.amount.toString();
      if (cleanAmount.contains('.')) {
        cleanAmount = cleanAmount.endsWith('.0')
          ? cleanAmount.substring(0, cleanAmount.length - 2)
          : cleanAmount;
      }
      amountCtrl.text = cleanAmount;
      noteCtrl.text = transaction.note;
      selectedCategory = transaction.categoryId;
      type = transaction.type; // Use the actual transaction type
      date = transaction.date;
    }

    // Update the UI with the loading state and data
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TransactionProvider>();

    // Show loading indicator while data is loading
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A7F66)),
            ),
            SizedBox(height: 16),
            Text(
              "Loading transaction...",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0A7F66),
              ),
            ),
          ],
        ),
      );
    }

    // Update default category based on transaction type
    if (selectedCategory.isEmpty ||
        (type == "expense" && !["Food & Drink", "Transport", "Shopping", "Others"].contains(selectedCategory)) ||
        (type == "income" && !["Salary", "Extra Income"].contains(selectedCategory))) {
      selectedCategory = type == "expense" ? "Food & Drink" : "Salary";
    }

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
                    color: const Color(0xFF0A7F66).withOpacity(0.05), // Light Emerald Deep Green background
                    borderRadius: BorderRadius.circular(16), // More rounded corners
                    border: Border.all(
                      color: type == "expense"
                        ? Colors.red.withOpacity(0.3)
                        : const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transaction Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green text
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  type = "expense";
                                  selectedCategory = "Food & Drink"; // Reset to default expense category
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: type == "expense"
                                    ? const Color(0xFF0A7F66).withOpacity(0.1) // Light green background for active
                                    : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: type == "expense"
                                      ? const Color(0xFF0A7F66).withOpacity(0.5) // Emerald Deep Green border when active
                                      : Colors.grey.withOpacity(0.3),
                                    width: type == "expense" ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.money_off,
                                      color: type == "expense"
                                        ? const Color(0xFF0A7F66) // Emerald Deep Green when active
                                        : Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Expenses",
                                      style: TextStyle(
                                        color: type == "expense"
                                          ? const Color(0xFF0A7F66) // Emerald Deep Green when active
                                          : Colors.grey,
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
                              onTap: () {
                                setState(() {
                                  type = "income";
                                  selectedCategory = "Salary"; // Reset to default income category
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: type == "income"
                                    ? const Color(0xFF0A7F66).withOpacity(0.1) // Light green background for active
                                    : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: type == "income"
                                      ? const Color(0xFF0A7F66).withOpacity(0.5) // Emerald Deep Green border when active
                                      : Colors.grey.withOpacity(0.3),
                                    width: type == "income" ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      color: type == "income"
                                        ? const Color(0xFF0A7F66) // Emerald Deep Green when active
                                        : Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                        color: type == "income"
                                          ? const Color(0xFF0A7F66) // Emerald Deep Green when active
                                          : Colors.grey,
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
                // Select Category
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05), // Light Emerald Deep Green background
                    borderRadius: BorderRadius.circular(16), // More rounded corners
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green text
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12), // More rounded corners
                          border: Border.all(
                            color: const Color(0xFF0A7F66).withOpacity(0.5), // Emerald Deep Green border
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          underline: const SizedBox(), // Remove the default underline
                          items: type == "expense"
                              ? [
                                  _buildDropdownItem("Food & Drink", Icons.local_cafe, "Food & Drink"),
                                  _buildDropdownItem("Transport", Icons.directions_car, "Transport"),
                                  _buildDropdownItem("Shopping", Icons.shopping_bag, "Shopping"),
                                  _buildDropdownItem("Others", Icons.category, "Others"),
                                ]
                              : [
                                  _buildDropdownItem("Salary", Icons.work, "Salary"),
                                  _buildDropdownItem("Extra Income", Icons.attach_money, "Extra Income"),
                                ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Amount Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05), // Light Emerald Deep Green background
                    borderRadius: BorderRadius.circular(16), // More rounded corners
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount (Rp)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green text
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          prefix: Text(
                            "Rp ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0A7F66), // Emerald Deep Green
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
                            borderSide: BorderSide(color: const Color(0xFF0A7F66), width: 2), // Emerald Deep Green
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
                                setState(() {
                                  amountCtrl.value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: formatted.length),
                                    ),
                                  );
                                });
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
                    color: const Color(0xFF0A7F66).withOpacity(0.05), // Light Emerald Deep Green background
                    borderRadius: BorderRadius.circular(16), // More rounded corners
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Day",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green text
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green background
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: const Color(0xFF0A7F66), // Emerald Deep Green
                          ),
                        ),
                        title: Text(
                          "${date.day} ${_getMonthName(date.month)} ${date.year}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0A7F66), // Emerald Deep Green text
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: const Color(0xFF0A7F66)), // Emerald Deep Green
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: date,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: const Color(0xFF0A7F66), // header background color - Emerald Deep Green
                                    onPrimary: Colors.white, // header text color
                                    onSurface: const Color(0xFF0A7F66), // body text color - Emerald Deep Green
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
                    color: const Color(0xFF0A7F66).withOpacity(0.05), // Light Emerald Deep Green background
                    borderRadius: BorderRadius.circular(16), // More rounded corners
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Write a Note",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green text
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
                            borderSide: BorderSide(color: const Color(0xFF0A7F66), width: 2), // Emerald Deep Green
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
        // Update Transaction Button - Match the design from add transaction page
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A7F66), Color(0xFF076C72)], // Emerald Deep Green to Teal Forest gradient
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: ElevatedButton(
            onPressed: () async {
              // Parse the amount by removing non-numeric characters
              String cleanAmountText = amountCtrl.text.replaceAll(RegExp(r'[Rp\s,]'), '');
              final amount = double.tryParse(cleanAmountText) ?? 0;

              if (amount <= 0) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount greater than 0'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                return;
              }

              // Additional validation: check if category is selected
              if (selectedCategory.isEmpty || selectedCategory == "General") {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category for the transaction'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                return;
              }

              try {
                await provider.updateTransaction(
                  id: widget.transactionId,
                  amount: amount,
                  note: noteCtrl.text,
                  categoryId: selectedCategory,
                  type: type,
                  date: date,
                );

                // Update budget spending to reflect the updated transaction
                final budgetProvider = context.read<BudgetProvider>();
                await budgetProvider.updateSpending();

                if (context.mounted) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Navigate to the transaction list page
                  context.go('/transactions');
                }
              } catch (e) {
                if (context.mounted) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating transaction: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Center(
              child: Text(
                "Update Transaction",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String label, IconData icon, String category) {
    return DropdownMenuItem<String>(
      value: category,
      child: Row(
        children: [
          Icon(icon, size: 18, color: _getCategoryColor(category)),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & drink':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      case 'salary':
        return Colors.green;
      case 'extra income':
        return Colors.teal;
      default:
        return Colors.grey;
    }
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
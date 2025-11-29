import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/budget_model.dart';
import '../../state/budget_provider.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = "Food & Drink";
  DateTime? _endDate;
  bool _isMonthlyBudget = false; // To track if user selected monthly budget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Amount Input
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
                    "Budget Amount (Rp)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
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
                            _amountController.value = TextEditingValue(
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
            const SizedBox(height: 20),

            // Budget For Category
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
                    "Budget For",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip("Food & Drink", Icons.local_cafe),
                      _buildCategoryChip("Transport", Icons.directions_car),
                      _buildCategoryChip("Shopping", Icons.shopping_bag),
                      _buildCategoryChip("Others", Icons.category),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Budget Duration
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
                    "Budget Duration",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Monthly Budget Toggle
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _isMonthlyBudget ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.schedule,
                        color: _isMonthlyBudget ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: const Text(
                      "Monthly Budget",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: _isMonthlyBudget,
                      onChanged: (value) {
                        setState(() {
                          _isMonthlyBudget = value;
                          if (value) {
                            // If monthly budget is selected, calculate end date automatically
                            DateTime now = DateTime.now();
                            // Calculate end of current month
                            _endDate = DateTime(now.year, now.month + 1, 0); // Last day of current month
                          } else {
                            _endDate = null;
                          }
                        });
                      },
                    ),
                  ),

                  // Custom Date Picker (only if monthly budget is not selected)
                  if (!_isMonthlyBudget) ...[
                    const SizedBox(height: 12),
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
                        _endDate != null
                            ? "${_endDate!.day} ${_getMonthName(_endDate!.month)} ${_endDate!.year}"
                            : "Select end date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _endDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
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
                        if (picked != null) {
                          setState(() {
                            _endDate = picked;
                          });
                        }
                      },
                    ),
                  ],

                  // Show end date for monthly budget
                  if (_isMonthlyBudget) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Ends on: ${_endDate!.day} ${_getMonthName(_endDate!.month)} ${_endDate!.year}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Expanded(child: SizedBox()), // Spacer to push button to bottom

            // Create a New Budget Button
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Handle creating new budget
                  String cleanAmountText = _amountController.text.replaceAll(RegExp(r'[Rp\s,]'), '');
                  double amount = double.tryParse(cleanAmountText) ?? 0;

                  // Validate all required fields
                  if (FirebaseAuth.instance.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please log in to create a budget'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid amount greater than 0'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  // Calculate end date based on selection
                  DateTime? finalEndDate = _isMonthlyBudget
                      ? DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                      : _endDate;

                  if (finalEndDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an end date for the budget'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  // Create budget model
                  final budget = BudgetModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate unique ID
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    name: _selectedCategory,
                    limit: amount,
                    spent: 0.0,
                    startDate: DateTime.now(), // Start from today
                    endDate: finalEndDate,
                    category: _selectedCategory,
                    createdAt: DateTime.now(),
                  );

                  try {
                    // Add budget using provider
                    await context.read<BudgetProvider>().addBudget(budget);

                    // Show success message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Budget created successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate back to budget page - use go to ensure a fresh page load that will fetch latest data
                      await Future.delayed(const Duration(milliseconds: 300)); // Small delay to allow Firestore updates
                      if (context.mounted) {
                        context.go('/budgets');
                      }
                    }
                  } catch (e) {
                    // Show error message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error creating budget: $e'),
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
                  "Create a New Budget",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    bool isSelected = _selectedCategory == label;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedCategory = label;
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
    _amountController.dispose();
    super.dispose();
  }
}
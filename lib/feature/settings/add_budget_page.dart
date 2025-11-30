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
                    "Budget Amount (Rp)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A7F66), // Emerald Deep Green text
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
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
                    "Budget For",
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
                      value: _selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(), // Remove the default underline
                      items: [
                        _buildDropdownItem("Food & Drink", Icons.local_cafe),
                        _buildDropdownItem("Transport", Icons.directions_car),
                        _buildDropdownItem("Shopping", Icons.shopping_bag),
                        _buildDropdownItem("Others", Icons.category),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Budget Duration
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
                    "Budget Duration",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A7F66), // Emerald Deep Green text
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
                        color: _isMonthlyBudget
                          ? const Color(0xFF0A7F66).withOpacity(0.1) // Light Emerald Deep Green background
                          : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.schedule,
                        color: _isMonthlyBudget
                          ? const Color(0xFF0A7F66) // Emerald Deep Green
                          : Colors.grey,
                      ),
                    ),
                    title: Text(
                      "Monthly Budget",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0A7F66), // Emerald Deep Green
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
                          color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green background
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green
                        ),
                      ),
                      title: Text(
                        _endDate != null
                            ? "${_endDate!.day} ${_getMonthName(_endDate!.month)} ${_endDate!.year}"
                            : "Select end date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _endDate != null ? const Color(0xFF0A7F66) : Colors.grey, // Emerald Deep Green when selected
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: const Color(0xFF0A7F66)), // Emerald Deep Green
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
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
                        color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: const Color(0xFF0A7F66), size: 16), // Emerald Deep Green
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Ends on: ${_endDate!.day} ${_getMonthName(_endDate!.month)} ${_endDate!.year}",
                              style: TextStyle(
                                color: const Color(0xFF0A7F66), // Emerald Deep Green
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
                  backgroundColor: const Color(0xFF0A7F66), // Emerald Deep Green
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

  DropdownMenuItem<String> _buildDropdownItem(String label, IconData icon) {
    return DropdownMenuItem<String>(
      value: label,
      child: Row(
        children: [
          Icon(icon, size: 18, color: _getCategoryColor(label)),
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
    _amountController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../state/budget_provider.dart';
import '../../data/models/budget_model.dart';

class EditBudgetPage extends StatefulWidget {
  final String budgetId;

  const EditBudgetPage({super.key, required this.budgetId});

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final nameController = TextEditingController();
  final limitController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String category = "Food & Drink";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final provider = context.read<BudgetProvider>();

    // Wait briefly to ensure provider is initialized
    await Future.delayed(const Duration(milliseconds: 100));

    // Find budget in the provider's list
    final budget = provider.budgets.firstWhere(
      (b) => b.id == widget.budgetId,
      orElse: () => BudgetModel(
        id: '',
        userId: '',
        name: '',
        category: 'Food & Drink',
        limit: 0,
        spent: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );

    if (budget != null) {
      nameController.text = budget.name;
      limitController.text = budget.limit.toStringAsFixed(0);
      startDate = budget.startDate;
      endDate = budget.endDate;
      category = budget.category;
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              "Loading budget...",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0A7F66),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                // Budget Name Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Budget Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter budget name",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF0A7F66),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3),
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
                          color: const Color(0xFF0A7F66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF0A7F66).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: category,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: [
                            "Food & Drink",
                            "Transport",
                            "Shopping",
                            "Salary",
                            "Extra Income",
                            "Others"
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(value),
                                    size: 18,
                                    color: _getCategoryColor(value),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                category = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Budget Limit Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Budget Limit (Rp)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: limitController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          prefix: Text(
                            "Rp ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0A7F66),
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
                            borderSide: BorderSide(
                              color: const Color(0xFF0A7F66),
                              width: 2,
                            ),
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
                                  limitController.value = TextEditingValue(
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

                // Start Date Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A7F66).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: const Color(0xFF0A7F66),
                          ),
                        ),
                        title: Text(
                          startDate != null
                              ? "${startDate!.day} ${_getMonthName(startDate!.month)} ${startDate!.year}"
                              : "Select start date",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: startDate != null
                                ? const Color(0xFF0A7F66)
                                : Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: const Color(0xFF0A7F66)),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: startDate ?? DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: const Color(0xFF0A7F66),
                                    onPrimary: Colors.white,
                                    onSurface: const Color(0xFF0A7F66),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              startDate = picked;
                              // Ensure end date is not before start date
                              if (endDate != null && endDate!.isBefore(picked)) {
                                endDate = picked;
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // End Date Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A7F66).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0A7F66).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "End Date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A7F66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A7F66).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: const Color(0xFF0A7F66),
                          ),
                        ),
                        title: Text(
                          endDate != null
                              ? "${endDate!.day} ${_getMonthName(endDate!.month)} ${endDate!.year}"
                              : "Select end date",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: endDate != null
                                ? const Color(0xFF0A7F66)
                                : Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: const Color(0xFF0A7F66)),
                        onTap: () async {
                          if (startDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select start date first'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          final picked = await showDatePicker(
                            context: context,
                            firstDate: startDate!,
                            lastDate: DateTime(2100),
                            initialDate: endDate ?? startDate!,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: const Color(0xFF0A7F66),
                                    onPrimary: Colors.white,
                                    onSurface: const Color(0xFF0A7F66),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              endDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Update Budget Button
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A7F66), Color(0xFF076C72)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: ElevatedButton(
            onPressed: () async {
              // Validate inputs
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a budget name'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final cleanLimitText = limitController.text.replaceAll(RegExp(r'[Rp\s,]'), '');
              final limit = double.tryParse(cleanLimitText);
              if (limit == null || limit <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid budget limit'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              if (startDate == null || endDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select both start and end dates'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              if (endDate!.isBefore(startDate!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('End date cannot be before start date'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                final provider = context.read<BudgetProvider>();
                // Get the existing budget to preserve other properties
                final existingBudget = provider.budgets.firstWhere(
                  (b) => b.id == widget.budgetId,
                  orElse: () => BudgetModel(
                    id: '',
                    userId: '',
                    name: '',
                    category: '',
                    limit: 0,
                    spent: 0,
                    startDate: DateTime.now(),
                    endDate: DateTime.now(),
                    createdAt: DateTime.now(),
                  ),
                );

                if (existingBudget.id.isEmpty) {
                  throw Exception("Budget not found");
                }

                // Create updated budget model - spent amount will be recalculated by the system
                final updatedBudget = BudgetModel(
                  id: existingBudget.id,
                  userId: existingBudget.userId,
                  name: nameController.text.trim(),
                  category: category,
                  limit: limit,
                  spent: 0.0, // Will be recalculated by the system after update
                  startDate: startDate!,
                  endDate: endDate!,
                  createdAt: existingBudget.createdAt, // Keep the original creation date
                );

                await provider.updateBudget(updatedBudget);

                // Update spending to refresh the data after budget update
                await provider.updateSpending();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Budget updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.go('/budgets'); // Navigate back to budgets page
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating budget: $e'),
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
                "Update Budget",
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & drink':
        return Icons.local_cafe;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'salary':
        return Icons.work;
      case 'extra income':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
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
    nameController.dispose();
    limitController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/budget_card.dart';
import '../../state/budget_provider.dart';
import '../../data/models/budget_model.dart';

class BudgetLimitPage extends StatefulWidget {
  const BudgetLimitPage({super.key});

  @override
  State<BudgetLimitPage> createState() => _BudgetLimitPageState();
}

class _BudgetLimitPageState extends State<BudgetLimitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProvider, child) {
          final budgets = budgetProvider.budgets;

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh can be implemented to trigger an update
              // For now, just add a small delay to simulate refresh
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Your Budgets',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Budget list
                    if (budgets.isEmpty)
                      // Placeholder for empty budget list
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No budgets yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first budget to start tracking limits',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Display all budgets
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: budgets.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final budget = budgets[index];
                          return _buildBudgetCard(budget);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/budgets/add');
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBudgetCard(BudgetModel budget) {
    final double progress = budget.limit > 0 ? budget.spent / budget.limit : 0;
    final String remainingAmount = (budget.limit - budget.spent).toStringAsFixed(0);
    final String totalAmount = budget.limit.toStringAsFixed(0);

    // Get category icon and color
    IconData categoryIcon = _getCategoryIcon(budget.category);
    Color categoryColor = _getCategoryColor(budget.category);

    return BudgetCard(
      categoryName: budget.name,
      categoryIcon: categoryIcon,
      remainingAmount: remainingAmount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
      totalAmount: totalAmount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
      categoryColor: categoryColor,
      startDate: "${budget.startDate.day} ${_getMonthName(budget.startDate.month)} ${budget.startDate.year}",
      endDate: "${budget.endDate.day} ${_getMonthName(budget.endDate.month)} ${budget.endDate.year}",
      progress: progress,
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
}
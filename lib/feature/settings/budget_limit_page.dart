import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/budget_card.dart';
import '../../core/widgets/swipeable_budget_card.dart';
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
                    const SizedBox(height: 16),

                    // Budget list
                    if (budgets.isEmpty)
                      // Enhanced placeholder for empty budget list - centered
                      Container(
                        margin: const EdgeInsets.only(top: 100, bottom: 100), // Increased margins to position content lower
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9), // Light green background
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF0A7F66).withOpacity(0.2), // Light border
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 50,
                                color: const Color(0xFF0A7F66), // Emerald Deep Green
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Start Managing Your Budget',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0A7F66), // Emerald Deep Green
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Set spending limits to track and control your expenses',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _buildBenefitItem("Track spending", Icons.show_chart),
                                  _buildBenefitItem("Set limits", Icons.monetization_on),
                                  _buildBenefitItem("Stay organized", Icons.check_circle),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Create your first budget to start tracking limits',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF0A7F66), // Emerald Deep Green
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.teal],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            context.push('/budgets/add');
          },
          backgroundColor: Colors.transparent,
          heroTag: "add_budget_fab",
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
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

    return SwipeableBudgetCard(
      categoryName: budget.name,
      categoryIcon: categoryIcon,
      remainingAmount: remainingAmount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
      totalAmount: totalAmount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
      categoryColor: categoryColor,
      startDate: "${budget.startDate.day} ${_getMonthName(budget.startDate.month)} ${budget.startDate.year}",
      endDate: "${budget.endDate.day} ${_getMonthName(budget.endDate.month)} ${budget.endDate.year}",
      progress: progress,
      budget: budget,
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

  Widget _buildBenefitItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF0A7F66), // Emerald Deep Green
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
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
}
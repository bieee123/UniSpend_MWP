import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/budget_card.dart';
import '../../core/widgets/swipeable_budget_card.dart';
import '../../core/widgets/atmospheric_budget_donut.dart';
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
                    const SizedBox(height: 12),

                    // Budget Chart Visualization (always visible)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50], // Light background
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Budget Allocation Overview',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your budget usage across all categories',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16), // Increased gap from 12 to 16

                          // Donut Chart Centered (or No Data placeholder)
                          if (budgets.isNotEmpty)
                            Center(
                              child: SizedBox(
                                height: 200, // Increased height from 160 to 200
                                child: AtmosphericBudgetDonut(
                                  budgets: budgets.map((budget) =>
                                    BudgetData(
                                      category: budget.category,
                                      limit: budget.limit,
                                      spent: budget.spent,
                                    )
                                  ).toList(),
                                ),
                              ),
                            )
                          else
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'No Data',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 12),

                          // Mini Summary Section (show regardless, but with "No Data" when no budgets)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (budgets.isNotEmpty)
                                  _buildSummaryItem(
                                    'Allocated',
                                    _formatCurrency(budgetProvider.totalAllocatedBudget),
                                    const Color(0xFF0A7F66), // Emerald Deep Green
                                  )
                                else
                                  _buildSummaryItem(
                                    'Allocated',
                                    'No Data',
                                    Colors.grey,
                                  ),
                                if (budgets.isNotEmpty)
                                  _buildSummaryItem(
                                    'Used',
                                    _formatCurrency(budgetProvider.totalSpentBudget),
                                    Colors.orange,
                                  )
                                else
                                  _buildSummaryItem(
                                    'Used',
                                    'No Data',
                                    Colors.grey,
                                  ),
                                if (budgets.isNotEmpty)
                                  _buildSummaryItem(
                                    'Remaining',
                                    _formatCurrency(budgetProvider.remainingOverallBudget),
                                    Colors.green,
                                  )
                                else
                                  _buildSummaryItem(
                                    'Remaining',
                                    'No Data',
                                    Colors.grey,
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Progress Bar (only if there are budgets)
                          if (budgets.isNotEmpty)
                            _buildOverallBudgetProgress(budgetProvider),
                        ],
                      ),
                    ),

                    // Placeholder when no budgets - Display below the chart card
                    if (budgets.isEmpty)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 60), // Increased top and bottom margins to center it
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                'No Budgets Yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first budget to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF0A7F66), // Match transaction page color
                                  fontWeight: FontWeight.w600, // Bold like other pages
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

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallBudgetProgress(BudgetProvider budgetProvider) {
    final double totalAllocated = budgetProvider.totalAllocatedBudget;
    final double totalSpent = budgetProvider.totalSpentBudget;
    final double progress = totalAllocated > 0 ? totalSpent / totalAllocated : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Budget Usage: ${(progress * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress > 1 ? 1 : progress, // Cap at 1 to prevent overflow
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              totalSpent > totalAllocated
                ? Colors.red
                : const Color(0xFF0A7F66), // Emerald Deep Green
            ),
          ),
        ),
      ],
    );
  }
}
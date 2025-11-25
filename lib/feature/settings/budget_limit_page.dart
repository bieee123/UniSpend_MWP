import 'package:flutter/material.dart';
import '../../core/widgets/budget_card.dart';

class BudgetLimitPage extends StatefulWidget {
  const BudgetLimitPage({super.key});

  @override
  State<BudgetLimitPage> createState() => _BudgetLimitPageState();
}

class _BudgetLimitPageState extends State<BudgetLimitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budgets"),
        automaticallyImplyLeading: false, // Will be handled by MainLayout
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              margin: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
              child: const Text(
                "Budgets",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Budget List
            _buildBudgetList(),
            
            // Add New Budget Button
            _buildAddBudgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetList() {
    // Example budget data
    final budgets = [
      {
        'name': 'Monthly Meal',
        'icon': Icons.restaurant,
        'remaining': '1,157,000',
        'total': '2,000,000',
        'color': Colors.green,
        'startDate': 'October 25, 2024',
        'endDate': 'November 25, 2024',
        'progress': 0.423, // (2000000-1157000)/2000000 = 0.4215
      },
      {
        'name': 'Monthly Transportation',
        'icon': Icons.directions_car,
        'remaining': '500,000',
        'total': '1,000,000',
        'color': Colors.orange,
        'startDate': 'October 25, 2024',
        'endDate': 'November 25, 2024',
        'progress': 0.5, // (1000000-500000)/1000000 = 0.5
      },
      {
        'name': 'Shopping',
        'icon': Icons.shopping_cart,
        'remaining': '750,000',
        'total': '1,500,000',
        'color': Colors.purple,
        'startDate': 'October 25, 2024',
        'endDate': 'November 25, 2024',
        'progress': 0.5, // (1500000-750000)/1500000 = 0.5
      },
    ];

    return Column(
      children: budgets.map((budget) {
        return BudgetCard(
          categoryName: budget['name'] as String,
          categoryIcon: budget['icon'] as IconData,
          remainingAmount: budget['remaining'] as String,
          totalAmount: budget['total'] as String,
          categoryColor: budget['color'] as Color,
          startDate: budget['startDate'] as String,
          endDate: budget['endDate'] as String,
          progress: budget['progress'] as double,
        );
      }).toList() as List<Widget>,
    );
  }

  Widget _buildAddBudgetButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle adding new budget
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[50], // Very light green tint
          foregroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 18),
            const SizedBox(width: 8),
            const Text(
              "Add New Budget",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
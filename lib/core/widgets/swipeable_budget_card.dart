import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/budget_model.dart';
import '../../state/budget_provider.dart';

class SwipeableBudgetCard extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final String remainingAmount;
  final String totalAmount;
  final Color categoryColor;
  final String startDate;
  final String endDate;
  final double progress;
  final BudgetModel budget;

  const SwipeableBudgetCard({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.remainingAmount,
    required this.totalAmount,
    required this.categoryColor,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('budget_${budget.id}'), // Unique key for each budget
      direction: DismissDirection.endToStart, // Only allow swipe from right to left
      confirmDismiss: (direction) async {
        // Show confirmation before deleting
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) async {
        // Perform the deletion when item is dismissed
        final budgetProvider = context.read<BudgetProvider>();

        await budgetProvider.deleteBudget(budget.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Budget deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16), // Match the card's border radius
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          // Navigate to edit budget page when card is tapped
          context.push('/budgets/edit/${budget.id}');
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Consistent margins
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16), // Increased border radius
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category name and icon row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        categoryIcon,
                        color: categoryColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Remaining budget text
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Rp ${remainingAmount} left of Rp ${totalAmount}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: categoryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Progress bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Date range
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            startDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            endDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show confirmation dialog before deleting
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Budget?"),
          content: const Text("Are you sure you want to delete this budget?"),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog with false result (cancel deletion)
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Close dialog with true result (confirm deletion)
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700], // Red text for delete button
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed without making a choice
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/transaction_model.dart';
import '../../state/transaction_provider.dart';
import '../../state/budget_provider.dart';

class SwipeableTransactionCard extends StatelessWidget {
  final Color categoryIconColor;
  final String categoryTitle;
  final String description;
  final String paymentMethod;
  final String amount;
  final TransactionModel transaction;

  const SwipeableTransactionCard({
    super.key,
    required this.categoryIconColor,
    required this.categoryTitle,
    required this.description,
    required this.paymentMethod,
    required this.amount,
    required this.transaction,
  });

  // Helper method to get the appropriate icon based on category
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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('transaction_${transaction.id}'), // Unique key for each transaction
      direction: DismissDirection.endToStart, // Only allow swipe from right to left
      confirmDismiss: (direction) async {
        // Show confirmation dialog before deleting
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) async {
        // Perform the deletion when item is dismissed
        final transactionProvider = context.read<TransactionProvider>();
        final budgetProvider = context.read<BudgetProvider>();

        await transactionProvider.deleteTransaction(transaction.id);
        await budgetProvider.updateSpending(); // Update budget after deleting transaction
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16), // Match the card's border radius
        ),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
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
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: categoryIconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: categoryIconColor,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(categoryTitle),
                  color: categoryIconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        categoryTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            paymentMethod,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    amount,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: transaction.type == 'income' 
                          ? Colors.green[700] 
                          : Colors.red[700],
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
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
          title: const Text("Delete Transaction?"),
          content: const Text("Are you sure you want to delete this transaction?"),
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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/saving_goal_model.dart';
import '../../state/saving_goals_provider.dart';

class SwipeableSavingGoalCard extends StatelessWidget {
  final SavingGoal goal;

  const SwipeableSavingGoalCard({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('saving_goal_${goal.id}'), // Unique key for each saving goal
      direction: DismissDirection.endToStart, // Only allow swipe from right to left
      confirmDismiss: (direction) async {
        // Show confirmation before deleting
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) async {
        // Perform the deletion when item is dismissed
        final savingGoalsProvider = context.read<SavingGoalsProvider>();

        await savingGoalsProvider.deleteGoal(goal.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saving goal deleted'),
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
          // Navigate to goal detail page when card is tapped
          context.push('/saving-goals/${goal.id}');
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        goal.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (goal.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '🎉 Completed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${goal.savedAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '/ Rp ${goal.targetAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: goal.progressPercentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0A7F66)),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${goal.progressPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${goal.completedUnits}/${goal.totalUnits} saved',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
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
          title: const Text("Delete Saving Goal?"),
          content: const Text("Are you sure you want to delete this saving goal?"),
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
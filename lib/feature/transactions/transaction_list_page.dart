import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../state/transaction_provider.dart';
import '../../state/category_provider.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../core/widgets/skeleton_loader.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/transactions/add');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Force a refresh of data
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: StreamBuilder<List<TransactionModel>>(
          stream: provider.streamTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonList(itemCount: 5);
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final transactions = snapshot.data ?? [];

            if (transactions.isEmpty) {
              return const Center(
                child: Text('No transactions yet. Add your first transaction!'),
              );
            }

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Semantics(
                  label: 'Transaction: ${transaction.note}, ${transaction.type}, ${transaction.categoryId}, Amount: Rp ${transaction.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  child: AnimatedListItem(
                    index: index,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(transaction.note),
                        subtitle: StreamBuilder<List<CategoryModel>>(
                          stream: context.read<CategoryProvider>().streamCategories(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final categories = snapshot.data!;
                              final category = categories.firstWhere(
                                (cat) => cat.id == transaction.categoryId,
                                orElse: () => CategoryModel(
                                  id: transaction.categoryId,
                                  userId: transaction.userId,
                                  name: transaction.categoryId,
                                  type: transaction.type,
                                ),
                              );
                              return Text('${transaction.type} • ${category.name}');
                            }
                            return Text('${transaction.type} • ${transaction.categoryId}');
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${transaction.type == 'income' ? '+' : '-'}Rp ${transaction.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                color: transaction.type == 'income' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton(
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  // Navigate to edit transaction page
                                  context.push('/transactions/edit/${transaction.id}');
                                } else if (value == 'delete') {
                                  // Show delete confirmation
                                  _showDeleteConfirmationDialog(context, provider, transaction.id);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to transaction detail page (to be implemented)
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, TransactionProvider provider, String transactionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteTransaction(transactionId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

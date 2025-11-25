import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../state/transaction_provider.dart';
import '../../state/category_provider.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../core/widgets/skeleton_loader.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.read<CategoryProvider>();

    // Initialize default categories when dashboard is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryProvider.createDefaultCategoriesIfEmpty();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("UniSpend Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Force a refresh of data
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: StreamBuilder<List<TransactionModel>>(
          stream: transactionProvider.streamTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skeleton for today's spending card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(height: 16, width: 120),
                            const SizedBox(height: 8),
                            SkeletonLoader(height: 24, width: 100),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skeleton for monthly spending card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(height: 16, width: 140),
                            const SizedBox(height: 8),
                            SkeletonLoader(height: 24, width: 120),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skeleton for quick actions
                    SkeletonLoader(height: 20, width: 100),
                    const SizedBox(height: 16),

                    // Skeleton for action buttons
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonLoader(height: 40),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SkeletonLoader(height: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: SkeletonLoader(height: 40),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SkeletonLoader(height: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final transactions = snapshot.data ?? [];

            // Calculate today's and this month's spending
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            double todaySpending = 0;
            double monthSpending = 0;

            for (final transaction in transactions) {
              final transactionDate = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);

              if (transactionDate == today && transaction.type == 'expense') {
                todaySpending += transaction.amount;
              }

              if (transaction.date.year == now.year &&
                  transaction.date.month == now.month &&
                  transaction.type == 'expense') {
                monthSpending += transaction.amount;
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's spending
                  Semantics(
                    label: 'Today\'s Spending: Rp ${todaySpending.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Spending',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${todaySpending.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Monthly spending
                  Semantics(
                    label: 'This Month\'s Spending: Rp ${monthSpending.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'This Month\'s Spending',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${monthSpending.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Add a new transaction',
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/transactions/add'),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Transaction'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'View all transactions',
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/transactions'),
                            icon: const Icon(Icons.list),
                            label: const Text('View All'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'View calendar with transactions',
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/calendar'),
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Calendar'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'View analytics and reports',
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/analytics'),
                            icon: const Icon(Icons.bar_chart),
                            label: const Text('Analytics'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Expense categories chart
                  StreamBuilder<List<CategoryModel>>(
                    stream: categoryProvider.streamCategories(),
                    builder: (context, categorySnapshot) {
                      if (categorySnapshot.connectionState == ConnectionState.waiting) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      if (categorySnapshot.hasError) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Error loading categories: ${categorySnapshot.error}'),
                          ),
                        );
                      }

                      final categories = categorySnapshot.data ?? [];

                      // Filter only expenses and group by category
                      final expenseTransactions = transactions.where((t) => t.type == 'expense').toList();

                      if (expenseTransactions.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No expenses to display'),
                          ),
                        );
                      }

                      // Group expenses by category ID and calculate totals
                      final categoryTotals = <String, double>{};
                      for (final transaction in expenseTransactions) {
                        final currentTotal = categoryTotals[transaction.categoryId] ?? 0;
                        categoryTotals[transaction.categoryId] = currentTotal + transaction.amount;
                      }

                      // Map category IDs to names for display
                      final pieData = categoryTotals.entries.map((entry) {
                        final category = categories.firstWhere(
                          (cat) => cat.id == entry.key,
                          orElse: () => CategoryModel(
                            id: entry.key,
                            userId: '',
                            name: entry.key,
                            type: 'expense',
                          ),
                        );

                        return PieChartSectionData(
                          value: entry.value,
                          title: category.name,
                          radius: 15,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expense Breakdown',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: pieData,
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

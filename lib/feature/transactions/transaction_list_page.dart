import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/transaction_model.dart';
import '../../state/transaction_provider.dart';
import '../../state/budget_provider.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  String _selectedFilter = 'Monthly'; // Default selected tab
  DateTime _currentMonth = DateTime.now();

  String _getMonthYearString() {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, _currentMonth.day);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, _currentMonth.day);
    });
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

  String _formatDate(DateTime date) {
    return '${_getWeekdayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)}';
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Month Selector
              Row(
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      _getMonthYearString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Tabs
              Row(
                children: [
                  _buildTab("Weekly", _selectedFilter == 'Weekly'),
                  const SizedBox(width: 8),
                  _buildTab("Monthly", _selectedFilter == 'Monthly'),
                  const SizedBox(width: 8),
                  _buildTab("Yearly", _selectedFilter == 'Yearly'),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Bar
              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return StreamBuilder<List<TransactionModel>>(
                    stream: transactionProvider.streamTransactions(),
                    builder: (context, snapshot) {
                      double totalBalance = 0.0;
                      double totalIncome = 0.0;
                      double totalExpense = 0.0;

                      if (snapshot.hasData) {
                        final transactions = snapshot.data ?? [];

                        // Filter transactions based on selected period (Weekly, Monthly, Yearly)
                        final now = DateTime.now();
                        List<TransactionModel> filteredTransactions = [];

                        for (var transaction in transactions) {
                          bool includeTransaction = false;

                          switch (_selectedFilter) {
                            case 'Weekly':
                              // Include transactions from the last 7 days
                              final daysDiff = now.difference(transaction.date).inDays;
                              includeTransaction = daysDiff <= 7 && daysDiff >= 0;
                              break;
                            case 'Monthly':
                              // Include transactions from the same month and year
                              includeTransaction =
                                  transaction.date.month == now.month &&
                                  transaction.date.year == now.year;
                              break;
                            case 'Yearly':
                              // Include transactions from the same year
                              includeTransaction = transaction.date.year == now.year;
                              break;
                            default:
                              includeTransaction = true;
                              break;
                          }

                          if (includeTransaction) {
                            filteredTransactions.add(transaction);
                          }
                        }

                        for (var transaction in filteredTransactions) {
                          if (transaction.type == 'income') {
                            totalIncome += transaction.amount;
                          } else if (transaction.type == 'expense') {
                            totalExpense += transaction.amount;
                          }
                        }
                        totalBalance = totalIncome - totalExpense;
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Rp ${totalBalance.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: totalBalance >= 0 ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Total Balance",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Rp ${totalIncome.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    "Income",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Rp ${totalExpense.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Expense",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Display transaction list based on actual data
              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return StreamBuilder<List<TransactionModel>>(
                    stream: transactionProvider.streamTransactions(),
                    builder: (context, snapshot) {
                      final transactions = snapshot.data ?? [];

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      // Show empty state immediately when no transactions exist, regardless of connection state
                      if (transactions.isEmpty && snapshot.connectionState != ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start tracking your expenses and income',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Still show loading if waiting for initial data but we want to handle this differently
                      // For now, we'll show the same empty state while waiting to avoid showing loading
                      if (snapshot.connectionState == ConnectionState.waiting && transactions.isEmpty) {
                        // Instead of showing a loading indicator, immediately show the empty state
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start tracking your expenses and income',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (transactions.isNotEmpty) {
                        // Group transactions by date
                        Map<String, List<TransactionModel>> groupedTransactions = {};
                        for (var transaction in transactions) {
                          String dateKey = '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}';
                          if (!groupedTransactions.containsKey(dateKey)) {
                            groupedTransactions[dateKey] = [];
                          }
                          groupedTransactions[dateKey]!.add(transaction);
                        }

                        List<Widget> dateSections = [];
                        groupedTransactions.forEach((dateString, transactions) {
                          double totalAmountValue = transactions.fold(0, (sum, transaction) => sum + transaction.amount);
                          String totalAmount = totalAmountValue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

                          dateSections.add(
                            _buildDateSection(
                              _formatDate(transactions.first.date),
                              'Rp $totalAmount',
                              transactions.map((transaction) => _TransactionItem(
                                categoryIconColor: _getCategoryColor(transaction.categoryId),
                                categoryTitle: transaction.categoryId,
                                description: transaction.note,
                                paymentMethod: 'Cash', // Could be dynamic from transaction data
                                amount: '${transaction.type == 'income' ? '+' : '-'}Rp ${transaction.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                transaction: transaction,
                              )).toList(),
                            ),
                          );
                          dateSections.add(const SizedBox(height: 16));
                        });

                        return Column(children: dateSections);
                      }

                      // Fallback for other edge cases
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No transactions yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start tracking your expenses and income',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/transactions/add');
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

  Widget _buildTab(String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(String date, String totalAmount, List<Widget> transactions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                totalAmount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...transactions,
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Color categoryIconColor;
  final String categoryTitle;
  final String description;
  final String paymentMethod;
  final String amount;
  final TransactionModel transaction;

  const _TransactionItem({
    required this.categoryIconColor,
    required this.categoryTitle,
    required this.description,
    required this.paymentMethod,
    required this.amount,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        final transactionProvider = context.read<TransactionProvider>();
        final budgetProvider = context.read<BudgetProvider>();

        await transactionProvider.deleteTransaction(transaction.id);
        await budgetProvider.updateSpending(); // Update budget after deleting transaction

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction deleted')),
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryIconColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.circle,
                color: categoryIconColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    paymentMethod,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: transaction.type == 'income' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
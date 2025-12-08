import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/transaction_model.dart';
import '../../state/transaction_provider.dart';
import '../../state/budget_provider.dart';
import '../../core/widgets/swipeable_transaction_card.dart';

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
    return '${_getWeekdayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
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
              const SizedBox(height: 4), // Reduced space from header

              // Month Selector - Flat Style (No container)
              Row(
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    padding: EdgeInsets.zero, // Remove default padding
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40), // Smaller touch area
                    icon: Icon(
                      Icons.chevron_left,
                      color: const Color(0xFF0A7F66), // Emerald Deep Green
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _getMonthYearString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0A7F66), // Emerald Deep Green
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    padding: EdgeInsets.zero, // Remove default padding
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40), // Smaller touch area
                    icon: Icon(
                      Icons.chevron_right,
                      color: const Color(0xFF0A7F66), // Emerald Deep Green
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4), // Reduced space between navigator and total balance card

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
              const SizedBox(height: 12), // Increased space between tabs and summary card for better separation

              // Enhanced Summary Card
              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return StreamBuilder<List<TransactionModel>>(
                    stream: transactionProvider.streamTransactions(),
                    builder: (context, snapshot) {
                      double totalBalance = 0.0;
                      double totalIncome = 0.0;
                      double totalExpense = 0.0;

                      if (snapshot.hasData) {
                        final allTransactions = snapshot.data ?? [];

                        // Filter transactions based on selected period (Weekly, Monthly, Yearly) and selected month
                        List<TransactionModel> filteredTransactions = [];

                        for (var transaction in allTransactions) {
                          bool includeTransaction = false;

                          switch (_selectedFilter) {
                            case 'Weekly':
                              // For Weekly filter, divide the month into weeks of 7 days (1-7, 8-14, 15-21, 22-end)
                              // Find which week the selected date is in
                              int weekStartDay;
                              if (_currentMonth.day <= 7) {
                                weekStartDay = 1;  // First week of the month (days 1-7)
                              } else if (_currentMonth.day <= 14) {
                                weekStartDay = 8;  // Second week of the month (days 8-14)
                              } else if (_currentMonth.day <= 21) {
                                weekStartDay = 15; // Third week of the month (days 15-21)
                              } else {
                                weekStartDay = 22; // Fourth/fifth week of the month (days 22-end)
                              }

                              // Get the last day of the month to make sure we don't exceed it
                              int maxDayInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
                              int weekEndDay = weekStartDay + 6;
                              if (weekEndDay > maxDayInMonth) {
                                weekEndDay = maxDayInMonth;  // Adjust if week goes beyond month end
                              }

                              DateTime startOfSelectedWeek = DateTime(_currentMonth.year, _currentMonth.month, weekStartDay);
                              DateTime endOfSelectedWeek = DateTime(_currentMonth.year, _currentMonth.month, weekEndDay);

                              includeTransaction =
                                transaction.date.isAtSameMomentAs(startOfSelectedWeek) ||
                                (transaction.date.isAfter(startOfSelectedWeek.subtract(const Duration(days: 1))) &&
                                 transaction.date.isBefore(endOfSelectedWeek.add(const Duration(days: 1))) &&
                                 transaction.date.month == _currentMonth.month &&
                                 transaction.date.year == _currentMonth.year) ||
                                (transaction.date.day >= weekStartDay &&
                                 transaction.date.day <= weekEndDay &&
                                 transaction.date.month == _currentMonth.month &&
                                 transaction.date.year == _currentMonth.year);
                              break;
                            case 'Monthly':
                              // Include transactions from the selected month and year
                              includeTransaction = transaction.date.month == _currentMonth.month &&
                                                  transaction.date.year == _currentMonth.year;
                              break;
                            case 'Yearly':
                              // Include transactions from the same year as selected
                              includeTransaction = transaction.date.year == _currentMonth.year;
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

                      // Format amounts for display
                      String formatAmount(double amount) {
                        return "Rp ${amount.toInt().toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},'
                        )}";
                      }

                      // Masked amounts
                      String maskedAmount = "*****";

                      // Format actual amounts
                      String formattedTotalBalance = formatAmount(totalBalance);
                      String formattedTotalIncome = formatAmount(totalIncome);
                      String formattedTotalExpense = formatAmount(totalExpense);

                      // Store visibility state
                      bool _showAmounts = true;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.green, Colors.teal],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Further reduced vertical padding for more compactness
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Total Balance
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total Balance",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(0.7),
                                            ),
                                          ),
                                          Text(
                                            _showAmounts ? formattedTotalBalance : maskedAmount,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Eye icon button to toggle visibility
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showAmounts = !_showAmounts;
                                          });
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            _showAmounts ? Icons.visibility : Icons.visibility_off,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Expense and Income cards (swapped positions - Expense on left, Income on right)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Expense card
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.trending_down,
                                                color: Colors.red.shade300,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Expense",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white.withOpacity(0.8),
                                                      ),
                                                    ),
                                                    Text(
                                                      _showAmounts ? formattedTotalExpense : maskedAmount,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Income card
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.trending_up,
                                                color: Colors.green.shade300,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Income",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white.withOpacity(0.8),
                                                      ),
                                                    ),
                                                    Text(
                                                      _showAmounts ? formattedTotalIncome : maskedAmount,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0A7F66), // Emerald Deep Green (same as budgets page)
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start tracking your expenses and income',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF0A7F66), // Emerald Deep Green
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
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0A7F66), // Emerald Deep Green (same as budgets page)
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start tracking your expenses and income',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF0A7F66), // Emerald Deep Green
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
                          String totalAmount = totalAmountValue.toInt().toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

                          dateSections.add(
                            _buildDateSection(
                              _formatDate(transactions.first.date),
                              'Rp $totalAmount',
                              transactions.map((transaction) => SwipeableTransactionCard(
                                categoryIconColor: _getCategoryColor(transaction.categoryId),
                                categoryTitle: transaction.categoryId,
                                description: transaction.note,
                                paymentMethod: 'Cash', // Could be dynamic from transaction data
                                amount: '${transaction.type == 'income' ? '+' : '-'}Rp ${transaction.amount.toInt().toString().replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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
                                color: const Color(0xFF0A7F66), // Emerald Deep Green
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No transactions yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start tracking your expenses and income',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
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
            context.push('/transactions/add');
          },
          backgroundColor: Colors.transparent,
          heroTag: "add_transaction_fab",
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
            color: isActive ? null : Colors.grey[300],
            gradient: isActive
              ? const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                )
              : null,
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
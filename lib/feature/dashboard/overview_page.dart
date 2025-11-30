import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/transaction_model.dart';
import '../../state/transaction_provider.dart';
import '../../core/widgets/month_selector.dart';
import 'widgets/expense_income_cards.dart';
import 'widgets/total_wealth_cashflow_card.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // If user is not logged in, show a placeholder message
    if (currentUser == null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                ),
                const SizedBox(height: 24),
                Text(
                  'Please log in to view your financial overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0A7F66), // Emerald Deep Green
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your spending and income data will appear here after you sign in',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF0A7F66), // Emerald Deep Green
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return StreamBuilder<List<TransactionModel>>(
            stream: transactionProvider.streamTransactions(),
            builder: (context, snapshot) {
              // If there's an error with the stream, show error message
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: const Color(0xFF0A7F66), // Emerald Deep Green
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Error loading financial data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0A7F66), // Emerald Deep Green
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again later',
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

              // If there's no error but no data either, show a professional placeholder
              final transactions = snapshot.data ?? [];

              // Calculate income and expenses from transactions
              double totalIncome = 0;
              double totalExpense = 0;
              Map<String, double> expenseByCategory = {};
              Map<String, double> incomeByCategory = {};

              for (var transaction in transactions) {
                if (transaction.type == 'income') {
                  totalIncome += transaction.amount;
                  incomeByCategory[transaction.categoryId] =
                      (incomeByCategory[transaction.categoryId] ?? 0) + transaction.amount;
                } else if (transaction.type == 'expense') {
                  totalExpense += transaction.amount;
                  expenseByCategory[transaction.categoryId] =
                      (expenseByCategory[transaction.categoryId] ?? 0) + transaction.amount;
                }
              }

              final totalWealth = totalIncome - totalExpense;
              final cashflow = totalIncome - totalExpense;

              // Month Selector and Cards
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0), // Add padding to match the lock screen
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A7F66).withOpacity(0.05), // Light Emerald Deep Green background
                        borderRadius: BorderRadius.circular(16), // Modern rounded corners
                        border: Border.all(
                          color: const Color(0xFF0A7F66).withOpacity(0.3), // Emerald Deep Green border
                          width: 1,
                        ),
                      ),
                      child: MonthSelector(
                        months: const ["Jul 2025", "Aug 2025", "Sep 2025", "Oct 2025", "Nov 2025"],
                        initialIndex: 4,
                        onMonthChanged: (index) {
                          // Handle month change
                        },
                      ),
                    ),

                    const SizedBox(height: 16), // Consistent spacing

                    // Expenses Section
                    ExpensesCard(
                      transactions: transactions,
                      expenseByCategory: expenseByCategory,
                      totalExpense: totalExpense,
                    ),

                    const SizedBox(height: 16), // Consistent spacing

                    // Income Section
                    IncomeCard(
                      transactions: transactions,
                      incomeByCategory: incomeByCategory,
                      totalIncome: totalIncome,
                    ),

                    const SizedBox(height: 16), // Consistent spacing

                    // Total Wealth & Cashflow Card
                    TotalWealthCashflowCard(
                      wealthAmount: totalWealth.toStringAsFixed(0)
                          .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                      cashflowAmount: cashflow.toStringAsFixed(0)
                          .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
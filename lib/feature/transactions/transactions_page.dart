import 'package:flutter/material.dart';
import '../core/widgets/transaction_item.dart';
import '../core/widgets/date_section.dart';
import '../core/widgets/summary_bar.dart';
import '../core/widgets/filter_tabs.dart';
import '../core/widgets/month_selector.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        automaticallyImplyLeading: false, // Will be handled by MainLayout
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              margin: const EdgeInsets.only(top: 16, left: 16),
              child: const Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Month Selector
            MonthSelector(
              initialDate: DateTime.now(),
              onMonthChanged: (date) {
                // Handle month change
              },
            ),
            
            // Filter Tabs
            FilterTabs(
              onTabChanged: (tab) {
                // Handle tab change
              },
            ),
            
            // Summary Bar
            SummaryBar(
              totalBalance: "Rp 0",
              income: "Rp 0",
              expense: "Rp 0",
            ),
            
            // Transaction List
            _buildTransactionList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add transaction
          Navigator.pushNamed(context, '/transactions/add');
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

  Widget _buildTransactionList() {
    // Example transaction data
    final transactions = [
      {
        'day': 'Sat',
        'date': '11/24',
        'transactions': [
          {
            'category': 'Food & Drink',
            'description': 'Kopi Tuku',
            'paymentMethod': 'Cash',
            'amount': 'Rp 23,000',
            'color': Colors.purple,
          },
          {
            'category': 'Transport',
            'description': 'MRT',
            'paymentMethod': 'Cash',
            'amount': 'Rp 10,000',
            'color': Colors.pink,
          },
        ],
        'totalAmount': 'Rp 33,000',
      },
      {
        'day': 'Sun',
        'date': '11/25',
        'transactions': [
          {
            'category': 'Shopping',
            'description': 'kaos',
            'paymentMethod': 'Cash',
            'amount': 'Rp 120,000',
            'color': Colors.yellow,
          },
        ],
        'totalAmount': 'Rp 120,000',
      },
      {
        'day': 'Mon',
        'date': '11/26',
        'transactions': [
          {
            'category': 'Food & Drink',
            'description': 'lunch',
            'paymentMethod': 'Cash',
            'amount': 'Rp 75,000',
            'color': Colors.purple,
          },
          {
            'category': 'Transport',
            'description': 'gojek',
            'paymentMethod': 'Cash',
            'amount': 'Rp 23,000',
            'color': Colors.pink,
          },
        ],
        'totalAmount': 'Rp 98,000',
      },
    ];

    return Column(
      children: transactions.map((dayData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateSection(
              day: dayData['day'] as String,
              date: dayData['date'] as String,
              totalAmount: dayData['totalAmount'] as String,
            ),
            ..._buildDayTransactions(dayData['transactions'] as List<dynamic>),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _buildDayTransactions(List<dynamic> transactions) {
    return transactions.map((transaction) {
      return TransactionItem(
        category: transaction['category'] as String,
        description: transaction['description'] as String,
        paymentMethod: transaction['paymentMethod'] as String,
        amount: transaction['amount'] as String,
        categoryColor: transaction['color'] as Color,
      );
    }).toList();
  }
}
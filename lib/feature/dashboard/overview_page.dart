import 'package:flutter/material.dart';
import '../../core/widgets/month_selector.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/total_wealth_cashflow_card.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Main Wallet",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector
            MonthSelector(
              months: ["Jul 2025", "Aug 2025", "Sep 2025", "Oct 2025", "Nov 2025"],
              initialIndex: 4,
              onMonthChanged: (index) {
                // Handle month change
              },
            ),
            
            // Expenses Section
            SectionCard(
              title: "Expenses",
              totalAmount: "0",
              amounts: [1500000, 800000, 1200000, 500000], // Food, Transport, Shopping, Bills
              colors: [Colors.yellow, Colors.orange, Colors.purple, Colors.teal],
              categories: ["Food & Drink", "Transport", "Shopping", "Bills"],
              percentages: ["25%", "15%", "30%", "10%"],
            ),
            
            // Income Section
            SectionCard(
              title: "Income",
              totalAmount: "0",
              amounts: [3000000, 2000000], // Salary, Gifts
              colors: [Colors.green, Colors.blue],
              categories: ["Salary", "Gifts"],
              percentages: ["60%", "40%"],
            ),
            
            // Total Wealth & Cashflow Card
            TotalWealthCashflowCard(
              wealthAmount: "0",
              cashflowAmount: "0",
            ),
          ],
        ),
      ),
    );
  }
}
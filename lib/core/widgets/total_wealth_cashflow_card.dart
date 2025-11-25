import 'package:flutter/material.dart';

class TotalWealthCashflowCard extends StatelessWidget {
  final String wealthAmount;
  final String cashflowAmount;

  const TotalWealthCashflowCard({
    Key? key,
    required this.wealthAmount,
    required this.cashflowAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if cashflow amount is positive or negative
    bool isPositiveCashflow = double.tryParse(cashflowAmount.replaceAll(RegExp(r'[^\d.-]'), ''))! >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light grey background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Wealth Column
          Expanded(
            child: Column(
              children: [
                Text(
                  'Rp $wealthAmount',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Wealth',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          // Cashflow Column
          Expanded(
            child: Column(
              children: [
                Text(
                  'Rp $cashflowAmount',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isPositiveCashflow ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cashflow (Month)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
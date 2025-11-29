import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/transaction_model.dart';

class ExpensesCard extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Map<String, double> expenseByCategory;
  final double totalExpense;

  const ExpensesCard({
    super.key,
    required this.transactions,
    required this.expenseByCategory,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only expense transactions
    final expenseTransactions = transactions.where((t) => t.type == 'expense').toList();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Expenses",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (expenseTransactions.isEmpty)
            // Show no data placeholder when no expenses exist
            const Column(
              children: [
                PieChartPlaceholder(
                  isExpenses: true,
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    "No expenses recorded",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                // PieChart Placeholder
                Expanded(
                  child: PieChartPlaceholder(
                    isExpenses: true,
                    expenseByCategory: expenseByCategory,
                  ),
                ),
                const SizedBox(width: 16),
                // Legend Items
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: expenseByCategory.entries
                        .map((entry) => LegendItem(
                              color: _getCategoryColor(entry.key),
                              label: entry.key,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          // Breakdown List
          if (expenseTransactions.isNotEmpty)
            ...expenseByCategory.entries.map((entry) {
              final percent = totalExpense > 0
                  ? ((entry.value / totalExpense) * 100).toStringAsFixed(1) + '%'
                  : '0%';
              return BreakdownListItem(
                percent: percent,
                color: _getCategoryColor(entry.key),
                category: entry.key,
                amount: "Rp ${entry.value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
              );
            }).toList()
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  "No expenses to show",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
}

class IncomeCard extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Map<String, double> incomeByCategory;
  final double totalIncome;

  const IncomeCard({
    super.key,
    required this.transactions,
    required this.incomeByCategory,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only income transactions
    final incomeTransactions = transactions.where((t) => t.type == 'income').toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Income",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (incomeTransactions.isEmpty)
            // Show no data placeholder when no income exists
            const Column(
              children: [
                PieChartPlaceholder(
                  isExpenses: false,
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    "No income recorded",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                // PieChart Placeholder
                Expanded(
                  child: PieChartPlaceholder(
                    isExpenses: false,
                    incomeByCategory: incomeByCategory,
                  ),
                ),
                const SizedBox(width: 16),
                // Legend Items
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: incomeByCategory.entries
                        .map((entry) => LegendItem(
                              color: _getCategoryColor(entry.key),
                              label: entry.key,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          // Breakdown List
          if (incomeTransactions.isNotEmpty)
            ...incomeByCategory.entries.map((entry) {
              final percent = totalIncome > 0
                  ? ((entry.value / totalIncome) * 100).toStringAsFixed(1) + '%'
                  : '0%';
              return BreakdownListItem(
                percent: percent,
                color: _getCategoryColor(entry.key),
                category: entry.key,
                amount: "Rp ${entry.value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
              );
            }).toList()
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  "No income to show",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
}

class PieChartPlaceholder extends StatelessWidget {
  final bool isExpenses;
  final Map<String, double>? expenseByCategory;
  final Map<String, double>? incomeByCategory;

  const PieChartPlaceholder({
    super.key,
    required this.isExpenses,
    this.expenseByCategory,
    this.incomeByCategory,
  });

  @override
  Widget build(BuildContext context) {
    final dataMap = isExpenses ? expenseByCategory : incomeByCategory;

    if (dataMap == null || dataMap.isEmpty) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            "No Data",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final List<PieChartSectionData> sections = [];
    final keys = dataMap.keys.toList();
    double total = dataMap.values.fold(0.0, (a, b) => a + b);

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final value = dataMap[key] ?? 0;
      final percentage = total != 0 ? (value / total) * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: _getCategoryColor(key),
          value: value,
          title: '${percentage.round()}%',
          radius: 15,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 0,
          sectionsSpace: 0,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
          ),
        ),
      ),
    );
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
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class BreakdownListItem extends StatelessWidget {
  final String percent;
  final Color color;
  final String category;
  final String amount;

  const BreakdownListItem({
    super.key,
    required this.percent,
    required this.color,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              percent,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            category,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
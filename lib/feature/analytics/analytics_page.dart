import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../../state/transaction_provider.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _timeRange = "current_month"; // current_month, last_month, last_3_months, year

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final now = DateTime.now();

    // Set default range based on selection
    DateTime startDate;
    DateTime endDate;

    switch (_timeRange) {
      case "current_month":
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case "last_month":
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      case "last_3_months":
        startDate = DateTime(now.year, now.month - 3, 1);
        endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      case "year":
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      default:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Analytics"),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: transactionProvider.streamTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allTransactions = snapshot.data ?? [];

          // Filter transactions for the selected range
          final transactions = allTransactions
              .where((t) => t.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
                  t.date.isBefore(endDate.add(const Duration(seconds: 1))))
              .toList();

          // Calculate income vs expense
          double totalIncome = 0;
          double totalExpense = 0;
          double netSavings = 0;

          for (final transaction in transactions) {
            if (transaction.type == 'income') {
              totalIncome += transaction.amount;
            } else {
              totalExpense += transaction.amount;
            }
          }

          netSavings = totalIncome - totalExpense;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time range selector
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Time Range",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: _timeRange,
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(
                                value: "current_month",
                                child: Text("Current Month"),
                              ),
                              const DropdownMenuItem(
                                value: "last_month",
                                child: Text("Last Month"),
                              ),
                              const DropdownMenuItem(
                                value: "last_3_months",
                                child: Text("Last 3 Months"),
                              ),
                              const DropdownMenuItem(
                                value: "year",
                                child: Text("This Year"),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _timeRange = newValue;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Financial Overview
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Financial Overview",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAmountCard("Income", totalIncome, Colors.green, "Rp"),
                              _buildAmountCard("Expense", totalExpense, Colors.red, "-Rp"),
                              _buildAmountCard("Savings", netSavings, netSavings >= 0 ? Colors.blue : Colors.orange, netSavings >= 0 ? "Rp" : "-Rp"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Income vs Expense Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Income vs Expense",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildIncomeExpenseBarChart(transactions),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Distribution
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category Distribution (Expenses)",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildCategoryPieChart(transactions),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Monthly Trend
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Monthly Trend",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildMonthlyTrendChart(allTransactions),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Savings Rate
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Savings Rate",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildSavingsRateChart(transactions, totalIncome, totalExpense),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountCard(String title, double amount, Color color, String prefix) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: color),
        ),
        Text(
          "$prefix ${amount.abs().toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseBarChart(List<TransactionModel> transactions) {
    // Group transactions by type
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (income > expense ? income : expense) * 1.2,
          groupsSpace: 12,
          barTouchData: BarTouchData(
            enabled: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Income");
                    case 1:
                      return const Text("Expense");
                    default:
                      return const Text("");
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 10000,
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: income,
                  color: Colors.green,
                  width: 20,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: expense,
                  color: Colors.red,
                  width: 20,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(List<TransactionModel> transactions) {
    // Filter only expenses and group by category
    final expenseTransactions = transactions.where((t) => t.type == 'expense').toList();

    if (expenseTransactions.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No expenses to display")),
      );
    }

    // Group expenses by category and calculate totals
    final categoryTotals = <String, double>{};
    for (final transaction in expenseTransactions) {
      final currentTotal = categoryTotals[transaction.categoryId] ?? 0;
      categoryTotals[transaction.categoryId] = currentTotal + transaction.amount;
    }

    // Create pie chart data
    final pieData = categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        radius: 15,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: pieData,
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendChart(List<TransactionModel> allTransactions) {
    // Group transactions by month for the last 6 months
    final Map<String, Map<String, double>> monthlyData = {};

    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = "${DateFormat('MMM yy').format(month)}";
      monthlyData[monthKey] = {"income": 0, "expense": 0};
    }

    for (final transaction in allTransactions) {
      final monthKey = "${DateFormat('MMM yy').format(DateTime(transaction.date.year, transaction.date.month, 1))}";
      if (monthlyData.containsKey(monthKey)) {
        if (transaction.type == 'income') {
          monthlyData[monthKey]!["income"] = monthlyData[monthKey]!["income"]! + transaction.amount;
        } else {
          monthlyData[monthKey]!["expense"] = monthlyData[monthKey]!["expense"]! + transaction.amount;
        }
      }
    }

    // Prepare chart data
    final lineBarsData = <LineChartBarData>[
      LineChartBarData(
        spots: List.generate(
          monthlyData.length,
          (index) => FlSpot(
            index.toDouble(),
            (monthlyData.values.toList()[index]["income"] ?? 0).toDouble(),
          ),
        ),
        isCurved: true,
        color: Colors.green,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: List.generate(
          monthlyData.length,
          (index) => FlSpot(
            index.toDouble(),
            (monthlyData.values.toList()[index]["expense"] ?? 0).toDouble(),
          ),
        ),
        isCurved: true,
        color: Colors.red,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
    ];

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: true),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10000,
            verticalInterval: 1,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final months = monthlyData.keys.toList();
                  final index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Text(months[index]);
                  }
                  return const Text("");
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          lineBarsData: lineBarsData,
          minX: 0,
          maxX: monthlyData.length - 1,
        ),
      ),
    );
  }

  Widget _buildSavingsRateChart(List<TransactionModel> transactions, double income, double expense) {
    if (income == 0) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No income data to calculate savings rate"),
      );
    }

    double savingsRate = income > 0 ? ((income - expense) / income) * 100 : 0;
    double expenseRate = income > 0 ? (expense / income) * 100 : 0;

    final bars = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: expenseRate,
            color: Colors.red.withValues(alpha: 0.7),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
        barsSpace: 20,
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: savingsRate,
            color: savingsRate >= 0 ? Colors.green.withValues(alpha: 0.7) : Colors.orange.withValues(alpha: 0.7),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
        barsSpace: 20,
      ),
    ];

    return Column(
      children: [
        Text(
          "Savings Rate: ${savingsRate.toStringAsFixed(1)}%",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: savingsRate >= 0 ? Colors.green : Colors.orange,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              maxY: 100,
              minY: -100, // For negative savings
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 25,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text("Expenses");
                        case 1:
                          return const Text("Savings");
                        default:
                          return const Text("");
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: bars,
            ),
          ),
        ),
      ],
    );
  }
}
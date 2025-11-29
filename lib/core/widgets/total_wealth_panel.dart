import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'wealth_chart.dart';

class TotalWealthPanel extends StatelessWidget {
  final String totalAmount;
  final String subtitle;
  final List<FlSpot> chartData;

  const TotalWealthPanel({
    Key? key,
    required this.totalAmount,
    required this.subtitle,
    required this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Wealth label
          const Text(
            "Total Wealth",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          // Big wealth number
          Text(
            "Rp $totalAmount",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          // Chart
          WealthChart(dataPoints: chartData),
        ],
      ),
    );
  }
}
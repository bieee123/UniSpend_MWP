import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WealthChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final String emptyStateText;

  const WealthChart({
    Key? key,
    required this.dataPoints,
    this.emptyStateText = "No Data",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            emptyStateText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 170,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  List<String> months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                  int index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 10,
                      child: Text(
                        months[index],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5000000,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 5,
                    child: Text(
                      'Rp${(value / 1000000).round()}M',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: dataPoints.length - 1 > 0 ? dataPoints.length - 1 : 1,
          minY: 0,
          maxY: dataPoints.isNotEmpty 
              ? (dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2) 
              : 10000000,
          lineBarsData: [
            LineChartBarData(
              spots: dataPoints,
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
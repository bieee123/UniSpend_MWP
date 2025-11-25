import 'package:flutter/material.dart';
import 'pie_chart_component.dart';
import 'category_breakdown_item.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String totalAmount;
  final List<double> amounts;
  final List<Color> colors;
  final List<String> categories;
  final List<String> percentages;

  const SectionCard({
    Key? key,
    required this.title,
    required this.totalAmount,
    required this.amounts,
    required this.colors,
    required this.categories,
    required this.percentages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Rp $totalAmount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Container(
            padding: const EdgeInsets.all(16),
            child: amounts.isEmpty || amounts.every((amount) => amount == 0)
                ? _buildEmptyContent()
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent() {
    return const Center(
      child: Text(
        'No Data',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pie Chart
        Expanded(
          flex: 2,
          child: Center(
            child: PieChartComponent(
              amounts: amounts,
              colors: colors,
              centerText: 'No Data',
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Category List
        Expanded(
          flex: 3,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              if (index < categories.length && 
                  index < amounts.length && 
                  index < colors.length && 
                  index < percentages.length) {
                return CategoryBreakdownItem(
                  name: categories[index],
                  amount: amounts[index].toInt().toString(),
                  percentage: percentages[index],
                  color: colors[index],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
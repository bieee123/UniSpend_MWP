import 'package:flutter/material.dart';
import 'dart:math' as math;

class AtmosphericBudgetDonut extends StatelessWidget {
  final List<BudgetData> budgets;

  const AtmosphericBudgetDonut({
    super.key,
    required this.budgets,
  });

  @override
  Widget build(BuildContext context) {
    // Sort budgets by limit descending to put the largest budget on the outermost ring
    final sortedBudgets = List<BudgetData>.from(budgets)..sort((a, b) => b.limit.compareTo(a.limit));

    // Define ring dimensions
    const ringThickness = 20.0;
    const ringSpacing = 8.0;

    // Calculate the radius for the outermost ring
    final maxRadius = 100.0; // Outermost ring radius
    final minRadius = maxRadius - (sortedBudgets.length * (ringThickness + ringSpacing));

    return Container(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Draw each budget as a concentric ring
          CustomPaint(
            size: const Size(240, 240), // Size of the canvas
            painter: _AtmosphericBudgetPainter(
              budgets: sortedBudgets,
              centerRadius: minRadius > 0 ? minRadius : 20.0, // Ensure a reasonable center radius
              ringThickness: ringThickness,
              ringSpacing: ringSpacing,
            ),
          ),

          // Center icon (could be a wallet or budget-related icon)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF0A7F66), // Emerald Deep Green
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class to hold budget information
class BudgetData {
  final String category;
  final double limit;
  final double spent;

  BudgetData({
    required this.category,
    required this.limit,
    required this.spent,
  });
}

/// Custom painter for the atmospheric budget chart
class _AtmosphericBudgetPainter extends CustomPainter {
  final List<BudgetData> budgets;
  final double centerRadius;
  final double ringThickness;
  final double ringSpacing;

  _AtmosphericBudgetPainter({
    required this.budgets,
    required this.centerRadius,
    required this.ringThickness,
    required this.ringSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Calculate the starting radius for the outermost ring
    double currentRadius = centerRadius + ((budgets.length - 1) * (ringThickness + ringSpacing));

    // Paint each budget as concentric rings from outermost to innermost
    for (int i = 0; i < budgets.length; i++) {
      final budget = budgets[i];
      final color = _getColorForCategory(budget.category);

      // Draw the base arc (total budget capacity)
      final Paint basePaint = Paint()
        ..color = color.withOpacity(0.3)
        ..strokeWidth = ringThickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(
        center,
        currentRadius,
        basePaint,
      );

      // Draw the progress arc (actual spent)
      final progress = budget.limit > 0 ? budget.spent / budget.limit : 0.0;
      final sweepAngle = 2 * math.pi * progress;

      final Paint progressPaint = Paint()
        ..color = color
        ..strokeWidth = ringThickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        -math.pi / 2, // Start from top (12 o'clock position)
        sweepAngle, // Progress angle
        false,
        progressPaint,
      );

      // Move to the inner radius for the next budget ring
      currentRadius -= (ringThickness + ringSpacing);
    }
  }

  // Get color based on category
  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food & drink':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
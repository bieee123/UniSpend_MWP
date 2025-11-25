import 'package:flutter/material.dart';

class PieChartComponent extends StatelessWidget {
  final List<double> amounts;
  final List<Color> colors;
  final String centerText;

  const PieChartComponent({
    Key? key,
    required this.amounts,
    required this.colors,
    this.centerText = "No Data",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (amounts.isEmpty || amounts.every((amount) => amount == 0)) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            centerText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    // Calculate total for percentage calculation
    double total = amounts.reduce((a, b) => a + b);
    
    return CustomPaint(
      size: const Size(150, 150),
      painter: _PieChartPainter(
        amounts: amounts,
        colors: colors,
        total: total,
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> amounts;
  final List<Color> colors;
  final double total;

  _PieChartPainter({
    required this.amounts,
    required this.colors,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Draw center circle (to create donut effect)
    final centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.6, centerCirclePaint);
    
    // Draw pie segments
    double startAngle = -0.5 * 3.14159; // Start from top
    
    for (int i = 0; i < amounts.length; i++) {
      final sweepAngle = (amounts[i] / total) * 2 * 3.14159;
      
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;
      
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
      );
      path.close();
      
      canvas.drawPath(path, paint);
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
import 'package:flutter/material.dart';

/// Ontario driving theme colors
class OntarioColors {
  static const Color blue = Color(0xFF003F8A);       // Ontario blue
  static const Color blueLight = Color(0xFF1A5BA8);
  static const Color blueDark = Color(0xFF002D63);
  static const Color yellow = Color(0xFFFFC107);     // Warning yellow
  static const Color white = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFF5F7FA);
  static const Color lightBlue = Color(0xFFE8F0FB);
  static const Color warmGray = Color(0xFFF0F2F5);

  // Gradient colors
  static const List<Color> blueGradient = [blue, blueLight];
  static const List<Color> softGradient = [Color(0xFFEEF4FF), Color(0xFFF5F7FA)];
  static const List<Color> darkGradient = [Color(0xFF001F44), Color(0xFF002D63)];
}

/// Road painter for subtle background decoration
class RoadPainter extends CustomPainter {
  final Color color;
  final double opacity;

  RoadPainter({
    this.color = OntarioColors.blue,
    this.opacity = 0.04,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha((opacity * 255).toInt())
      ..style = PaintingStyle.fill;

    // Draw subtle road/steering wheel shapes
    _drawSteeringWheel(canvas, paint, Offset(size.width * 0.08, size.height * 0.08), 55);
    _drawSteeringWheel(canvas, paint, Offset(size.width * 0.92, size.height * 0.25), 40);
    _drawSteeringWheel(canvas, paint, Offset(size.width * 0.12, size.height * 0.75), 35);
    _drawSteeringWheel(canvas, paint, Offset(size.width * 0.88, size.height * 0.88), 50);
  }

  void _drawSteeringWheel(Canvas canvas, Paint paint, Offset center, double size) {
    // Outer ring
    canvas.drawCircle(center, size, paint);
    final innerPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size * 0.7, innerPaint);

    // Spokes
    final spokePaint = Paint()
      ..color = paint.color
      ..strokeWidth = size * 0.08
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, center.dy - size * 0.6),
      Offset(center.dx, center.dy + size * 0.6),
      spokePaint,
    );
    canvas.drawLine(
      Offset(center.dx - size * 0.6, center.dy),
      Offset(center.dx + size * 0.6, center.dy),
      spokePaint,
    );
    // Hub
    canvas.drawCircle(center, size * 0.12, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ontario-themed background with subtle decorations
class OntarioBackground extends StatelessWidget {
  final Widget child;
  final bool showDecorations;

  const OntarioBackground({
    super.key,
    required this.child,
    this.showDecorations = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? OntarioColors.darkGradient
              : OntarioColors.softGradient,
        ),
      ),
      child: showDecorations
          ? CustomPaint(
              painter: RoadPainter(
                color: isDark ? Colors.white : OntarioColors.blue,
                opacity: isDark ? 0.03 : 0.04,
              ),
              child: child,
            )
          : child,
    );
  }
}

/// Ontario-themed question card
class OntarioQuestionCard extends StatelessWidget {
  final Widget child;
  final bool isHighlighted;

  const OntarioQuestionCard({
    super.key,
    required this.child,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A3E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: OntarioColors.blue, width: 2)
            : Border.all(
                color: isDark
                    ? Colors.white.withAlpha(25)
                    : OntarioColors.blue.withAlpha(25),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(50)
                : OntarioColors.blue.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Ontario-themed header card (gradient blue)
class OntarioHeaderCard extends StatelessWidget {
  final Widget child;

  const OntarioHeaderCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [OntarioColors.blue, OntarioColors.blueLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: OntarioColors.blue.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.directions_car,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }
}

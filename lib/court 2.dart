import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: TennisCourt(),
      ),
    ),
  ));
}

/// A stateful widget representing the interactive Tennis Court.
class TennisCourt extends StatefulWidget {
  const TennisCourt({Key? key}) : super(key: key);

  @override
  State<TennisCourt> createState() => _TennisCourtState();
}

class _TennisCourtState extends State<TennisCourt> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Court background
        Positioned(
          top: -190,
          left: 0,
          right: 0,
          child: AspectRatio(
            aspectRatio: 56 / 69, // Tennis court standard ratio (width/length)
            child: Container(
              color: const Color(0xFF2D5DA1),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: CourtPainter(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for drawing the tennis court.
class CourtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Basic Paints
    final courtPaint = Paint()
      ..color = const Color(0xFF2D5DA1) // Court blue color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    // Draw the full court background + outer boundary
    final courtRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(courtRect, courtPaint);
    canvas.drawRect(courtRect, linePaint);

    // === Baselines ===
    // Top baseline
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, 0),
      linePaint,
    );
    // Bottom baseline
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      linePaint,
    );

    // === Singles sidelines (27 ft out of 36 ft) ===
    final singlesWidth = size.width * (27 / 36);
    final singlesStartX = (size.width - singlesWidth) / 2;

    // Left singles line
    canvas.drawLine(
      Offset(singlesStartX, 0),
      Offset(singlesStartX, size.height),
      linePaint,
    );
    // Right singles line
    canvas.drawLine(
      Offset(singlesStartX + singlesWidth, 0),
      Offset(singlesStartX + singlesWidth, size.height),
      linePaint,
    );

    // === Net line (in the middle) ===
    final netY = size.height / 2;
    canvas.drawLine(
      Offset(0, netY),
      Offset(size.width, netY),
      linePaint,
    );

    // === Service lines ===
    // Each service line is 21 ft from the net => 18 ft from baseline in a 39 ft half.
    final serviceLineDistance = size.height * (18 / 78);
    final topServiceLineY = serviceLineDistance;
    final bottomServiceLineY = size.height - serviceLineDistance;

    // Top service line
    canvas.drawLine(
      Offset(singlesStartX, topServiceLineY),
      Offset(singlesStartX + singlesWidth, topServiceLineY),
      linePaint,
    );
    // Bottom service line
    canvas.drawLine(
      Offset(singlesStartX, bottomServiceLineY),
      Offset(singlesStartX + singlesWidth, bottomServiceLineY),
      linePaint,
    );

    // === Center service line ===
    // Splits the service boxes from the net down to the service line on each side.
    final centerCourtX = size.width / 2;
    // From net to the top service line
    canvas.drawLine(
      Offset(centerCourtX, netY),
      Offset(centerCourtX, topServiceLineY),
      linePaint,
    );
    // From net to the bottom service line
    canvas.drawLine(
      Offset(centerCourtX, netY),
      Offset(centerCourtX, bottomServiceLineY),
      linePaint,
    );

    // === Center mark on each baseline ===
    // Typically around 4 inches wide in real tennis, we replicate visually.
    const centerMarkHalfWidth = 4.0;
    // Top baseline
    canvas.drawLine(
      Offset(centerCourtX - centerMarkHalfWidth, 0),
      Offset(centerCourtX + centerMarkHalfWidth, 0),
      linePaint,
    );
    // Bottom baseline
    canvas.drawLine(
      Offset(centerCourtX - centerMarkHalfWidth, size.height),
      Offset(centerCourtX + centerMarkHalfWidth, size.height),
      linePaint,
    );

    // === Zone Coloring for Each Service Box (Wide, Body, T) ===
    final zonePaint = Paint()..style = PaintingStyle.fill;

    // ---- BOTTOM HALF (from netY to bottomServiceLineY) ----
    // Only color player 2's side (bottom half)

    // "Wide" Zones (Red)
    zonePaint.color = Colors.red.withOpacity(0.3);
    // Left wide zone
    canvas.drawRect(
      Rect.fromLTRB(
        singlesStartX,
        netY,
        size.width / 4,
        bottomServiceLineY,
      ),
      zonePaint,
    );
    // Right wide zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 3 / 4,
        netY,
        singlesStartX + singlesWidth,
        bottomServiceLineY,
      ),
      zonePaint,
    );

    // "Body" Zones (Green)
    zonePaint.color = Colors.green.withOpacity(0.3);
    // Left body zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width / 4,
        netY,
        size.width * 3 / 8,
        bottomServiceLineY,
      ),
      zonePaint,
    );
    // Right body zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 5 / 8,
        netY,
        size.width * 3 / 4,
        bottomServiceLineY,
      ),
      zonePaint,
    );

    // "T" Zone (Blue)
    zonePaint.color = Colors.blue.withOpacity(0.3);
    // Middle T zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 3 / 8,
        netY,
        size.width * 5 / 8,
        bottomServiceLineY,
      ),
      zonePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    return false;
  }
}

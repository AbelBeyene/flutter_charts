import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: TennisCourt(),
      ),
    ),
  ));
}

/// Represents a single serve with its position and result.
class Serve {
  final Offset position;
  final bool isGoal;

  Serve({required this.position, required this.isGoal});
}

/// A stateful widget representing the interactive Tennis Court.
class TennisCourt extends StatefulWidget {
  const TennisCourt({Key? key}) : super(key: key);

  @override
  State<TennisCourt> createState() => _TennisCourtState();
}

class _TennisCourtState extends State<TennisCourt> {
  /// List of all serves recorded.
  final List<Serve> _serves = [];

  /// Count of successful serves.
  int _goalCount = 0;

  /// Count of failed serves.
  int _failCount = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Court background with tap detection.
        GestureDetector(
          onTapDown: _handleTap,
          child: Container(
            color: const Color(0xFF2D5DA1),
            width: double.infinity,
            height: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: CourtPainter(
                    serves: _serves,
                  ),
                );
              },
            ),
          ),
        ),

        /// Color indicators at the top.
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildColorIndicator(Colors.red, 'Fail'),
              const SizedBox(width: 8),
              _buildColorIndicator(Colors.green, 'Goal'),
            ],
          ),
        ),

        /// Counters at the bottom.
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounter('Goals', _goalCount, Colors.green),
              const SizedBox(width: 16),
              _buildCounter('Fails', _failCount, Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  /// Handles tap events on the court.
  void _handleTap(TapDownDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);
    Size size = box.size;

    // Determine if the tap is within the court boundaries.
    if (!_isWithinCourt(localPosition, size)) return;

    // Determine the zone of the tap.
    String zone = _determineZone(localPosition, size);

    // Classify as goal or fail based on zone.
    bool isGoal = zone != 'Wide'; // For example, 'Body' and 'T' are goals.

    setState(() {
      _serves.add(Serve(position: localPosition, isGoal: isGoal));
      if (isGoal) {
        _goalCount += 1;
      } else {
        _failCount += 1;
      }
    });
  }

  /// Checks if the tap is within the main doubles court area.
  bool _isWithinCourt(Offset pos, Size size) {
    // Assuming court occupies 90% width and height as per the painter.
    double courtWidth = size.width;
    double courtHeight = size.height;

    // You can adjust margins if needed.
    return pos.dx >= 0 &&
        pos.dx <= courtWidth &&
        pos.dy >= 0 &&
        pos.dy <= courtHeight;
  }

  /// Determines which zone the tap is in: Wide, Body, or T.
  String _determineZone(Offset pos, Size size) {
    double courtWidth = size.width;
    double courtHeight = size.height;

    // Define horizontal boundaries based on fractions.
    double wideBoundary = courtWidth / 4;
    double bodyBoundaryLeft = courtWidth * 3 / 8;
    double bodyBoundaryRight = courtWidth * 5 / 8;
    double wideBoundaryRight = courtWidth * 3 / 4;

    if (pos.dx < wideBoundary || pos.dx > wideBoundaryRight) {
      return 'Wide';
    } else if (pos.dx >= bodyBoundaryLeft && pos.dx <= bodyBoundaryRight) {
      return 'T';
    } else {
      return 'Body';
    }
  }

  /// Builds a color indicator with label.
  Widget _buildColorIndicator(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds a counter widget displaying the label and count.
  Widget _buildCounter(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for drawing the tennis court and serve markers.
class CourtPainter extends CustomPainter {
  final List<Serve> serves;

  CourtPainter({required this.serves});

  @override
  void paint(Canvas canvas, Size size) {
    // Basic Paints
    final courtPaint = Paint()
      ..color = const Color(0xFF2D5DA1) // Court blue color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
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

    // ---- TOP HALF (from topServiceLineY to netY) ----

    // "Wide" Zones (Red)
    zonePaint.color = Colors.red.withOpacity(0.3);
    // Left wide zone
    canvas.drawRect(
      Rect.fromLTRB(
        singlesStartX,
        topServiceLineY,
        size.width / 4,
        netY,
      ),
      zonePaint,
    );
    // Right wide zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 3 / 4,
        topServiceLineY,
        singlesStartX + singlesWidth,
        netY,
      ),
      zonePaint,
    );

    // "Body" Zones (Green)
    zonePaint.color = Colors.green.withOpacity(0.3);
    // Left body zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width / 4,
        topServiceLineY,
        size.width * 3 / 8,
        netY,
      ),
      zonePaint,
    );
    // Right body zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 5 / 8,
        topServiceLineY,
        size.width * 3 / 4,
        netY,
      ),
      zonePaint,
    );

    // "T" Zone (Blue)
    zonePaint.color = Colors.blue.withOpacity(0.3);
    // Middle T zone
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 3 / 8,
        topServiceLineY,
        size.width * 5 / 8,
        netY,
      ),
      zonePaint,
    );

    // ---- BOTTOM HALF (from netY to bottomServiceLineY) ----
    // Repeat the same logic but for the bottom side (net to bottom service line).

    // Wide zones (Red)
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

    // Body zones (Green)
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

    // T zone (Blue)
    zonePaint.color = Colors.blue.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 3 / 8,
        netY,
        size.width * 5 / 8,
        bottomServiceLineY,
      ),
      zonePaint,
    );

    // === Serve Markers ===
    for (var serve in serves) {
      _drawServeMarker(canvas, size, serve);
    }
  }

  /// Draws a marker for a serve on the court.
  void _drawServeMarker(Canvas canvas, Size size, Serve serve) {
    final markerPaint = Paint()
      ..color = serve.isGoal ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    // Radius of the marker circle
    const double radius = 8.0;

    canvas.drawCircle(serve.position, radius, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    // Repaint when the list of serves changes.
    return oldDelegate.serves.length != serves.length;
  }
}

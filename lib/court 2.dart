import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Top-level app widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: TennisCourt(),
        ),
      ),
    );
  }
}

/// Enum to represent which side Player 1 is serving from:
/// - `left` = ad side
/// - `right` = deuce side
enum ServeSide { left, right }

/// Represents a position on the tennis court
class CourtPosition {
  final double x;
  final double y;
  final String zoneName;

  CourtPosition(this.x, this.y, this.zoneName);
}

/// A stateful widget representing the interactive Tennis Court.
class TennisCourt extends StatefulWidget {
  const TennisCourt({Key? key}) : super(key: key);

  @override
  State<TennisCourt> createState() => _TennisCourtState();
}

class _TennisCourtState extends State<TennisCourt> {
  /// Current serving side for Player 1 (bottom side).
  ServeSide serveSide = ServeSide.right;

  /// Current ball position
  CourtPosition? ballPosition;

  /// Whether the ball is being dragged
  bool isDragging = false;

  /// Just for demonstration, we toggle the serve side each time the user taps the court.
  void _toggleServeSide() {
    setState(() {
      serveSide =
          serveSide == ServeSide.right ? ServeSide.left : ServeSide.right;
    });
  }

  /// Determines the zone name based on the position
  String _getZoneName(double x, double width, double y, double height) {
    // Determine if we're in the top or bottom half
    String courtSide = y < height / 2 ? "Top" : "Bottom";

    // Determine horizontal position
    String horizontalZone;
    double relativeX = x / width;

    if (relativeX < 0.25) {
      horizontalZone = "Wide";
    } else if (relativeX < 0.375) {
      horizontalZone = "Body";
    } else if (relativeX < 0.625) {
      horizontalZone = "T";
    } else if (relativeX < 0.75) {
      horizontalZone = "Body";
    } else {
      horizontalZone = "Wide";
    }

    return "$courtSide $horizontalZone";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleServeSide,
      child: Stack(
        children: [
          /// Court background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 56 / 69,
              child: Container(
                color: const Color(0xFF2D5DA1),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        CustomPaint(
                          size:
                              Size(constraints.maxWidth, constraints.maxHeight),
                          painter: CourtPainter(
                            serveSide: serveSide,
                            ballPosition: ballPosition,
                          ),
                        ),
                        Positioned.fill(
                          child: GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                isDragging = true;
                                ballPosition = CourtPosition(
                                  details.localPosition.dx,
                                  details.localPosition.dy,
                                  _getZoneName(
                                    details.localPosition.dx,
                                    constraints.maxWidth,
                                    details.localPosition.dy,
                                    constraints.maxHeight,
                                  ),
                                );
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                ballPosition = CourtPosition(
                                  details.localPosition.dx,
                                  details.localPosition.dy,
                                  _getZoneName(
                                    details.localPosition.dx,
                                    constraints.maxWidth,
                                    details.localPosition.dy,
                                    constraints.maxHeight,
                                  ),
                                );
                              });
                            },
                            onPanEnd: (details) {
                              setState(() {
                                isDragging = false;
                              });
                            },
                          ),
                        ),
                        if (ballPosition != null && !isDragging)
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Landing Zone: ${ballPosition!.zoneName}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing the tennis court and highlighting
/// the correct service box on the top half based on `serveSide`.
class CourtPainter extends CustomPainter {
  final ServeSide serveSide;
  final CourtPosition? ballPosition;

  CourtPainter({required this.serveSide, this.ballPosition});

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

    // === Zone Coloring for Service Box ===
    final zonePaint = Paint()..style = PaintingStyle.fill;

    // Get coordinates for service boxes
    final leftServiceBox = Rect.fromLTRB(
      singlesStartX,
      netY,
      centerCourtX,
      bottomServiceLineY,
    );

    final rightServiceBox = Rect.fromLTRB(
      centerCourtX,
      netY,
      singlesStartX + singlesWidth,
      bottomServiceLineY,
    );

    // Determine which service box to color based on serveSide
    final activeServiceBox =
        serveSide == ServeSide.left ? leftServiceBox : rightServiceBox;

    // Calculate zone boundaries within the active service box
    final boxWidth = activeServiceBox.width;
    final zoneWidth = boxWidth / 3; // Divide box into 3 equal parts

    // "Wide" Zone (Red)
    zonePaint.color = Colors.red.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTRB(
        activeServiceBox.left,
        netY,
        activeServiceBox.left + zoneWidth, // One-third of the box width
        bottomServiceLineY,
      ),
      zonePaint,
    );

    // "Body" Zone (Green)
    zonePaint.color = Colors.green.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTRB(
        activeServiceBox.left + zoneWidth, // Start at one-third
        netY,
        activeServiceBox.left + (zoneWidth * 2), // End at two-thirds
        bottomServiceLineY,
      ),
      zonePaint,
    );

    // "T" Zone (Blue)
    zonePaint.color = Colors.blue.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTRB(
        activeServiceBox.left + (zoneWidth * 2), // Start at two-thirds
        netY,
        activeServiceBox.right, // End at the right edge
        bottomServiceLineY,
      ),
      zonePaint,
    );

    // === Highlight the correct TOP service box for Player 1's serve ===
    // Serve rules for singles:
    //   - Right (deuce) side => top-left service box
    //   - Left (ad) side => top-right service box
    final highlightPaint = Paint()
      ..color = Colors.orange.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    if (serveSide == ServeSide.right) {
      // Right side => highlight the top-left box
      final topLeftBox = Rect.fromLTRB(
        singlesStartX,
        topServiceLineY,
        centerCourtX, // halfway horizontally
        netY,
      );
      canvas.drawRect(topLeftBox, highlightPaint);
    } else {
      // Left side => highlight the top-right box
      final topRightBox = Rect.fromLTRB(
        centerCourtX,
        topServiceLineY,
        singlesStartX + singlesWidth,
        netY,
      );
      canvas.drawRect(topRightBox, highlightPaint);
    }

    // Draw the ball if position is set
    if (ballPosition != null) {
      final ballPaint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill;

      final ballStrokePaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Draw ball shadow
      canvas.drawCircle(
        Offset(ballPosition!.x, ballPosition!.y) + const Offset(2, 2),
        10,
        Paint()..color = Colors.black.withOpacity(0.3),
      );

      // Draw ball
      canvas.drawCircle(
        Offset(ballPosition!.x, ballPosition!.y),
        10,
        ballPaint,
      );

      // Draw ball outline
      canvas.drawCircle(
        Offset(ballPosition!.x, ballPosition!.y),
        10,
        ballStrokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    return oldDelegate.serveSide != serveSide ||
        oldDelegate.ballPosition != ballPosition;
  }
}

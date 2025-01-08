import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ForcedForehandError {
  ForcedForehandError({
    required this.total,
    required this.volley,
    required this.slice,
  });

  final int total;
  final int volley;
  final int slice;
}

class ForcedBackhandError {
  ForcedBackhandError({
    required this.total,
    required this.volley,
    required this.slice,
  });

  final int total;
  final int volley;
  final int slice;
}

class ForcedError {
  ForcedError({
    required this.total,
    required this.percentage,
    required this.forehand,
    required this.backhand,
  });

  final int total;
  final int percentage;
  final ForcedForehandError forehand;
  final ForcedBackhandError backhand;
}

class UnforcedForehandError {
  UnforcedForehandError({
    required this.total,
    required this.volley,
    required this.slice,
    required this.swingingVolley,
    required this.dropShot,
  });

  final int total;
  final int volley;
  final int slice;
  final int swingingVolley;
  final int dropShot;
}

class UnforcedBackhandError {
  UnforcedBackhandError({
    required this.total,
    required this.volley,
    required this.slice,
    required this.swingingVolley,
    required this.dropShot,
  });

  final int total;
  final int volley;
  final int slice;
  final int swingingVolley;
  final int dropShot;
}

class UnforcedError {
  UnforcedError({
    required this.total,
    required this.percentage,
    required this.forehand,
    required this.backhand,
  });

  final int total;
  final int percentage;
  final UnforcedForehandError forehand;
  final UnforcedBackhandError backhand;
}

class Errors {
  Errors({
    required this.total,
    required this.forced,
    required this.unforced,
  });

  final int total;
  final ForcedError forced;
  final UnforcedError unforced;
}

class ErrorsChart extends StatefulWidget {
  const ErrorsChart({super.key});

  @override
  State<ErrorsChart> createState() => _ErrorsChartState();
}

class _ErrorsChartState extends State<ErrorsChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late PageController _pageController;
  bool showPlayer1 = true;
  bool showDetails = false;

  final player1Errors = Errors(
    total: 100,
    forced: ForcedError(
      total: 40,
      percentage: 40,
      forehand: ForcedForehandError(
        total: 12,
        volley: 5,
        slice: 7,
      ),
      backhand: ForcedBackhandError(
        total: 28,
        volley: 10,
        slice: 18,
      ),
    ),
    unforced: UnforcedError(
      total: 60,
      percentage: 60,
      forehand: UnforcedForehandError(
        total: 27,
        volley: 8,
        slice: 10,
        swingingVolley: 5,
        dropShot: 4,
      ),
      backhand: UnforcedBackhandError(
        total: 33,
        volley: 12,
        slice: 11,
        swingingVolley: 6,
        dropShot: 4,
      ),
    ),
  );

  final player2Errors = Errors(
    total: 90,
    forced: ForcedError(
      total: 36,
      percentage: 40,
      forehand: ForcedForehandError(
        total: 14,
        volley: 6,
        slice: 8,
      ),
      backhand: ForcedBackhandError(
        total: 22,
        volley: 8,
        slice: 14,
      ),
    ),
    unforced: UnforcedError(
      total: 54,
      percentage: 60,
      forehand: UnforcedForehandError(
        total: 24,
        volley: 7,
        slice: 8,
        swingingVolley: 5,
        dropShot: 4,
      ),
      backhand: UnforcedBackhandError(
        total: 30,
        volley: 10,
        slice: 10,
        swingingVolley: 6,
        dropShot: 4,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _pageController = PageController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Color getErrorTypeColor(bool isForced, bool isForehand) {
    if (isForced) {
      return isForehand ? const Color(0xFF4A90E2) : const Color(0xFF50C878);
    }
    return isForehand ? const Color(0xFFE74C3C) : const Color(0xFFF39C12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Analysis'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerToggle('Player 1', true, const Color(0xFF0984E3)),
                  Container(
                    height: 32,
                    width: 1,
                    color: Colors.grey[200],
                  ),
                  _buildPlayerToggle(
                    'Player 2',
                    false,
                    const Color(0xFF00B894),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: showDetails
                    ? 650
                    : 300, // Increased height to avoid overflow
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      showPlayer1 = index == 0;
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                  children: [
                    _buildErrorCharts(true),
                    _buildErrorCharts(false),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildLegendItem(
                            'Forehand (Forced)',
                            getErrorTypeColor(true, true),
                          ),
                          const SizedBox(width: 16),
                          _buildLegendItem(
                            'Backhand (Forced)',
                            getErrorTypeColor(true, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLegendItem(
                            'Forehand (Unforced)',
                            getErrorTypeColor(false, true),
                          ),
                          const SizedBox(width: 16),
                          _buildLegendItem(
                            'Backhand (Unforced)',
                            getErrorTypeColor(false, false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  icon: Icon(
                    showDetails ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[800],
                  ),
                  label: Text(
                    showDetails ? 'Show Less' : 'Show more Details',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerToggle(String label, bool isPlayer1, Color color) {
    final selected = this.showPlayer1 == isPlayer1;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            this.showPlayer1 = isPlayer1;
            _pageController.animateToPage(
              isPlayer1 ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
            _animationController.reset();
            _animationController.forward();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : Colors.grey[300]!,
              width: 2,
            ),
            color: selected ? color.withOpacity(0.1) : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? color : Colors.grey[600],
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCharts(bool isPlayer1) {
    final errors = isPlayer1 ? player1Errors : player2Errors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      'Forced Errors',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        response == null ||
                                        response.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = response
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              sectionsSpace: 3,
                              centerSpaceRadius: 35,
                              sections: [
                                PieChartSectionData(
                                  color: getErrorTypeColor(true, true),
                                  value:
                                      errors.forced.forehand.total.toDouble(),
                                  title:
                                      '${(errors.forced.forehand.total * 100 / errors.forced.total).round()}%',
                                  radius: touchedIndex == 0 ? 60 : 50,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: getErrorTypeColor(true, false),
                                  value:
                                      errors.forced.backhand.total.toDouble(),
                                  title:
                                      '${(errors.forced.backhand.total * 100 / errors.forced.total).round()}%',
                                  radius: touchedIndex == 1 ? 60 : 50,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (showDetails) ...[
                      const SizedBox(height: 16),
                      _buildErrorDetails(
                        errors.forced.forehand.volley,
                        errors.forced.forehand.slice,
                        null,
                        null,
                        true,
                        getErrorTypeColor(true, true),
                      ),
                      const SizedBox(height: 8),
                      _buildErrorDetails(
                        errors.forced.backhand.volley,
                        errors.forced.backhand.slice,
                        null,
                        null,
                        false,
                        getErrorTypeColor(true, false),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      'Unforced Errors',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        response == null ||
                                        response.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = response
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              sectionsSpace: 3,
                              centerSpaceRadius: 35,
                              sections: [
                                PieChartSectionData(
                                  color: getErrorTypeColor(false, true),
                                  value:
                                      errors.unforced.forehand.total.toDouble(),
                                  title:
                                      '${(errors.unforced.forehand.total * 100 / errors.unforced.total).round()}%',
                                  radius: touchedIndex == 0 ? 60 : 50,
                                  titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                PieChartSectionData(
                                  color: getErrorTypeColor(false, false),
                                  value:
                                      errors.unforced.backhand.total.toDouble(),
                                  title:
                                      '${(errors.unforced.backhand.total * 100 / errors.unforced.total).round()}%',
                                  radius: touchedIndex == 1 ? 60 : 50,
                                  titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (showDetails) ...[
                      const SizedBox(height: 16),
                      _buildErrorDetails(
                        errors.unforced.forehand.volley,
                        errors.unforced.forehand.slice,
                        errors.unforced.forehand.swingingVolley,
                        errors.unforced.forehand.dropShot,
                        true,
                        getErrorTypeColor(false, true),
                      ),
                      const SizedBox(height: 3),
                      _buildErrorDetails(
                        errors.unforced.backhand.volley,
                        errors.unforced.backhand.slice,
                        errors.unforced.backhand.swingingVolley,
                        errors.unforced.backhand.dropShot,
                        false,
                        getErrorTypeColor(false, false),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorDetails(int volley, int slice, int? swingingVolley,
      int? dropShot, bool isForehand, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isForehand ? 'Forehand Details' : 'Backhand Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Volley', volley, color),
          _buildDetailRow('Slice', slice, color),
          if (swingingVolley != null)
            _buildDetailRow('Swinging Volley', swingingVolley, color),
          if (dropShot != null) _buildDetailRow('Drop Shot', dropShot, color),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BreakPoints {
  final int total;
  final int saved;
  final int savedPercentage;
  final int converted;
  final int convertedPercentage;

  // Remove body from const constructor and add assertions to constructor initializer list
  const BreakPoints({
    required this.total,
    required this.saved,
    required this.savedPercentage,
    required this.converted,
    required this.convertedPercentage,
  })  : assert(total >= 0, 'Total must be non-negative'),
        assert(savedPercentage >= 0 && savedPercentage <= 100,
            'Saved percentage must be between 0 and 100'),
        assert(convertedPercentage >= 0 && convertedPercentage <= 100,
            'Converted percentage must be between 0 and 100');
}

class GamePoints {
  final int total;
  final int saved;
  final int savedPercentage;
  final int converted;
  final int convertedPercentage;

  // Remove body from const constructor and add assertions to constructor initializer list
  const GamePoints({
    required this.total,
    required this.saved,
    required this.savedPercentage,
    required this.converted,
    required this.convertedPercentage,
  })  : assert(total >= 0, 'Total must be non-negative'),
        assert(savedPercentage >= 0 && savedPercentage <= 100,
            'Saved percentage must be between 0 and 100'),
        assert(convertedPercentage >= 0 && convertedPercentage <= 100,
            'Converted percentage must be between 0 and 100');
}

class BreakPointsRadarChart extends StatefulWidget {
  final bool showPercentages;
  final BreakPoints breakPoints;
  final GamePoints gamePoints;
  final BreakPoints player2BreakPoints;
  final GamePoints player2GamePoints;

  const BreakPointsRadarChart({
    super.key,
    this.showPercentages = false,
    this.breakPoints = const BreakPoints(
      total: 100,
      saved: 10,
      savedPercentage: 65,
      converted: 75,
      convertedPercentage: 75,
    ),
    this.gamePoints = const GamePoints(
      total: 100,
      saved: 45,
      savedPercentage: 80,
      converted: 90,
      convertedPercentage: 90,
    ),
    this.player2BreakPoints = const BreakPoints(
      total: 100,
      saved: 44,
      savedPercentage: 70,
      converted: 50,
      convertedPercentage: 80,
    ),
    this.player2GamePoints = const GamePoints(
      total: 100,
      saved: 85,
      savedPercentage: 85,
      converted: 10,
      convertedPercentage: 45,
    ),
  });

  @override
  State<BreakPointsRadarChart> createState() => _BreakPointsRadarChartState();
}

class _BreakPointsRadarChartState extends State<BreakPointsRadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;
  bool showPlayer1 = true;
  bool showPercentages = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Player Switch
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: showPlayer1 ? Colors.blue : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !showPlayer1 ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // PageView for charts
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      showPlayer1 ? 'Player 1' : 'Player 2',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(
                          value: false,
                          label: Text('Points'),
                        ),
                        ButtonSegment<bool>(
                          value: true,
                          label: Text('Percentage'),
                        ),
                      ],
                      selected: {showPercentages},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          showPercentages = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        showPlayer1 = index == 0;
                      });
                    },
                    children: [
                      _buildPlayerChart(
                        widget.breakPoints,
                        widget.gamePoints,
                        'Player 1',
                      ),
                      _buildPlayerChart(
                        widget.player2BreakPoints,
                        widget.player2GamePoints,
                        'Player 2',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerChart(
      BreakPoints breakPoints, GamePoints gamePoints, String playerName) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Points Pie Chart

              // Radar Chart
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 350,
                  width: 300,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Opacity(
                          opacity: _animation.value,
                          child: RadarChart(
                            RadarChartData(
                              radarTouchData: RadarTouchData(
                                touchCallback: (FlTouchEvent event, response) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        response == null ||
                                        response.touchedSpot == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                  });
                                },
                              ),
                              dataSets: [
                                RadarDataSet(
                                  dataEntries: [
                                    RadarEntry(value: 0),
                                    RadarEntry(
                                        value: showPercentages
                                            ? breakPoints.convertedPercentage
                                                .toDouble()
                                            : breakPoints.converted.toDouble()),
                                    RadarEntry(
                                        value: showPercentages
                                            ? gamePoints.savedPercentage
                                                .toDouble()
                                            : gamePoints.saved.toDouble()),
                                    RadarEntry(
                                        value: showPercentages
                                            ? gamePoints.convertedPercentage
                                                .toDouble()
                                            : gamePoints.converted.toDouble()),
                                  ],
                                  fillColor: Colors.blue.withOpacity(0.2),
                                  borderColor: Colors.blue,
                                  borderWidth: 2,
                                ),
                              ],
                              tickCount: 5,
                              ticksTextStyle: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                              radarBorderData: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                              gridBorderData: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                              titleTextStyle: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              getTitle: (index, angle) {
                                switch (index) {
                                  case 0:
                                    return RadarChartTitle(text: 'BP Saved');
                                  case 1:
                                    return RadarChartTitle(text: 'BP Conv.');
                                  case 2:
                                    return RadarChartTitle(text: 'GP Saved');
                                  case 3:
                                    return RadarChartTitle(text: 'GP Conv.');
                                  default:
                                    return RadarChartTitle(text: '');
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                            'B - Points Saved',
                            const Color(0xFF4A90E2),
                            breakPoints.savedPercentage),
                        const SizedBox(height: 8),
                        _buildLegendItem(
                            'B- Points Converted',
                            const Color(0xFF50C878),
                            breakPoints.convertedPercentage),
                        const SizedBox(height: 8),
                        _buildLegendItem('G Points Saved', Colors.red,
                            gamePoints.savedPercentage),
                        const SizedBox(height: 8),
                        _buildLegendItem(
                            'G- Points Converted',
                            const Color(0xFF9B59B6),
                            gamePoints.convertedPercentage),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 96,
                        child: Row(
                          children: [
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.center,
                                  maxY: max(
                                          widget.breakPoints.total.toDouble(),
                                          widget.player2BreakPoints.total
                                              .toDouble()) *
                                      1.2,
                                  titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(show: false),
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                          toY: widget.breakPoints.total
                                              .toDouble(),
                                          color: Colors.blue,
                                          width: 16,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ],
                                      showingTooltipIndicators: [0],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                          toY: widget.player2BreakPoints.total
                                              .toDouble(),
                                          color: Colors.red,
                                          width: 16,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ],
                                      showingTooltipIndicators: [0],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // height: 20,
                            // width: 20,
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("P1     ",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                    Text("P2",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                Text("Total"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color, int percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

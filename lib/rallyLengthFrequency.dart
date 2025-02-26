import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RallyLengthFrequency {
  final int oneToFour;
  final int fiveToEight;
  final int nineToTwelve;
  final int thirteenToTwenty;
  final int twentyOnePlus;

  const RallyLengthFrequency({
    required this.oneToFour,
    required this.fiveToEight,
    required this.nineToTwelve,
    required this.thirteenToTwenty,
    required this.twentyOnePlus,
  });

  int get total =>
      oneToFour + fiveToEight + nineToTwelve + thirteenToTwenty + twentyOnePlus;

  double getPercentage(int value) {
    return (value / total) * 100;
  }
}

class RallyLengthFrequencyChart extends StatefulWidget {
  final RallyLengthFrequency rallyLength;
  final RallyLengthFrequency player2RallyLength;

  const RallyLengthFrequencyChart({
    super.key,
    this.rallyLength = const RallyLengthFrequency(
      oneToFour: 40,
      fiveToEight: 30,
      nineToTwelve: 15,
      thirteenToTwenty: 10,
      twentyOnePlus: 5,
    ),
    this.player2RallyLength = const RallyLengthFrequency(
      oneToFour: 35,
      fiveToEight: 35,
      nineToTwelve: 15,
      thirteenToTwenty: 10,
      twentyOnePlus: 5,
    ),
  });

  @override
  State<RallyLengthFrequencyChart> createState() =>
      _RallyLengthFrequencyChartState();
}

class _RallyLengthFrequencyChartState extends State<RallyLengthFrequencyChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;
  bool showPlayer1 = true;
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
          Expanded(
            child: Column(
              children: [
                Text(
                  showPlayer1 ? 'Player 1' : 'Player 2',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                        widget.rallyLength,
                        'Player 1',
                      ),
                      _buildPlayerChart(
                        widget.player2RallyLength,
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
      RallyLengthFrequency rallyLength, String playerName) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
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
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 100,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  // tooltipBackgroundColor: Colors.blueGrey,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '${rod.toY.round()}%',
                                      const TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const titles = [
                                        '1-4',
                                        '5-8',
                                        '9-12',
                                        '13-20',
                                        '21+'
                                      ];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          titles[value.toInt()],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.withOpacity(0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                _generateBarGroup(
                                    0,
                                    rallyLength
                                        .getPercentage(rallyLength.oneToFour),
                                    Colors.blue),
                                _generateBarGroup(
                                    1,
                                    rallyLength
                                        .getPercentage(rallyLength.fiveToEight),
                                    const Color(0xFF50C878)),
                                _generateBarGroup(
                                    2,
                                    rallyLength.getPercentage(
                                        rallyLength.nineToTwelve),
                                    Colors.red),
                                _generateBarGroup(
                                    3,
                                    rallyLength.getPercentage(
                                        rallyLength.thirteenToTwenty),
                                    const Color(0xFF9B59B6)),
                                _generateBarGroup(
                                    4,
                                    rallyLength.getPercentage(
                                        rallyLength.twentyOnePlus),
                                    Colors.orange),
                              ],
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
            width: double.infinity,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Rally Length',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('1-4 Shots', const Color(0xFF4A90E2),
                            rallyLength.oneToFour),
                        const SizedBox(height: 8),
                        _buildLegendItem('5-8 Shots', const Color(0xFF50C878),
                            rallyLength.fiveToEight),
                        const SizedBox(height: 8),
                        _buildLegendItem(
                            '9-12 Shots', Colors.red, rallyLength.nineToTwelve),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('13-20 Shots', const Color(0xFF9B59B6),
                            rallyLength.thirteenToTwenty),
                        const SizedBox(height: 8),
                        _buildLegendItem('21+ Shots', Colors.orange,
                            rallyLength.twentyOnePlus),
                        const SizedBox(height: 8),
                        _buildLegendItem(
                            'Total', Colors.grey.shade800, rallyLength.total),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _generateBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color, int value) {
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
            '$value',
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

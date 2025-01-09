import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Winners {
  final int total;
  final int percentage;
  final int forehand;
  final int backhand;
  final int returnForehand;
  final int returnBackhand;
  final bool isPlayer1;

  Winners({
    required this.total,
    required this.percentage,
    required this.forehand,
    required this.backhand,
    required this.returnForehand,
    required this.returnBackhand,
    required this.isPlayer1,
  }) {
    assert(total >= 0, 'Total must be non-negative');
    assert(percentage >= 0 && percentage <= 100,
        'Percentage must be between 0 and 100');
    assert(forehand >= 0, 'Forehand must be non-negative');
    assert(backhand >= 0, 'Backhand must be non-negative');
    assert(returnForehand >= 0, 'Return forehand must be non-negative');
    assert(returnBackhand >= 0, 'Return backhand must be non-negative');
  }

  Map<String, double> getPercentages() {
    final total = forehand + backhand + returnForehand + returnBackhand;
    if (total == 0) {
      return {
        'forehand': 0,
        'backhand': 0,
        'returnForehand': 0,
        'returnBackhand': 0,
      };
    }
    return {
      'forehand': (forehand / total * 100),
      'backhand': (backhand / total * 100),
      'returnForehand': (returnForehand / total * 100),
      'returnBackhand': (returnBackhand / total * 100),
    };
  }
}

class WinnersChart extends StatefulWidget {
  const WinnersChart({super.key});

  @override
  State<WinnersChart> createState() => _WinnersChartState();
}

class _WinnersChartState extends State<WinnersChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  bool showPercentages = false;
  Set<String> selectedMetrics = {
    'total',
    'forehand',
    'backhand',
    'returnForehand',
    'returnBackhand'
  };
  late AnimationController _animationController;
  late Animation<double> _animation;
  late PageController _pageController;
  bool showPlayer1 = true;

  Color getMetricColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFF9F43);
      case 1:
        return const Color(0xFF6C5CE7);
      case 2:
        return const Color(0xFF00B894);
      case 3:
        return const Color(0xFFFF6B6B);
      case 4:
        return const Color(0xFF4834D4);
      default:
        return const Color(0xFF0984E3);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor =
        showPlayer1 ? const Color(0xFF0984E3) : const Color(0xFF00B894);

    Winners data = Winners(
      total: showPlayer1 ? 100 : 80,
      percentage: showPlayer1 ? 75 : 65,
      forehand: showPlayer1 ? 40 : 35,
      backhand: showPlayer1 ? 30 : 25,
      returnForehand: showPlayer1 ? 15 : 10,
      returnBackhand: showPlayer1 ? 15 : 10,
      isPlayer1: showPlayer1,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Performance Analytics',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerStats(
                        'Player 1',
                        100,
                        75,
                        const Color(0xFF0984E3),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey[200],
                      ),
                      _buildPlayerStats(
                        'Player 2',
                        80,
                        65,
                        const Color(0xFF00B894),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProgressBar(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerToggle(
                        'Player 1',
                        true,
                        const Color(0xFF0984E3),
                      ),
                      Container(
                        height: 24,
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shot Types',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (!showPercentages)
                          _buildIndicator('Total', getMetricColor(0)),
                        _buildIndicator('Forehand', getMetricColor(1)),
                        _buildIndicator('Backhand', getMetricColor(2)),
                        _buildIndicator('Return F.', getMetricColor(3)),
                        _buildIndicator('Return B.', getMetricColor(4)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
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
                          _buildChart(true),
                          _buildChart(false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildDetailCard('Total', data.total, 100, getMetricColor(0)),
                  _buildDetailCard('Forehand', data.forehand,
                      data.getPercentages()['forehand']!, getMetricColor(1)),
                  _buildDetailCard('Backhand', data.backhand,
                      data.getPercentages()['backhand']!, getMetricColor(2)),
                  _buildDetailCard(
                      'Return Forehand',
                      data.returnForehand,
                      data.getPercentages()['returnForehand']!,
                      getMetricColor(3)),
                  _buildDetailCard(
                      'Return Backhand',
                      data.returnBackhand,
                      data.getPercentages()['returnBackhand']!,
                      getMetricColor(4)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      String title, int value, double percentage, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.36, // Reduced from 0.45
      padding: const EdgeInsets.all(10), // Reduced from 12
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Reduced from 12
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6, // Reduced from 8
            offset: const Offset(0, 2), // Reduced from 3
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10, // Reduced from 12
                height: 10, // Reduced from 12
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6), // Reduced from 8
              Text(
                title,
                style: TextStyle(
                  fontSize: 11, // Reduced from 14
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced from 12
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value points',
                style: const TextStyle(
                  fontSize: 13, // Reduced from 16
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11, // Reduced from 14
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStats(String label, int total, int winRate, Color color) {
    final Color lightBlue = const Color(0xFF87CEEB);
    final Color lightOrange = const Color(0xFFFFB347);

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: label == 'Player 1' ? lightBlue : lightOrange,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total: $total',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: (label == 'Player 1' ? lightBlue : lightOrange)
                .withOpacity(0.9),
            letterSpacing: 0.3,
          ),
        ),
        Text(
          'Win Rate: $winRate%',
          style: TextStyle(
            fontSize: 12,
            color: (label == 'Player 1' ? lightBlue : lightOrange)
                .withOpacity(0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF87CEEB).withOpacity(0.95),
            const Color(0xFFFFB347).withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.25),
              ),
              minHeight: 36,
            ),
            Center(
              child: Text(
                'Win Rate Comparison',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(bool isPlayer1) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14159,
              child: Opacity(
                opacity: _animation.value.clamp(0.0, 1.0),
                child: PieChart(
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
                          touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 35,
                    sections: showingSections(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayerToggle(String label, bool isPlayer1, Color color) {
    final selected = this.showPlayer1 == isPlayer1;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? color : Colors.grey[300]!,
              width: 1.5,
            ),
            color: selected ? color.withOpacity(0.1) : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? color : Colors.grey[600],
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    Winners data = Winners(
      total: showPlayer1 ? 100 : 80,
      percentage: showPlayer1 ? 75 : 65,
      forehand: showPlayer1 ? 40 : 35,
      backhand: showPlayer1 ? 30 : 25,
      returnForehand: showPlayer1 ? 15 : 10,
      returnBackhand: showPlayer1 ? 15 : 10,
      isPlayer1: showPlayer1,
    );

    final percentages = data.getPercentages();
    List<PieChartSectionData> sections = [];

    if (selectedMetrics.contains('total') && !showPercentages) {
      sections.add(PieChartSectionData(
        color: getMetricColor(0),
        value: data.total.toDouble(),
        title: showPercentages ? '${data.percentage}%' : '${data.total}',
        radius: touchedIndex == 0 ? 85.0 : 75.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 16.0 : 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ));
    }

    if (selectedMetrics.contains('forehand')) {
      sections.add(PieChartSectionData(
        color: getMetricColor(1),
        value: data.forehand.toDouble(),
        title: showPercentages
            ? '${percentages['forehand']?.toStringAsFixed(1)}%'
            : '${data.forehand}',
        radius: touchedIndex == 1 ? 85.0 : 75.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 16.0 : 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ));
    }

    if (selectedMetrics.contains('backhand')) {
      sections.add(PieChartSectionData(
        color: getMetricColor(2),
        value: data.backhand.toDouble(),
        title: showPercentages
            ? '${percentages['backhand']?.toStringAsFixed(1)}%'
            : '${data.backhand}',
        radius: touchedIndex == 2 ? 85.0 : 75.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 2 ? 16.0 : 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ));
    }

    if (selectedMetrics.contains('returnForehand')) {
      sections.add(PieChartSectionData(
        color: getMetricColor(3),
        value: data.returnForehand.toDouble(),
        title: showPercentages
            ? '${percentages['returnForehand']?.toStringAsFixed(1)}%'
            : '${data.returnForehand}',
        radius: touchedIndex == 3 ? 85.0 : 75.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 3 ? 16.0 : 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ));
    }

    if (selectedMetrics.contains('returnBackhand')) {
      sections.add(PieChartSectionData(
        color: getMetricColor(4),
        value: data.returnBackhand.toDouble(),
        title: showPercentages
            ? '${percentages['returnBackhand']?.toStringAsFixed(1)}%'
            : '${data.returnBackhand}',
        radius: touchedIndex == 4 ? 85.0 : 75.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 4 ? 16.0 : 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ));
    }

    return sections;
  }

  Widget _buildIndicator(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

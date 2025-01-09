import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/servePlacementChart.dart';

class ReturnPlacement {
  ReturnPlacement({
    required this.firstServe,
    required this.firstServeForhand,
    required this.firstServeBackhand,
    required this.secondServe,
    required this.secondServeForhand,
    required this.secondServeBackhand,
  });
  final ServePlacement firstServe;
  final ServePlacement firstServeForhand;
  final ServePlacement firstServeBackhand;
  final ServePlacement secondServe;
  final ServePlacement secondServeForhand;
  final ServePlacement secondServeBackhand;
}

class ReturnPlacementChart extends StatefulWidget {
  const ReturnPlacementChart({super.key});

  @override
  State<ReturnPlacementChart> createState() => _ReturnPlacementChartState();
}

class _ReturnPlacementChartState extends State<ReturnPlacementChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final PageController _pageController = PageController();

  // Dummy data
  late final ReturnPlacement player1Placement;
  late final ReturnPlacement player2Placement;
  final String player1Name = 'Player 1';
  final String player2Name = 'Player 2';

  @override
  void initState() {
    super.initState();
    // Initialize dummy data
    player1Placement = ReturnPlacement(
      firstServe: ServePlacement(
        wide: 30,
        body: 40,
        tee: 30,
        total: 100,
        widePercentage: 30,
        bodyPercentage: 40,
        teePercentage: 30,
      ),
      firstServeForhand: ServePlacement(
        wide: 35,
        body: 35,
        tee: 30,
        total: 100,
        widePercentage: 35,
        bodyPercentage: 35,
        teePercentage: 30,
      ),
      firstServeBackhand: ServePlacement(
        wide: 25,
        body: 45,
        tee: 30,
        total: 100,
        widePercentage: 25,
        bodyPercentage: 45,
        teePercentage: 30,
      ),
      secondServe: ServePlacement(
        wide: 20,
        body: 50,
        tee: 30,
        total: 100,
        widePercentage: 20,
        bodyPercentage: 50,
        teePercentage: 30,
      ),
      secondServeForhand: ServePlacement(
        wide: 25,
        body: 45,
        tee: 30,
        total: 100,
        widePercentage: 25,
        bodyPercentage: 45,
        teePercentage: 30,
      ),
      secondServeBackhand: ServePlacement(
        wide: 15,
        body: 55,
        tee: 30,
        total: 100,
        widePercentage: 15,
        bodyPercentage: 55,
        teePercentage: 30,
      ),
    );

    player2Placement = ReturnPlacement(
      firstServe: ServePlacement(
        wide: 35,
        body: 35,
        tee: 30,
        total: 100,
        widePercentage: 35,
        bodyPercentage: 35,
        teePercentage: 30,
      ),
      firstServeForhand: ServePlacement(
        wide: 40,
        body: 30,
        tee: 30,
        total: 100,
        widePercentage: 40,
        bodyPercentage: 30,
        teePercentage: 30,
      ),
      firstServeBackhand: ServePlacement(
        wide: 30,
        body: 40,
        tee: 30,
        total: 100,
        widePercentage: 30,
        bodyPercentage: 40,
        teePercentage: 30,
      ),
      secondServe: ServePlacement(
        wide: 25,
        body: 45,
        tee: 30,
        total: 100,
        widePercentage: 25,
        bodyPercentage: 45,
        teePercentage: 30,
      ),
      secondServeForhand: ServePlacement(
        wide: 30,
        body: 40,
        tee: 30,
        total: 100,
        widePercentage: 30,
        bodyPercentage: 40,
        teePercentage: 30,
      ),
      secondServeBackhand: ServePlacement(
        wide: 20,
        body: 50,
        tee: 30,
        total: 100,
        widePercentage: 20,
        bodyPercentage: 50,
        teePercentage: 30,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStatContainer(String label, int value,
      {bool isPercentage = false, Color color = Colors.blue}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            '$value${isPercentage ? '%' : ''}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPage(
      ReturnPlacement placement, String playerName, Color color) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            playerName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 350,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 20,
                          verticalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                const titles = ['Wide', 'Body', 'Tee'];
                                if (value.toInt() < 0 ||
                                    value.toInt() >= titles.length) {
                                  return const Text('');
                                }
                                return Text(
                                  titles[value.toInt()],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        minX: 0,
                        maxX: 2,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(
                                  0,
                                  placement.firstServe.wide.toDouble() *
                                      _animation.value),
                              FlSpot(
                                  1,
                                  placement.firstServe.body.toDouble() *
                                      _animation.value),
                              FlSpot(
                                  2,
                                  placement.firstServe.tee.toDouble() *
                                      _animation.value),
                            ],
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [color.withOpacity(0.5), color],
                            ),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: color,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  color.withOpacity(0.2),
                                  color.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildStatContainer(
                  'Total Returns',
                  placement.firstServe.total,
                  color: color,
                ),
                _buildStatContainer(
                  'Wide Returns',
                  placement.firstServe.wide,
                  color: color,
                ),
                _buildStatContainer(
                  'Wide Returns %',
                  placement.firstServe.widePercentage,
                  isPercentage: true,
                  color: color,
                ),
                _buildStatContainer(
                  'Body Returns',
                  placement.firstServe.body,
                  color: color,
                ),
                _buildStatContainer(
                  'Body Returns %',
                  placement.firstServe.bodyPercentage,
                  isPercentage: true,
                  color: color,
                ),
                _buildStatContainer(
                  'Tee Returns',
                  placement.firstServe.tee,
                  color: color,
                ),
                _buildStatContainer(
                  'Tee Returns %',
                  placement.firstServe.teePercentage,
                  isPercentage: true,
                  color: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _pageController.hasClients &&
                          _pageController.page?.round() == 0
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _pageController.hasClients &&
                          _pageController.page?.round() == 1
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              _buildPlayerPage(player1Placement, player1Name, Colors.blue),
              _buildPlayerPage(player2Placement, player2Name, Colors.red),
            ],
          ),
        ),
      ],
    );
  }
}

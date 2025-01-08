import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ServePlacement {
  final int total;
  final int wide;
  final int widePercentage;
  final int body;
  final int bodyPercentage;
  final int tee;
  final int teePercentage;

  const ServePlacement({
    required this.total,
    required this.wide,
    required this.widePercentage,
    required this.body,
    required this.bodyPercentage,
    required this.tee,
    required this.teePercentage,
  });
}

class ServePlacementChart extends StatefulWidget {
  final bool showPercentages;
  final ServePlacement player1Placement;
  final ServePlacement player2Placement;
  final String player1Name;
  final String player2Name;
  final Function(bool)? onTogglePercentages;

  const ServePlacementChart({
    super.key,
    this.showPercentages = false,
    this.player1Placement = const ServePlacement(
      total: 100,
      wide: 30,
      widePercentage: 30,
      body: 45,
      bodyPercentage: 45,
      tee: 25,
      teePercentage: 25,
    ),
    this.player2Placement = const ServePlacement(
      total: 90,
      wide: 25,
      widePercentage: 28,
      body: 40,
      bodyPercentage: 44,
      tee: 25,
      teePercentage: 28,
    ),
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.onTogglePercentages,
  });

  @override
  State<ServePlacementChart> createState() => _ServePlacementChartState();
}

class _ServePlacementChartState extends State<ServePlacementChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late bool _showPercentages;
  int? _tooltipIndex;
  String? _tooltipText;
  bool _showPlayer1 = true;
  bool _showPlayer2 = true;

  @override
  void initState() {
    super.initState();
    _showPercentages = widget.showPercentages;
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
    super.dispose();
  }

  String _getTooltipText(int index, bool isPlayer1) {
    final placement =
        isPlayer1 ? widget.player1Placement : widget.player2Placement;
    final value = _showPercentages
        ? switch (index) {
            0 => placement.widePercentage,
            1 => placement.bodyPercentage,
            _ => placement.teePercentage,
          }
        : switch (index) {
            0 => placement.wide,
            1 => placement.body,
            _ => placement.tee,
          };
    return '${isPlayer1 ? widget.player1Name : widget.player2Name}: $value${_showPercentages ? '%' : ''}';
  }

  Widget _buildStatContainer(String label, int value1, int value2,
      {bool isPercentage = false}) {
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
          Row(
            children: [
              Text(
                '$value1${isPercentage ? '%' : ''}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(' / '),
              Text(
                '$value2${isPercentage ? '%' : ''}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Points',
                  style: TextStyle(
                    color: !_showPercentages
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _showPercentages,
                  onChanged: (value) {
                    setState(() {
                      _showPercentages = value;
                    });
                    if (widget.onTogglePercentages != null) {
                      widget.onTogglePercentages!(value);
                    }
                  },
                ),
                Text(
                  'Percentages',
                  style: TextStyle(
                    color: _showPercentages
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
                          if (_showPlayer1)
                            LineChartBarData(
                              spots: [
                                FlSpot(
                                    0,
                                    _showPercentages
                                        ? widget.player1Placement.widePercentage
                                            .toDouble()
                                        : widget.player1Placement.wide
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    1,
                                    _showPercentages
                                        ? widget.player1Placement.bodyPercentage
                                            .toDouble()
                                        : widget.player1Placement.body
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    2,
                                    _showPercentages
                                        ? widget.player1Placement.teePercentage
                                            .toDouble()
                                        : widget.player1Placement.tee
                                                .toDouble() *
                                            _animation.value),
                              ],
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.5),
                                  Colors.blue
                                ],
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
                                    strokeColor: Colors.blue,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.2),
                                    Colors.blue.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          if (_showPlayer2)
                            LineChartBarData(
                              spots: [
                                FlSpot(
                                    0,
                                    _showPercentages
                                        ? widget.player2Placement.widePercentage
                                            .toDouble()
                                        : widget.player2Placement.wide
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    1,
                                    _showPercentages
                                        ? widget.player2Placement.bodyPercentage
                                            .toDouble()
                                        : widget.player2Placement.body
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    2,
                                    _showPercentages
                                        ? widget.player2Placement.teePercentage
                                            .toDouble()
                                        : widget.player2Placement.tee
                                                .toDouble() *
                                            _animation.value),
                              ],
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.withOpacity(0.5),
                                  Colors.red
                                ],
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
                                    strokeColor: Colors.red,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.withOpacity(0.2),
                                    Colors.red.withOpacity(0.0),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showPlayer1 = !_showPlayer1),
                  child: _buildLegendItem(
                    widget.player1Name,
                    Colors.blue,
                    isActive: _showPlayer1,
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () => setState(() => _showPlayer2 = !_showPlayer2),
                  child: _buildLegendItem(
                    widget.player2Name,
                    Colors.red,
                    isActive: _showPlayer2,
                  ),
                ),
              ],
            ),
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
                    'Total Serves',
                    widget.player1Placement.total,
                    widget.player2Placement.total),
                _buildStatContainer('Wide', widget.player1Placement.wide,
                    widget.player2Placement.wide),
                _buildStatContainer(
                    'Wide %',
                    widget.player1Placement.widePercentage,
                    widget.player2Placement.widePercentage,
                    isPercentage: true),
                _buildStatContainer('Body', widget.player1Placement.body,
                    widget.player2Placement.body),
                _buildStatContainer(
                    'Body %',
                    widget.player1Placement.bodyPercentage,
                    widget.player2Placement.bodyPercentage,
                    isPercentage: true),
                _buildStatContainer('Tee', widget.player1Placement.tee,
                    widget.player2Placement.tee),
                _buildStatContainer(
                    'Tee %',
                    widget.player1Placement.teePercentage,
                    widget.player2Placement.teePercentage,
                    isPercentage: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color, {bool isActive = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: isActive
                ? color.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: isActive ? color.withOpacity(0.2) : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? color : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isActive ? color.withOpacity(0.3) : Colors.transparent,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? color : Colors.grey,
              shadows: [
                Shadow(
                  color: isActive ? color.withOpacity(0.3) : Colors.transparent,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

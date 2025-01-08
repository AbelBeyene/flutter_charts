import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Serves {
  final int total;
  final int firstServes;
  final int firstServesPercentage;
  final int firstSevesWon;
  final int firstSevesWonPercentage;
  final int firstSevesLost;
  final int firstSevesLostPercentage;
  final int secondServes;
  final int secondServesPercentage;
  final int secondSevesWon;
  final int secondSevesWonPercentage;
  final int secondSevesLost;
  final int secondSevesLostPercentage;

  const Serves({
    required this.total,
    required this.firstServes,
    required this.firstServesPercentage,
    required this.firstSevesWon,
    required this.firstSevesWonPercentage,
    required this.firstSevesLost,
    required this.firstSevesLostPercentage,
    required this.secondServes,
    required this.secondServesPercentage,
    required this.secondSevesWon,
    required this.secondSevesWonPercentage,
    required this.secondSevesLost,
    required this.secondSevesLostPercentage,
  });
}

class ServesRadarChart extends StatefulWidget {
  final bool showPercentages;
  final Serves player1Serves;
  final Serves player2Serves;
  final String player1Name;
  final String player2Name;
  final Function(bool)? onTogglePercentages;

  const ServesRadarChart({
    super.key,
    this.showPercentages = false,
    this.player1Serves = const Serves(
      total: 100,
      firstServes: 65,
      firstServesPercentage: 65,
      firstSevesWon: 45,
      firstSevesWonPercentage: 69,
      firstSevesLost: 20,
      firstSevesLostPercentage: 31,
      secondServes: 35,
      secondServesPercentage: 35,
      secondSevesWon: 20,
      secondSevesWonPercentage: 57,
      secondSevesLost: 15,
      secondSevesLostPercentage: 43,
    ),
    this.player2Serves = const Serves(
      total: 90,
      firstServes: 54,
      firstServesPercentage: 60,
      firstSevesWon: 35,
      firstSevesWonPercentage: 65,
      firstSevesLost: 19,
      firstSevesLostPercentage: 35,
      secondServes: 36,
      secondServesPercentage: 40,
      secondSevesWon: 22,
      secondSevesWonPercentage: 61,
      secondSevesLost: 14,
      secondSevesLostPercentage: 39,
    ),
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.onTogglePercentages,
  });

  @override
  State<ServesRadarChart> createState() => _ServesRadarChartState();
}

class _ServesRadarChartState extends State<ServesRadarChart>
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
    final serves = isPlayer1 ? widget.player1Serves : widget.player2Serves;
    final value = _showPercentages
        ? switch (index) {
            0 => serves.firstServesPercentage,
            1 => serves.firstSevesWonPercentage,
            2 => serves.firstSevesLostPercentage,
            3 => serves.secondServesPercentage,
            4 => serves.secondSevesWonPercentage,
            _ => serves.secondSevesLostPercentage,
          }
        : switch (index) {
            0 => serves.firstServes,
            1 => serves.firstSevesWon,
            2 => serves.firstSevesLost,
            3 => serves.secondServes,
            4 => serves.secondSevesWon,
            _ => serves.secondSevesLost,
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
          // Toggle switch for percentage/points view
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

          // Line Chart
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 350, // Added width constraint to reduce graph width
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
                                const titles = [
                                  'First\nServes',
                                  'First\nWon',
                                  'First\nLost',
                                  'Second\nServes',
                                  'Second\nWon',
                                  'Second\nLost'
                                ];
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
                        maxX: 5,
                        minY: 0,
                        maxY: 100,
                        lineTouchData: LineTouchData(
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? touchResponse) {
                            if (event is FlTapUpEvent) {
                              setState(() {
                                _tooltipIndex = null;
                                _tooltipText = null;
                              });
                            } else if (event is FlPointerHoverEvent &&
                                touchResponse != null) {
                              final index =
                                  touchResponse.lineBarSpots?.first.spotIndex;
                              if (index != null) {
                                setState(() {
                                  _tooltipIndex = index;
                                  _tooltipText =
                                      '${_getTooltipText(index, true)}\n${_getTooltipText(index, false)}';
                                });
                              }
                            }
                          },
                          enabled: true,
                          handleBuiltInTouches: true,
                          getTouchedSpotIndicator: (LineChartBarData barData,
                              List<int> spotIndexes) {
                            return spotIndexes.map((spotIndex) {
                              return TouchedSpotIndicatorData(
                                FlLine(color: Colors.blue, strokeWidth: 2),
                                FlDotData(show: true),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                              // tooltipBgColor: const Color(0xFF37434d),
                              ),
                        ),
                        lineBarsData: [
                          if (_showPlayer1)
                            LineChartBarData(
                              spots: [
                                FlSpot(
                                    0,
                                    _showPercentages
                                        ? widget
                                            .player1Serves.firstServesPercentage
                                            .toDouble()
                                        : widget.player1Serves.firstServes
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    1,
                                    _showPercentages
                                        ? widget.player1Serves
                                            .firstSevesWonPercentage
                                            .toDouble()
                                        : widget.player1Serves.firstSevesWon
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    2,
                                    _showPercentages
                                        ? widget.player1Serves
                                            .firstSevesLostPercentage
                                            .toDouble()
                                        : widget.player1Serves.firstSevesLost
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    3,
                                    _showPercentages
                                        ? widget.player1Serves
                                            .secondServesPercentage
                                            .toDouble()
                                        : widget.player1Serves.secondServes
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    4,
                                    _showPercentages
                                        ? widget.player1Serves
                                            .secondSevesWonPercentage
                                            .toDouble()
                                        : widget.player1Serves.secondSevesWon
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    5,
                                    _showPercentages
                                        ? widget.player1Serves
                                            .secondSevesLostPercentage
                                            .toDouble()
                                        : widget.player1Serves.secondSevesLost
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
                                        ? widget
                                            .player2Serves.firstServesPercentage
                                            .toDouble()
                                        : widget.player2Serves.firstServes
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    1,
                                    _showPercentages
                                        ? widget.player2Serves
                                            .firstSevesWonPercentage
                                            .toDouble()
                                        : widget.player2Serves.firstSevesWon
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    2,
                                    _showPercentages
                                        ? widget.player2Serves
                                            .firstSevesLostPercentage
                                            .toDouble()
                                        : widget.player2Serves.firstSevesLost
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    3,
                                    _showPercentages
                                        ? widget.player2Serves
                                            .secondServesPercentage
                                            .toDouble()
                                        : widget.player2Serves.secondServes
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    4,
                                    _showPercentages
                                        ? widget.player2Serves
                                            .secondSevesWonPercentage
                                            .toDouble()
                                        : widget.player2Serves.secondSevesWon
                                                .toDouble() *
                                            _animation.value),
                                FlSpot(
                                    5,
                                    _showPercentages
                                        ? widget.player2Serves
                                            .secondSevesLostPercentage
                                            .toDouble()
                                        : widget.player2Serves.secondSevesLost
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
              if (_tooltipText != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _tooltipText!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),

          // Legend
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

          // Stats Container
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildStatContainer('Total Serves', widget.player1Serves.total,
                    widget.player2Serves.total),
                _buildStatContainer(
                    'First Serves',
                    widget.player1Serves.firstServes,
                    widget.player2Serves.firstServes),
                _buildStatContainer(
                    'First Serves %',
                    widget.player1Serves.firstServesPercentage,
                    widget.player2Serves.firstServesPercentage,
                    isPercentage: true),
                _buildStatContainer(
                    'First Serves Won',
                    widget.player1Serves.firstSevesWon,
                    widget.player2Serves.firstSevesWon),
                _buildStatContainer(
                    'Second Serves',
                    widget.player1Serves.secondServes,
                    widget.player2Serves.secondServes),
                _buildStatContainer(
                    'Second Serves Won',
                    widget.player1Serves.secondSevesWon,
                    widget.player2Serves.secondSevesWon),
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

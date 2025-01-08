import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PointsChart extends StatefulWidget {
  const PointsChart({Key? key}) : super(key: key);

  @override
  State<PointsChart> createState() => _PointsChartState();
}

class _PointsChartState extends State<PointsChart> {
  bool showWonPercentage = true;
  bool showLostPercentage = true;
  bool showPoints = true;
  bool showPercentages = false;
  String selectedTimeRange = 'All Time'; // Default time range

  final List<String> timeRanges = [
    'Last Week',
    'Last Month',
    '3 Months',
    '6 Months',
    'Year to Date',
    'All Time'
  ];

  // Sample data for different time ranges
  final Map<String, Points> player1PointsByRange = {
    'Last Week': Points(
        total: 20, won: 12, wonPercentage: 60, lost: 8, lostPercentage: 40),
    'Last Month': Points(
        total: 45, won: 25, wonPercentage: 56, lost: 20, lostPercentage: 44),
    '3 Months': Points(
        total: 75, won: 45, wonPercentage: 60, lost: 30, lostPercentage: 40),
    '6 Months': Points(
        total: 85, won: 50, wonPercentage: 59, lost: 35, lostPercentage: 41),
    'Year to Date': Points(
        total: 95, won: 55, wonPercentage: 58, lost: 40, lostPercentage: 42),
    'All Time': Points(
        total: 100, won: 60, wonPercentage: 60, lost: 40, lostPercentage: 40),
  };

  final Map<String, Points> player2PointsByRange = {
    'Last Week': Points(
        total: 15, won: 8, wonPercentage: 53, lost: 7, lostPercentage: 47),
    'Last Month': Points(
        total: 40, won: 22, wonPercentage: 55, lost: 18, lostPercentage: 45),
    '3 Months': Points(
        total: 65, won: 35, wonPercentage: 54, lost: 30, lostPercentage: 46),
    '6 Months': Points(
        total: 70, won: 38, wonPercentage: 54, lost: 32, lostPercentage: 46),
    'Year to Date': Points(
        total: 75, won: 42, wonPercentage: 56, lost: 33, lostPercentage: 44),
    'All Time': Points(
        total: 80, won: 45, wonPercentage: 56, lost: 35, lostPercentage: 44),
  };

  Points get player1Points => player1PointsByRange[selectedTimeRange]!;
  Points get player2Points => player2PointsByRange[selectedTimeRange]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points Chart'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 32.0,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Time Range Filter Card
                Card(
                  elevation: 4,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade50,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedTimeRange,
                        isExpanded: true,
                        icon: Icon(Icons.calendar_today,
                            color: Colors.deepPurple.shade700),
                        style: TextStyle(
                          color: Colors.deepPurple.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        items: timeRanges.map((String range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedTimeRange = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shadowColor: Colors.deepPurple.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.deepPurple.shade50,
                        ],
                      ),
                    ),
                    child: SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: showPercentages ? 100 : 120,
                          barGroups: [
                            if (showWonPercentage)
                              generateBarGroup(
                                0,
                                showPercentages
                                    ? player1Points.wonPercentage.toDouble()
                                    : player1Points.won.toDouble(),
                                showPercentages
                                    ? player2Points.wonPercentage.toDouble()
                                    : player2Points.won.toDouble(),
                              ),
                            if (showLostPercentage)
                              generateBarGroup(
                                1,
                                showPercentages
                                    ? player1Points.lostPercentage.toDouble()
                                    : player1Points.lost.toDouble(),
                                showPercentages
                                    ? player2Points.lostPercentage.toDouble()
                                    : player2Points.lost.toDouble(),
                              ),
                            if (showPoints)
                              generateBarGroup(
                                2,
                                player1Points.total.toDouble(),
                                player2Points.total.toDouble(),
                              ),
                          ],
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return Text(
                                        showPercentages
                                            ? 'Won %'
                                            : 'Won Points',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple.shade700,
                                        ),
                                      );
                                    case 1:
                                      return Text(
                                        showPercentages
                                            ? 'Lost %'
                                            : 'Lost Points',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple.shade700,
                                        ),
                                      );
                                    case 2:
                                      return Text(
                                        'Total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple.shade700,
                                        ),
                                      );
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int player1Value = 0;
                                  int player2Value = 0;
                                  String title = '';
                                  switch (value.toInt()) {
                                    case 0:
                                      title = 'Won';
                                      player1Value = showPercentages
                                          ? player1Points.wonPercentage
                                          : player1Points.won;
                                      player2Value = showPercentages
                                          ? player2Points.wonPercentage
                                          : player2Points.won;
                                      break;
                                    case 1:
                                      title = 'Lost';
                                      player1Value = showPercentages
                                          ? player1Points.lostPercentage
                                          : player1Points.lost;
                                      player2Value = showPercentages
                                          ? player2Points.lostPercentage
                                          : player2Points.lost;
                                      break;
                                    case 2:
                                      title = 'Total';
                                      player1Value = player1Points.total;
                                      player2Value = player2Points.total;
                                      break;
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple.shade700,
                                        ),
                                      ),
                                      Text(
                                        '$player1Value${value.toInt() != 2 && showPercentages ? '%      ' : '          '}:$player2Value${value.toInt() != 2 && showPercentages ? '%   ' : '      '}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: Colors.deepPurple.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              tooltipRoundedRadius: 8,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String label =
                                    rodIndex == 0 ? 'Player 1: ' : 'Player 2: ';
                                return BarTooltipItem(
                                  '$label${rod.toY.toInt()}${groupIndex != 2 && showPercentages ? '%' : ''}',
                                  TextStyle(
                                    color: Colors.deepPurple.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.deepPurple.shade100,
                                strokeWidth: 0.8,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.deepPurple.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade50,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Points',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                        Switch(
                          value: showPercentages,
                          onChanged: (value) {
                            setState(() {
                              showPercentages = value;
                            });
                          },
                          activeColor: Colors.deepPurple,
                          activeTrackColor: Colors.deepPurple.shade200,
                        ),
                        Text(
                          'Percentages',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: Text(
                        showPercentages ? 'Won Percentage' : 'Won Points',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: showWonPercentage
                              ? Colors.white
                              : Colors.deepPurple.shade700,
                        ),
                      ),
                      selected: showWonPercentage,
                      onSelected: (bool selected) {
                        setState(() {
                          showWonPercentage = selected;
                        });
                      },
                      selectedColor: Colors.deepPurple,
                      checkmarkColor: Colors.white,
                      backgroundColor: Colors.deepPurple.shade50,
                    ),
                    FilterChip(
                      label: Text(
                        showPercentages ? 'Lost Percentage' : 'Lost Points',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: showLostPercentage
                              ? Colors.white
                              : Colors.deepPurple.shade700,
                        ),
                      ),
                      selected: showLostPercentage,
                      onSelected: (bool selected) {
                        setState(() {
                          showLostPercentage = selected;
                        });
                      },
                      selectedColor: Colors.deepPurple,
                      checkmarkColor: Colors.white,
                      backgroundColor: Colors.deepPurple.shade50,
                    ),
                    FilterChip(
                      label: Text(
                        'Total Points',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: showPoints
                              ? Colors.white
                              : Colors.deepPurple.shade700,
                        ),
                      ),
                      selected: showPoints,
                      onSelected: (bool selected) {
                        setState(() {
                          showPoints = selected;
                        });
                      },
                      selectedColor: Colors.deepPurple,
                      checkmarkColor: Colors.white,
                      backgroundColor: Colors.deepPurple.shade50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade50,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLegendItem(Colors.indigo.shade700, 'Player 1'),
                        const SizedBox(width: 20),
                        _buildLegendItem(Colors.pink.shade700, 'Player 2'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          }),
        ),
      ),
    );
  }

  BarChartGroupData generateBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.indigo.shade700,
          width: 12,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: showPercentages ? 100 : 120,
            color: Colors.indigo.withOpacity(0.1),
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.pink.shade700,
          width: 12,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: showPercentages ? 100 : 120,
            color: Colors.pink.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple.shade700,
          ),
        ),
      ],
    );
  }
}

class Points {
  Points({
    required this.total,
    required this.won,
    required this.wonPercentage,
    required this.lost,
    required this.lostPercentage,
  });

  final int total;
  final int won;
  final int wonPercentage;
  final int lost;
  final int lostPercentage;
}

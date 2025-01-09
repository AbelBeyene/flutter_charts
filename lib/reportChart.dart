import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Report {
  const Report({
    required this.points,
    required this.winners,
    required this.errors,
    required this.lastShot,
    required this.breakPoints,
    required this.gamePoints,
    required this.serves,
    required this.firstSevePlacement,
    required this.secondSevePlacement,
    required this.acePlacement,
    required this.totalDoubleFaults,
    required this.returnStats,
    required this.returnPlacement,
    required this.averageRally,
    required this.rallyLengthFreaquency,
  });

  final Points points;
  final Winners winners;
  final Errors errors;
  final LastShot lastShot;
  final BreakPoints breakPoints;
  final GamePoints gamePoints;
  final Serves serves;
  final ServePlacement firstSevePlacement;
  final ServePlacement secondSevePlacement;
  final ServePlacement acePlacement;
  final int totalDoubleFaults;
  final Return returnStats;
  final ReturnPlacement returnPlacement;
  final int averageRally;
  final RallyLengthFreaquency rallyLengthFreaquency;
}

class Points {
  const Points({
    required this.total,
    required this.won,
    required this.lost,
  });

  final int total;
  final int won;
  final int lost;
}

class Winners {
  const Winners({
    required this.total,
    required this.forehand,
    required this.backhand,
  });

  final int total;
  final int forehand;
  final int backhand;
}

class Errors {
  const Errors({
    required this.total,
    required this.forehand,
    required this.backhand,
  });

  final int total;
  final int forehand;
  final int backhand;
}

class LastShot {
  const LastShot({
    required this.winners,
    required this.errors,
  });

  final int winners;
  final int errors;
}

class BreakPoints {
  const BreakPoints({
    required this.total,
    required this.won,
    required this.lost,
  });

  final int total;
  final int won;
  final int lost;
}

class GamePoints {
  const GamePoints({
    required this.total,
    required this.won,
    required this.lost,
  });

  final int total;
  final int won;
  final int lost;
}

class Serves {
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
}

class ServePlacement {
  const ServePlacement({
    required this.wide,
    required this.body,
    required this.tee,
  });

  final int wide;
  final int body;
  final int tee;
}

class Return {
  const Return({
    required this.total,
    required this.won,
    required this.lost,
  });

  final int total;
  final int won;
  final int lost;
}

class ReturnPlacement {
  const ReturnPlacement({
    required this.crosscourt,
    required this.down_the_line,
  });

  final int crosscourt;
  final int down_the_line;
}

class RallyLengthFreaquency {
  const RallyLengthFreaquency({
    required this.oneToThree,
    required this.fourToSix,
    required this.sevenToNine,
    required this.tenPlus,
  });

  final int oneToThree;
  final int fourToSix;
  final int sevenToNine;
  final int tenPlus;
}

class ReportCharts extends StatefulWidget {
  const ReportCharts({super.key});

  @override
  State<ReportCharts> createState() => _ReportChartsState();
}

class _ReportChartsState extends State<ReportCharts>
    with TickerProviderStateMixin {
  final player1Report = const Report(
    points: Points(total: 100, won: 60, lost: 40),
    winners: Winners(total: 30, forehand: 20, backhand: 10),
    errors: Errors(total: 25, forehand: 15, backhand: 10),
    lastShot: LastShot(winners: 12, errors: 8),
    breakPoints: BreakPoints(total: 8, won: 5, lost: 3),
    gamePoints: GamePoints(total: 15, won: 10, lost: 5),
    serves: Serves(
      total: 80,
      firstServes: 50,
      firstServesPercentage: 62,
      firstSevesWon: 35,
      firstSevesWonPercentage: 70,
      firstSevesLost: 15,
      firstSevesLostPercentage: 30,
      secondServes: 30,
      secondServesPercentage: 38,
      secondSevesWon: 20,
      secondSevesWonPercentage: 67,
      secondSevesLost: 10,
      secondSevesLostPercentage: 33,
    ),
    firstSevePlacement: ServePlacement(wide: 20, body: 15, tee: 15),
    secondSevePlacement: ServePlacement(wide: 10, body: 10, tee: 10),
    acePlacement: ServePlacement(wide: 5, body: 2, tee: 3),
    totalDoubleFaults: 5,
    returnStats: Return(total: 75, won: 45, lost: 30),
    returnPlacement: ReturnPlacement(crosscourt: 40, down_the_line: 35),
    averageRally: 6,
    rallyLengthFreaquency: RallyLengthFreaquency(
      oneToThree: 30,
      fourToSix: 25,
      sevenToNine: 15,
      tenPlus: 5,
    ),
  );

  final Report player2Report = Report(
    points: Points(total: 90, won: 50, lost: 40),
    winners: Winners(total: 25, forehand: 15, backhand: 10),
    errors: Errors(total: 30, forehand: 18, backhand: 12),
    lastShot: LastShot(winners: 10, errors: 10),
    breakPoints: BreakPoints(total: 6, won: 3, lost: 3),
    gamePoints: GamePoints(total: 12, won: 8, lost: 4),
    serves: Serves(
      total: 75,
      firstServes: 45,
      firstServesPercentage: 60,
      firstSevesWon: 30,
      firstSevesWonPercentage: 67,
      firstSevesLost: 15,
      firstSevesLostPercentage: 33,
      secondServes: 30,
      secondServesPercentage: 40,
      secondSevesWon: 18,
      secondSevesWonPercentage: 60,
      secondSevesLost: 12,
      secondSevesLostPercentage: 40,
    ),
    firstSevePlacement: ServePlacement(wide: 18, body: 12, tee: 15),
    secondSevePlacement: ServePlacement(wide: 8, body: 12, tee: 10),
    acePlacement: ServePlacement(wide: 3, body: 2, tee: 2),
    totalDoubleFaults: 6,
    returnStats: Return(total: 70, won: 40, lost: 30),
    returnPlacement: ReturnPlacement(crosscourt: 35, down_the_line: 35),
    averageRally: 5,
    rallyLengthFreaquency: RallyLengthFreaquency(
      oneToThree: 25,
      fourToSix: 30,
      sevenToNine: 10,
      tenPlus: 5,
    ),
  );

  final String player1Name = 'Player 1';
  final String player2Name = 'Player 2';

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
    _showPercentages = false;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 2x2 Grid of Charts
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              // Match Overview Chart
              _buildChartCard(
                'Match Overview',
                [
                  player1Report.points.total,
                  player1Report.winners.total,
                  player1Report.errors.total,
                  player1Report.gamePoints.total,
                ],
                [
                  player2Report.points.total,
                  player2Report.winners.total,
                  player2Report.errors.total,
                  player2Report.gamePoints.total,
                ],
                ['Points', 'Winners', 'Errors', 'Games'],
              ),

              // Serve Performance Chart
              _buildChartCard(
                'Serve Performance',
                [
                  player1Report.serves.firstServes,
                  player1Report.serves.firstSevesWon,
                  player1Report.serves.secondServes,
                  player1Report.serves.secondSevesWon,
                ],
                [
                  player2Report.serves.firstServes,
                  player2Report.serves.firstSevesWon,
                  player2Report.serves.secondServes,
                  player2Report.serves.secondSevesWon,
                ],
                ['1st Serve', '1st Won', '2nd Serve', '2nd Won'],
              ),

              // Return Performance Chart
              _buildChartCard(
                'Return Performance',
                [
                  player1Report.returnStats.total,
                  player1Report.returnStats.won,
                  player1Report.returnPlacement.crosscourt,
                  player1Report.returnPlacement.down_the_line,
                ],
                [
                  player2Report.returnStats.total,
                  player2Report.returnStats.won,
                  player2Report.returnPlacement.crosscourt,
                  player2Report.returnPlacement.down_the_line,
                ],
                ['Total', 'Won', 'Cross', 'Down Line'],
              ),

              // Rally Distribution Chart
              _buildChartCard(
                'Rally Distribution',
                [
                  player1Report.rallyLengthFreaquency.oneToThree,
                  player1Report.rallyLengthFreaquency.fourToSix,
                  player1Report.rallyLengthFreaquency.sevenToNine,
                  player1Report.rallyLengthFreaquency.tenPlus,
                ],
                [
                  player2Report.rallyLengthFreaquency.oneToThree,
                  player2Report.rallyLengthFreaquency.fourToSix,
                  player2Report.rallyLengthFreaquency.sevenToNine,
                  player2Report.rallyLengthFreaquency.tenPlus,
                ],
                ['1-3', '4-6', '7-9', '10+'],
              ),
            ],
          ),

          // Stats Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatContainer('Total Points', player1Report.points.total,
                    player2Report.points.total),
                _buildStatContainer('Winners', player1Report.winners.total,
                    player2Report.winners.total),
                _buildStatContainer('Errors', player1Report.errors.total,
                    player2Report.errors.total),
                _buildStatContainer(
                    'First Serves Won',
                    player1Report.serves.firstSevesWon,
                    player2Report.serves.firstSevesWon),
                _buildStatContainer(
                    'Returns Won',
                    player1Report.returnStats.won,
                    player2Report.returnStats.won),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, List<int> player1Data,
      List<int> player2Data, List<String> labels) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                labels[value.toInt()],
                                style: const TextStyle(fontSize: 8),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 20,
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _createLineChartBarData(player1Data, Colors.blue),
                    _createLineChartBarData(player2Data, Colors.red),
                  ],
                  minX: 0,
                  maxX: labels.length - 1.0,
                  minY: 0,
                  maxY: player1Data
                          .followedBy(player2Data)
                          .reduce(max)
                          .toDouble() *
                      1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _createLineChartBarData(List<int> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }

  Widget _buildStatContainer(String label, int value1, int value2) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                '$value1',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(' vs '),
              Text(
                '$value2',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

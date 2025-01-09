import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Return {
  final int total;
  final int firstServe;
  final double firstServePercentage;
  final int firstServeWon;
  final double firstServeWonPercentage;
  final int firstServeLost;
  final double firstServeLostPercentage;
  final int secondServe;
  final double secondServePercentage;
  final int secondServeWon;
  final double secondServeWonPercentage;
  final int secondServeLost;
  final double secondServeLostPercentage;

  Return({
    required this.total,
    required this.firstServe,
    required this.firstServePercentage,
    required this.firstServeWon,
    required this.firstServeWonPercentage,
    required this.firstServeLost,
    required this.firstServeLostPercentage,
    required this.secondServe,
    required this.secondServePercentage,
    required this.secondServeWon,
    required this.secondServeWonPercentage,
    required this.secondServeLost,
    required this.secondServeLostPercentage,
  });
}

class ReturnChart extends StatefulWidget {
  const ReturnChart({super.key});

  @override
  State<ReturnChart> createState() => _ReturnChartState();
}

class _ReturnChartState extends State<ReturnChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late PageController _pageController;
  bool showPlayer1 = true;

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
    // Sample data - replace with actual data
    final player1Data = Return(
      total: 100,
      firstServe: 70,
      firstServePercentage: 70,
      firstServeWon: 42,
      firstServeWonPercentage: 60,
      firstServeLost: 28,
      firstServeLostPercentage: 40,
      secondServe: 30,
      secondServePercentage: 30,
      secondServeWon: 18,
      secondServeWonPercentage: 60,
      secondServeLost: 12,
      secondServeLostPercentage: 40,
    );

    final player2Data = Return(
      total: 100,
      firstServe: 65,
      firstServePercentage: 65,
      firstServeWon: 39,
      firstServeWonPercentage: 60,
      firstServeLost: 26,
      firstServeLostPercentage: 40,
      secondServe: 35,
      secondServePercentage: 35,
      secondServeWon: 21,
      secondServeWonPercentage: 60,
      secondServeLost: 14,
      secondServeLostPercentage: 40,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Return Statistics',
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
                        player1Data,
                        const Color(0xFF0984E3),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey[200],
                      ),
                      _buildPlayerStats(
                        'Player 2',
                        player2Data,
                        const Color(0xFF00B894),
                      ),
                    ],
                  ),
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
                          'Return Types',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildLegendItem('First Serve Won',
                            const Color(0xFF0984E3).withOpacity(0.8)),
                        _buildLegendItem('First Serve Lost',
                            const Color(0xFF0984E3).withOpacity(0.6)),
                        _buildLegendItem('Second Serve Won',
                            const Color(0xFF0984E3).withOpacity(0.4)),
                        _buildLegendItem('Second Serve Lost',
                            const Color(0xFF0984E3).withOpacity(0.2)),
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
                          _buildChart(player1Data, const Color(0xFF0984E3)),
                          _buildChart(player2Data, const Color(0xFF00B894)),
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
                  _buildDetailCard(
                    'Total Returns',
                    showPlayer1 ? player1Data.total : player2Data.total,
                    100.0,
                    const Color.fromARGB(255, 242, 244, 245),
                  ),
                  _buildDetailCard(
                    'First Serve',
                    showPlayer1
                        ? player1Data.firstServe
                        : player2Data.firstServe,
                    showPlayer1
                        ? player1Data.firstServePercentage
                        : player2Data.firstServePercentage,
                    const Color(0xFF0984E3).withOpacity(0.8),
                  ),
                  _buildDetailCard(
                    'First Serve Won',
                    showPlayer1
                        ? player1Data.firstServeWon
                        : player2Data.firstServeWon,
                    showPlayer1
                        ? player1Data.firstServeWonPercentage
                        : player2Data.firstServeWonPercentage,
                    const Color(0xFF0984E3).withOpacity(0.6),
                  ),
                  _buildDetailCard(
                    'Second Serve',
                    showPlayer1
                        ? player1Data.secondServe
                        : player2Data.secondServe,
                    showPlayer1
                        ? player1Data.secondServePercentage
                        : player2Data.secondServePercentage,
                    const Color(0xFF0984E3).withOpacity(0.4),
                  ),
                  _buildDetailCard(
                    'Second Serve Won',
                    showPlayer1
                        ? player1Data.secondServeWon
                        : player2Data.secondServeWon,
                    showPlayer1
                        ? player1Data.secondServeWonPercentage
                        : player2Data.secondServeWonPercentage,
                    const Color(0xFF0984E3).withOpacity(0.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
            Text(
              showPlayer1
                  ? 'Swipe left for Player 2'
                  : 'Swipe right for Player 1',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerStats(String label, Return data, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total: ${data.total}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.9),
            letterSpacing: 0.3,
          ),
        ),
        Text(
          'Win Rate: ${((data.firstServeWon + data.secondServeWon) / data.total * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerToggle(String label, bool isPlayer1, Color color) {
    final selected = showPlayer1 == isPlayer1;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            showPlayer1 = isPlayer1;
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

  Widget _buildChart(Return data, Color baseColor) {
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
                    sections: [
                      PieChartSectionData(
                        value: data.firstServeWonPercentage,
                        title:
                            '${data.firstServeWonPercentage.toStringAsFixed(1)}%',
                        color: baseColor.withOpacity(0.8),
                        radius: touchedIndex == 0 ? 85.0 : 75.0,
                        titleStyle: TextStyle(
                          fontSize: touchedIndex == 0 ? 16.0 : 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: data.firstServeLostPercentage,
                        title:
                            '${data.firstServeLostPercentage.toStringAsFixed(1)}%',
                        color: baseColor.withOpacity(0.6),
                        radius: touchedIndex == 1 ? 85.0 : 75.0,
                        titleStyle: TextStyle(
                          fontSize: touchedIndex == 1 ? 16.0 : 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: data.secondServeWonPercentage,
                        title:
                            '${data.secondServeWonPercentage.toStringAsFixed(1)}%',
                        color: baseColor.withOpacity(0.4),
                        radius: touchedIndex == 2 ? 85.0 : 75.0,
                        titleStyle: TextStyle(
                          fontSize: touchedIndex == 2 ? 16.0 : 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: data.secondServeLostPercentage,
                        title:
                            '${data.secondServeLostPercentage.toStringAsFixed(1)}%',
                        color: baseColor.withOpacity(0.2),
                        radius: touchedIndex == 3 ? 85.0 : 75.0,
                        titleStyle: TextStyle(
                          fontSize: touchedIndex == 3 ? 16.0 : 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
              label,
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

  Widget _buildDetailCard(
      String title, int value, double percentage, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.36,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
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
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value points',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

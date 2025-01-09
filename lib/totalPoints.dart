import 'dart:math' show pi;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Holds the points for a single player.
class PlayerPoints {
  final int pointsWon;
  final int pointsLost;
  final double wonPercentage;
  final double lostPercentage;

  PlayerPoints({
    this.pointsWon = 75,
    this.pointsLost = 25,
  })  : wonPercentage =
            (pointsWon / (pointsWon + pointsLost) * 100).roundToDouble(),
        lostPercentage =
            (pointsLost / (pointsWon + pointsLost) * 100).roundToDouble();
}

/// A pie chart widget displaying match statistics for two players.
class PointsChart extends StatefulWidget {
  PointsChart({Key? key}) : super(key: key);

  // Example players
  final PlayerPoints player1 = PlayerPoints();
  final PlayerPoints player2 = PlayerPoints(pointsWon: 65, pointsLost: 35);

  @override
  State<PointsChart> createState() => _PointsChartState();
}

class _PointsChartState extends State<PointsChart>
    with SingleTickerProviderStateMixin {
  /// Toggles between showing raw points or percentage values in the pie chart.
  bool showPercentage = false;

  /// Tracks which player's data to display. `true` = Player 1, `false` = Player 2.
  bool showPlayer1 = true;

  /// Toggles showing a descriptive info box.
  bool showDetails = false;

  late final PageController _pageController;
  late final PageController _legendPageController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _legendPageController = PageController(initialPage: 0);

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

    // Start the chart animation immediately
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _legendPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context),
            if (showDetails) _buildInfoBox(context),
            const SizedBox(height: 16),
            _buildPlayersSummary(context),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => showPercentage = !showPercentage),
              child: _buildToggleButton(),
            ),
            const SizedBox(height: 16),
            Text(
              showPlayer1 ? 'Player 1' : 'Player 2',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: showPlayer1 ? Colors.teal : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Points Won',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Points Lost',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildAnimatedChart()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: showPlayer1 ? Colors.teal : Colors.black12,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !showPlayer1 ? Colors.red : Colors.black12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 100,
              child: PageView(
                controller: _legendPageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLegend(context),
                  _buildLegend(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the header row with title and info toggle.
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Match Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        IconButton(
          icon: Icon(
            showDetails ? Icons.info : Icons.info_outline,
            color: Colors.black,
          ),
          onPressed: () => setState(() => showDetails = !showDetails),
        ),
      ],
    );
  }

  /// Builds the descriptive info box shown when [showDetails] is true.
  Widget _buildInfoBox(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'This chart shows the distribution of points won and lost by each '
        'player throughout the match. Swipe left or right to switch players.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }

  /// Builds a row summarizing total points for Player 1 and Player 2.
  Widget _buildPlayersSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerStats(
            'Player 1',
            widget.player1.pointsWon + widget.player1.pointsLost,
            Colors.teal,
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.black12,
          ),
          _buildPlayerStats(
            'Player 2',
            widget.player2.pointsWon + widget.player2.pointsLost,
            Colors.red,
          ),
        ],
      ),
    );
  }

  /// Builds the toggle button that switches between percentage or points view.
  Widget _buildToggleButton() {
    return Material(
      child: ToggleButtons(
        isSelected: [showPercentage, !showPercentage],
        onPressed: (index) {
          setState(() {
            showPercentage = index == 0;
          });
        },
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.white,
        selectedBorderColor: Colors.teal,
        fillColor: Colors.teal,
        constraints: const BoxConstraints(
          minWidth: 100,
          minHeight: 40,
        ),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8),
                Text('Percentage'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8),
                Text('Points'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the PageView that displays an animated PieChart for Player 1 or Player 2.
  Widget _buildAnimatedChart() {
    return SizedBox(
      height: 300,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            showPlayer1 = index == 0;
            _animationController.reset();
            _animationController.forward();
            _legendPageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        children: [
          _buildPieChart(isPlayer1: true),
          _buildPieChart(isPlayer1: false),
        ],
      ),
    );
  }

  /// Builds a PieChart for either Player 1 or Player 2, applying rotation and fade animations.
  Widget _buildPieChart({required bool isPlayer1}) {
    final PlayerPoints data = isPlayer1 ? widget.player1 : widget.player2;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Spin in from 0 to 2π
        final rotationAngle = _animation.value * 2 * pi;

        return Transform.rotate(
          angle: rotationAngle,
          child: Opacity(
            opacity: _animation.value,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 28,
                borderData: FlBorderData(show: false),
                sections: [
                  PieChartSectionData(
                    color: Colors.teal,
                    value: showPercentage
                        ? data.wonPercentage
                        : data.pointsWon.toDouble(),
                    title: showPercentage
                        ? '${data.wonPercentage}%'
                        : '${data.pointsWon}',
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    badgeWidget: _buildBadgeIcon(Icons.check_circle),
                    badgePositionPercentageOffset: 1.3,
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: showPercentage
                        ? data.lostPercentage
                        : data.pointsLost.toDouble(),
                    title: showPercentage
                        ? '${data.lostPercentage}%'
                        : '${data.pointsLost}',
                    radius: 67,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    badgeWidget: _buildBadgeIcon(Icons.close),
                    badgePositionPercentageOffset: 1.3,
                  ),
                ],
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Add touch interaction if needed
                  },
                  enabled: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a small badge icon overlay for each pie chart section.
  Widget _buildBadgeIcon(IconData icon) {
    return Icon(
      icon,
      size: 18,
      color: Colors.white,
    );
  }

  /// Builds a legend showing the points won/lost and a progress indicator.
  Widget _buildLegend(BuildContext context) {
    final data = showPlayer1 ? widget.player1 : widget.player2;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(
                label: 'Won',
                color: Colors.teal,
                icon: Icons.check_circle,
                value: data.pointsWon,
              ),
              _buildLegendItem(
                label: 'Lost',
                color: Colors.red,
                icon: Icons.close,
                value: data.pointsLost,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: data.wonPercentage / 100,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ],
      ),
    );
  }

  /// Builds a single legend item showing label, icon, and point values.
  Widget _buildLegendItem({
    required String label,
    required Color color,
    required IconData icon,
    required int value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              '$value points',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds an individual player's stats display (e.g., total points).
  Widget _buildPlayerStats(String label, int total, Color color) {
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
          'Total: $total',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

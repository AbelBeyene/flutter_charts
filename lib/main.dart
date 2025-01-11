import 'package:flutter/material.dart';
import 'package:flutter_chats/breakAndGamePoints.dart';
import 'package:flutter_chats/court.dart';
import 'package:flutter_chats/rallyLengthFrequency.dart';
import 'package:flutter_chats/reportChart.dart';
import 'package:flutter_chats/returnPlacement.dart';
import 'package:flutter_chats/servePlacementChart.dart';
import 'package:flutter_chats/servesChart.dart';
import 'package:flutter_chats/winnerPercentage.dart';
import 'package:flutter_chats/totalPoints.dart';
import 'package:flutter_chats/errorsChart.dart';
import 'package:flutter_chats/returnChart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tennis Analytics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4EE0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: Material(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: const Text(
                  'Tennis Analytics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,

                //down the T , body or wide...else faul
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.background,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.all(16),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildStatsCard(
                            context,
                            'Serve Placement',
                            Icons.sports_tennis,
                            const ServePlacementChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Serves',
                            Icons.radar,
                            const ServesRadarChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Break Points',
                            Icons.score,
                            const BreakPointsRadarChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Winners',
                            Icons.emoji_events,
                            const WinnersChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Points',
                            Icons.bar_chart,
                            PointsChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Errors',
                            Icons.error_outline,
                            const ErrorsChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Returns',
                            Icons.replay,
                            const ReturnChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Rally Frequency',
                            Icons.replay,
                            const RallyLengthFrequencyChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Return Placement',
                            Icons.replay,
                            const ReturnPlacementChart(),
                          ),
                          _buildStatsCard(
                            context,
                            'Report',
                            Icons.report,
                            const ReportCharts(),
                          ),
                          _buildStatsCard(
                            context,
                            'Court',
                            Icons.ac_unit_outlined,
                            const TennisCourt(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      BuildContext context, String title, IconData icon, Widget destination) {
    return Builder(
      builder: (context) => Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Material(
                        child: Scaffold(
                          body: SafeArea(child: destination),
                        ),
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

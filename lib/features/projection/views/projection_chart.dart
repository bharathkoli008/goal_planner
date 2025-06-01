import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';

import '../../target_setter/controller/target_controller.dart';

class StackedAreaChart extends StatelessWidget {
  final List<FlSpot> mfPoints;
  final List<FlSpot> stocksPoints;
  final List<FlSpot> sipPoints;
  final TargetState mainTargetData;
  final int phase;

  const StackedAreaChart({
    super.key,
    required this.mfPoints,
    required this.phase,
    required this.mainTargetData,
    required this.stocksPoints,
    required this.sipPoints,
  });

  @override
  Widget build(BuildContext context) {
    final cumulativeStock = stocksPoints;
    final cumulativeMF = _addSpots(cumulativeStock, mfPoints);
    final cumulativeSIP = _addSpots(cumulativeMF, sipPoints);

    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            _lineData(
              cumulativeStock,
              appTeal,
              List.generate(cumulativeStock.length,
                  (i) => FlSpot(cumulativeStock[i].x, 0)),
            ),
            _lineData(
              cumulativeMF,
              appPurple,
              cumulativeStock,
            ),
            _lineData(
              cumulativeSIP,
              appBlue,
              cumulativeMF,
            ),
          ],
          minY: 0,
          maxY: _findMaxY([cumulativeSIP]),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    indiaFormat.format(value), // e.g., "10000"
                    style:appFont(12, appGrey)
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${int.parse(mainTargetData.phases[phase].$1) + value}'.substring(0,4), // e.g., "0", "1", "2"
                      style: appFont(12, appGrey),
                    );
                  }),
            ),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  LineChartBarData _lineData(
      List<FlSpot> spots, Color color, List<FlSpot> belowSpots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      color: color,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        cutOffY: 0,
        applyCutOffY: false,
      ),
    );
  }



  List<FlSpot> _addSpots(List<FlSpot> a, List<FlSpot> b) {
    return List.generate(a.length, (i) {
      return FlSpot(a[i].x, a[i].y + b[i].y);
    });
  }

  double _findMaxY(List<List<FlSpot>> spotGroups) {
    final allYs = spotGroups.expand((list) => list.map((e) => e.y));
    return allYs.reduce((a, b) => a > b ? a : b) * 1.05;
  }
}






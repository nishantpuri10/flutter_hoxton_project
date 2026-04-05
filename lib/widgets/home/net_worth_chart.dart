import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NetWorthChart extends StatefulWidget {
  const NetWorthChart({super.key});

  @override
  State<NetWorthChart> createState() => _NetWorthChartState();
}

class _NetWorthChartState extends State<NetWorthChart> {
  String _selected = '1W';

  static const _tabs = ['1W', '1M', '6M', '1Y', 'YTD', 'Max'];

  static const _spots = [
    FlSpot(0, 25),
    FlSpot(1, 65),
    FlSpot(2, 100),
    FlSpot(3, 70),
    FlSpot(4, 70),
    FlSpot(5, 120),
    FlSpot(6, 120),
    FlSpot(9, 190),
  ];

  static const _xLabels = ['11', '12', '13', '14', '15', '16', '17'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.only(right: 12, top: 8),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF000000).withValues(alpha: 0.08),
                    strokeWidth: 1,
                    dashArray: null,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: (_spots.length - 1) / (_xLabels.length - 1),
                      getTitlesWidget: (value, meta) {
                        final step = (_spots.length - 1) / (_xLabels.length - 1);
                        final labelIdx = (value / step).round();
                        if (labelIdx < 0 || labelIdx >= _xLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _xLabels[labelIdx],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value > 150) return const SizedBox.shrink();
                        return Text(
                          '${value.toInt()}K',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                minX: 0,
                maxX: _spots.length - 1,
                minY: 0,
                maxY: 160,
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF0B3535),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0B3535).withValues(alpha: 0.18),
                          const Color(0xFF0B3535).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildTabs(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _tabs.map((tab) {
        final isSelected = _selected == tab;
        return GestureDetector(
          onTap: () => setState(() => _selected = tab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0B3535) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF888888),
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

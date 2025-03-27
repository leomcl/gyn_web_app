import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/occupancy/occupancy_cubit.dart';
import '../cubit/occupancy/occupancy_state.dart';
import '../cubits/gym_trends_cubit.dart';
import '../widgets/member_traffic_section.dart';

class UsagePage extends StatelessWidget {
  const UsagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccupancyCubit, OccupancyState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left panel (70%)
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Gym Usage Overview'),
                      const SizedBox(height: 16),
                      _buildOccupancyChart(context, state),
                      const SizedBox(height: 24),
                      _sectionTitle(context, 'Gym Trends'),
                      const SizedBox(height: 16),
                      _buildTrendsSection(context),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // Right panel (30%)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(context, 'Date & Filters',
                              fontSize: 20),
                          const SizedBox(height: 12),
                          _buildDateSelector(context, state),
                          const SizedBox(height: 12),
                          _buildTimePeriodToggle(context, state),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildCurrentOccupancy(context, state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Utility widgets
  Widget _sectionTitle(BuildContext context, String title,
      {double fontSize = 24}) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: fontSize,
          ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Color _getColor(int value) {
    if (value > 80) return Colors.red;
    if (value > 50) return Colors.orange;
    return Colors.green;
  }

  // UI Sections
  Widget _buildCurrentOccupancy(BuildContext context, OccupancyState state) {
    final percentage =
        context.read<OccupancyCubit>().getCurrentCapacityPercentage();
    final count = state.currentOccupancy?.currentOccupancy ?? 0;
    final hasData = state.currentOccupancy != null && count > 0;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context, 'Current Occupancy', fontSize: 20),
          const SizedBox(height: 12),
          if (hasData) ...[
            Row(
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getColor(percentage),
                  ),
                ),
                const SizedBox(width: 8),
                Text('people', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage% capacity',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                valueColor:
                    AlwaysStoppedAnimation<Color>(_getColor(percentage)),
              ),
            ),
          ] else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No current occupancy data available'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, OccupancyState state) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            DateFormat('MMM dd, yyyy').format(state.selectedDate),
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Change', style: TextStyle(fontSize: 14)),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 36),
          ),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: state.selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked != state.selectedDate) {
              context.read<OccupancyCubit>().changeSelectedDate(picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimePeriodToggle(BuildContext context, OccupancyState state) {
    return SegmentedButton<TimePeriod>(
      segments: const [
        ButtonSegment<TimePeriod>(
          value: TimePeriod.daily,
          label: Text('Day'),
          icon: Icon(Icons.view_day),
        ),
        ButtonSegment<TimePeriod>(
          value: TimePeriod.weekly,
          label: Text('Week'),
          icon: Icon(Icons.view_week),
        ),
        ButtonSegment<TimePeriod>(
          value: TimePeriod.monthly,
          label: Text('Month'),
          icon: Icon(Icons.calendar_view_month),
        ),
      ],
      selected: {state.timePeriod},
      onSelectionChanged: (Set<TimePeriod> selection) {
        if (selection.isNotEmpty) {
          context.read<OccupancyCubit>().changeTimePeriod(selection.first);
        }
      },
    );
  }

  Widget _buildOccupancyChart(BuildContext context, OccupancyState state) {
    if (state.averageByHour.isEmpty) {
      return _buildCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'No occupancy data available for the selected period',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    final sortedData = state.averageByHour.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Occupancy by Hour',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: OccupancyChart(data: sortedData),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem('Low', Colors.green),
                const SizedBox(width: 24),
                _legendItem('Medium', Colors.orange),
                const SizedBox(width: 24),
                _legendItem('High', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildTrendsSection(BuildContext context) {
    return BlocBuilder<GymTrendsCubit, GymTrendsState>(
      builder: (context, state) {
        if (state is GymTrendsInitial) {
          context.read<GymTrendsCubit>().loadTrends();
          return _loadingOrErrorCard(isLoading: true);
        }

        if (state is GymTrendsLoading) {
          return _loadingOrErrorCard(isLoading: true);
        }

        if (state is GymTrendsError) {
          return _loadingOrErrorCard(
            isLoading: false,
            errorMessage: state.message,
            onRetry: () => context.read<GymTrendsCubit>().loadTrends(),
          );
        }

        if (state is GymTrendsLoaded) {
          return _buildCard(
            child: MemberTrafficSection(limit: 3),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _loadingOrErrorCard(
      {required bool isLoading, String? errorMessage, VoidCallback? onRetry}) {
    return _buildCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading gym trends...'),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 12),
                    Text('Error: $errorMessage', textAlign: TextAlign.center),
                    if (onRetry != null) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class OccupancyChart extends StatefulWidget {
  final List<MapEntry<int, num>> data;

  const OccupancyChart({Key? key, required this.data}) : super(key: key);

  @override
  State<OccupancyChart> createState() => _OccupancyChartState();
}

class _OccupancyChartState extends State<OccupancyChart> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final maxValue = widget.data
        .map((e) => e.value.toDouble())
        .reduce((a, b) => a > b ? a : b);
    final maxY = ((maxValue / 10).ceil() * 10.0 + 10.0).clamp(50.0, 200.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Grid and axes
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: GridPainter(maxY: maxY),
            ),

            // Y-axis labels
            Positioned(
              left: 0,
              top: 0,
              bottom: 30,
              width: 35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${maxY.toInt()}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  Text('${(maxY * 0.75).toInt()}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  Text('${(maxY * 0.5).toInt()}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  Text('${(maxY * 0.25).toInt()}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  Text('0',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),

            // Bars - Fixed to have proper constraints
            Positioned(
              left: 40,
              right: 5,
              top: 0,
              bottom: 30,
              child: LayoutBuilder(
                builder: (context, barConstraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(widget.data.length, (i) {
                      final value = widget.data[i].value.toDouble();
                      final height =
                          (value / maxY) * (barConstraints.maxHeight);
                      final isHovered = i == hoveredIndex;

                      return Expanded(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => hoveredIndex = i),
                          onExit: (_) => setState(() => hoveredIndex = null),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? Colors.blue
                                      : _getBarColor(value),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(3)),
                                ),
                                height: height,
                              ),
                              if (isHovered && height > 0)
                                Positioned(
                                  bottom:
                                      height + 4, // Position tooltip above bar
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      '${value.toInt()} people',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            // X-axis labels - Fixed to handle constraints properly
            Positioned(
              left: 40,
              right: 5,
              bottom: 0,
              height: 25,
              child: LayoutBuilder(
                builder: (context, labelConstraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(widget.data.length, (i) {
                      final hour = widget.data[i].key;
                      final showLabel = widget.data.length <= 12 ||
                          i % 2 == 0 ||
                          i == widget.data.length - 1;

                      return Expanded(
                        child: showLabel
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    _formatHour(hour),
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getBarColor(double value) {
    if (value > 80) return Colors.red;
    if (value > 50) return Colors.orange;
    return Colors.green;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12A';
    if (hour == 12) return '12P';
    if (hour < 12) return '${hour}A';
    return '${hour - 12}P';
  }
}

class GridPainter extends CustomPainter {
  final double maxY;

  GridPainter({required this.maxY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    final height = size.height - 30;
    for (int i = 0; i <= 4; i++) {
      final y = height - (i * height / 4);
      canvas.drawLine(Offset(40, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';

class GymTrendsWidget extends StatelessWidget {
  const GymTrendsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GymTrendsCubit, GymTrendsState>(
      builder: (context, state) {
        if (state is GymTrendsInitial) {
          // Trigger loading when the widget is first built
          context.read<GymTrendsCubit>().loadTrends();
          return const Center(child: Text('Loading trends...'));
        }

        if (state is GymTrendsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GymTrendsError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is GymTrendsLoaded) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrendSection(
                  context: context,
                  title: 'Member Traffic Analysis',
                  children: [
                    _buildTrendCard(
                      context: context,
                      title: 'Low Traffic Hours',
                      subtitle: 'Opportunity for personal training',
                      items: state.leastBusyTimes
                          .map((hour) => _formatHour(hour))
                          .toList(),
                      icon: Icons.access_time,
                      color: Colors.green,
                    ),
                    _buildTrendCard(
                      context: context,
                      title: 'Peak Hours',
                      subtitle: 'Staff allocation needed',
                      items: state.busyTimes
                          .map((hour) => _formatHour(hour))
                          .toList(),
                      icon: Icons.people,
                      color: Colors.orange,
                    ),
                  ],
                ),
                _buildTrendSection(
                  context: context,
                  title: 'Equipment & Program Utilization',
                  children: [
                    _buildTrendCard(
                      context: context,
                      title: 'High-Demand Programs',
                      subtitle: 'Consider expanding capacity',
                      items: state.popularWorkouts,
                      icon: Icons.fitness_center,
                      color: Colors.blue,
                    ),
                    _buildTrendCard(
                      context: context,
                      title: 'Underutilized Programs',
                      subtitle: 'Marketing opportunities',
                      items: state.unpopularWorkouts,
                      icon: Icons.fitness_center_outlined,
                      color: Colors.purple,
                    ),
                  ],
                ),
                _buildTrendSection(
                  context: context,
                  title: 'Class Performance',
                  children: [
                    _buildTrendCard(
                      context: context,
                      title: 'High-Attendance Classes',
                      subtitle: 'Consider additional sessions',
                      items: state.popularClasses,
                      icon: Icons.group,
                      color: Colors.teal,
                    ),
                    _buildTrendCard(
                      context: context,
                      title: 'Low-Attendance Classes',
                      subtitle: 'Review or repurpose timeslots',
                      items: state.unpopularClasses,
                      icon: Icons.group_outlined,
                      color: Colors.indigo,
                    ),
                  ],
                ),
                _buildTrendSection(
                  context: context,
                  title: 'Staffing Requirements',
                  children: [
                    _buildTrendCard(
                      context: context,
                      title: 'Highest Traffic Days',
                      subtitle: 'Maximum staffing required',
                      items: state.busiestDays
                          .map((day) => _formatWeekday(day))
                          .toList(),
                      icon: Icons.calendar_today,
                      color: Colors.red,
                    ),
                    _buildTrendCard(
                      context: context,
                      title: 'Low Volume Days',
                      subtitle: 'Maintenance and inventory time',
                      items: state.leastBusyDays
                          .map((day) => _formatWeekday(day))
                          .toList(),
                      icon: Icons.calendar_today_outlined,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildTrendSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const Divider(height: 24),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No data available',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    items[index],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }

  String _formatHour(int hour) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $period';
  }

  String _formatWeekday(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}

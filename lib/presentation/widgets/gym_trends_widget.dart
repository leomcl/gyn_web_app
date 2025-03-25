import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';

// Enum to let users choose which sections to display
enum TrendSectionType {
  memberTraffic,
  equipmentUtilization,
  classPerformance,
  staffingRequirements
}

class GymTrendsWidget extends StatelessWidget {
  final List<TrendSectionType> sections;

  // Default shows all sections if none specified
  const GymTrendsWidget({
    Key? key,
    this.sections = const [
      TrendSectionType.memberTraffic,
      TrendSectionType.equipmentUtilization,
      TrendSectionType.classPerformance,
      TrendSectionType.staffingRequirements
    ],
  }) : super(key: key);

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
                // Conditionally build sections based on the sections parameter
                if (sections.contains(TrendSectionType.memberTraffic))
                  _buildTrendSection(
                    context: context,
                    title: 'Member Traffic Analysis',
                    children: [
                      GymTrendCard(
                        title: 'Low Traffic Hours',
                        subtitle: 'Opportunity for personal training',
                        items: state.leastBusyTimes
                            .map((hour) => _formatHour(hour))
                            .toList(),
                        icon: Icons.access_time,
                        color: Colors.green,
                      ),
                      GymTrendCard(
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

                if (sections.contains(TrendSectionType.equipmentUtilization))
                  _buildTrendSection(
                    context: context,
                    title: 'Equipment & Program Utilization',
                    children: [
                      GymTrendCard(
                        title: 'High-Demand Programs',
                        subtitle: 'Consider expanding capacity',
                        items: state.popularWorkouts,
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                      ),
                      GymTrendCard(
                        title: 'Underutilized Programs',
                        subtitle: 'Marketing opportunities',
                        items: state.unpopularWorkouts,
                        icon: Icons.fitness_center_outlined,
                        color: Colors.purple,
                      ),
                    ],
                  ),

                if (sections.contains(TrendSectionType.classPerformance))
                  _buildTrendSection(
                    context: context,
                    title: 'Class Performance',
                    children: [
                      GymTrendCard(
                        title: 'High-Attendance Classes',
                        subtitle: 'Consider additional sessions',
                        items: state.popularClasses,
                        icon: Icons.group,
                        color: Colors.teal,
                      ),
                      GymTrendCard(
                        title: 'Low-Attendance Classes',
                        subtitle: 'Review or repurpose timeslots',
                        items: state.unpopularClasses,
                        icon: Icons.group_outlined,
                        color: Colors.indigo,
                      ),
                    ],
                  ),

                if (sections.contains(TrendSectionType.staffingRequirements))
                  _buildTrendSection(
                    context: context,
                    title: 'Staffing Requirements',
                    children: [
                      GymTrendCard(
                        title: 'Highest Traffic Days',
                        subtitle: 'Maximum staffing required',
                        items: state.busiestDays
                            .map((day) => _formatWeekday(day))
                            .toList(),
                        icon: Icons.calendar_today,
                        color: Colors.red,
                      ),
                      GymTrendCard(
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
          LayoutBuilder(
            builder: (context, constraints) {
              // Use grid layout for desktop screens (wider than 800px)
              if (constraints.maxWidth > 800) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 1200 ? 4 : 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: children.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) => children[index],
                );
              } else {
                // Original horizontal scrolling for narrower screens
                return SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: children,
                  ),
                );
              }
            },
          ),
        ],
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

// Extracted to separate widget for independent use
class GymTrendCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final IconData icon;
  final Color color;
  final int? limit;

  const GymTrendCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.icon,
    required this.color,
    this.limit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Apply limit to items if specified
    final displayItems = limit != null && limit! < items.length
        ? items.sublist(0, limit)
        : items;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Fixed width for horizontal scrolling, full width for grid layout
        final bool isDesktop = constraints.maxWidth > 300;

        return Container(
          width: isDesktop ? null : 220,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  child: displayItems.isEmpty
                      ? Center(
                          child: Text(
                            'No data available',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                                      displayItems[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
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
        );
      },
    );
  }
}

// Create a standalone trend section widget that can be used independently
class GymTrendSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const GymTrendSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          LayoutBuilder(
            builder: (context, constraints) {
              // Use grid layout for desktop screens (wider than 800px)
              if (constraints.maxWidth > 800) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 1200 ? 4 : 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: children.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) => children[index],
                );
              } else {
                // Original horizontal scrolling for narrower screens
                return SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: children,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

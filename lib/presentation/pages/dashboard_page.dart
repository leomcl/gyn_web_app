import 'package:flutter/material.dart';
import '../widgets/gym_trends_widget.dart';
import '../cubits/gym_trends_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesktopDashboard(),
    );
  }
}

class DesktopDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GymTrendsCubit, GymTrendsState>(
      builder: (context, state) {
        // Trigger data loading if needed
        if (state is GymTrendsInitial) {
          context.read<GymTrendsCubit>().loadTrends();
        }

        return CustomScrollView(
          slivers: [
            // Content
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and summary cards
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gym Performance Overview',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Real-time analytics for your fitness facility',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: _SummaryCard(
                            title: 'Members',
                            value: '1,248',
                            subtitle: '+5% this month',
                            color: Colors.blue,
                            icon: Icons.people,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: _SummaryCard(
                            title: 'Revenue',
                            value: '\$45,250',
                            subtitle: '+12% vs last month',
                            color: Colors.green,
                            icon: Icons.monetization_on,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Display loading indicator if data isn't ready
                    if (state is GymTrendsLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(48.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // Error state
                    if (state is GymTrendsError)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading data: ${state.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<GymTrendsCubit>().loadTrends();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Main grid layout when data is loaded
                    if (state is GymTrendsLoaded) ...[
                      Text(
                        'Facility Analytics',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),

                      // First row - 4 widgets
                      SizedBox(
                        height: 280,
                        child: Row(
                          children: [
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'Peak Hours',
                                subtitle: 'Staff allocation needed',
                                items: state.busyTimes
                                    .map((hour) => _formatHour(hour))
                                    .toList(),
                                icon: Icons.people,
                                color: Colors.orange,
                                limit: 3,
                              ),
                            ),
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'High-Demand Programs',
                                subtitle: 'Consider expanding capacity',
                                items: state.popularWorkouts,
                                icon: Icons.fitness_center,
                                color: Colors.blue,
                                limit: 3,
                              ),
                            ),
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'High-Attendance Classes',
                                subtitle: 'Consider additional sessions',
                                items: state.popularClasses,
                                icon: Icons.group,
                                color: Colors.teal,
                                limit: 3,
                              ),
                            ),
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'Low-Attendance Classes',
                                subtitle: 'Review or repurpose timeslots',
                                items: state.unpopularClasses,
                                icon: Icons.group_outlined,
                                color: Colors.indigo,
                                limit: 3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Second row - 4 widgets
                      SizedBox(
                        height: 280,
                        child: Row(
                          children: [
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'Low Traffic Hours',
                                subtitle: 'Opportunity for training',
                                items: state.leastBusyTimes
                                    .map((hour) => _formatHour(hour))
                                    .toList(),
                                icon: Icons.access_time,
                                color: Colors.green,
                                limit: 4,
                              ),
                            ),
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'Low Volume Days',
                                subtitle: 'Maintenance time',
                                items: state.leastBusyDays
                                    .map((day) => _formatWeekday(day))
                                    .toList(),
                                icon: Icons.calendar_today_outlined,
                                color: Colors.green,
                                limit: 4,
                              ),
                            ),
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'Underutilized Programs',
                                subtitle: 'Marketing opportunities',
                                items: state.unpopularWorkouts,
                                icon: Icons.fitness_center_outlined,
                                color: Colors.purple,
                                limit: 4,
                              ),
                            ),
                            _buildGridCard(
                              context: context,
                              child: GymTrendCard(
                                title: 'Highest Traffic Days',
                                subtitle: 'Maximum staffing required',
                                items: state.busiestDays
                                    .map((day) => _formatWeekday(day))
                                    .toList(),
                                icon: Icons.calendar_today,
                                color: Colors.red,
                                limit: 4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Additional dashboard section
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Actions Required',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    _ActionItem(
                                      title: 'Add peak hour classes',
                                      description:
                                          'Schedule more classes during high-demand times',
                                      icon: Icons.add_circle,
                                      color: Colors.blue,
                                    ),
                                    const Divider(),
                                    _ActionItem(
                                      title: 'Review marketing strategy',
                                      description: 'For underutilized programs',
                                      icon: Icons.campaign,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper widget to create a consistent grid card
  Widget _buildGridCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    );
  }

  // Helper methods for formatting data
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

// Summary card widget for top section
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// Action item widget for the bottom section
class _ActionItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _ActionItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              // Action
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color: Theme.of(context).primaryColor),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

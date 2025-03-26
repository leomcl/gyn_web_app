import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';

// Import the individual section widgets
import '../widgets/member_traffic_section.dart';
import '../widgets/workout_section.dart';
import '../widgets/class_performance_section.dart';
import '../widgets/staffing_requirements_section.dart';

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title and summary cards
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
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
                                mainAxisSize: MainAxisSize.min,
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
                        Flexible(
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
                        Flexible(
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
                            mainAxisSize: MainAxisSize.min,
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

                      // First row - Using widget sections (now a column)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGridCard(
                            context: context,
                            child: StaffingRequirementsSection(
                              limit: 3,
                            ),
                          ),
                          const SizedBox(
                              height: 16), // Add spacing between sections
                          _buildGridCard(
                            context: context,
                            child: ClassPerformanceSection(
                              limit: 3,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Second row sections
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGridCard(
                            context: context,
                            child: MemberTrafficSection(
                              limit: 3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildGridCard(
                            context: context,
                            child: EquipmentUtilizationSection(
                              limit: 3,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const SizedBox(height: 32),

                      // Additional dashboard section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Actions Required',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
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
    return Padding(
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
    );
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
          mainAxisSize: MainAxisSize.min,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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

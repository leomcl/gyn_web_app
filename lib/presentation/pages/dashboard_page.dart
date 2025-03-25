import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/gym_trends_widget.dart';
import '../cubits/gym_trends_cubit.dart';
import '../../domain/usecases/general_trends/get_busy_times.dart';
import '../../domain/usecases/general_trends/get_most_common_workout.dart';
import '../../domain/usecases/general_trends/get_busy_class.dart';
import '../../domain/usecases/general_trends/get_busy_day.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _DashboardCard(
                    title: 'Total Users',
                    value: '450',
                    icon: Icons.person,
                  ),
                  _DashboardCard(
                    title: 'Average Daily Visits',
                    value: '127',
                    icon: Icons.trending_up,
                  ),
                  _DashboardCard(
                    title: 'Peak Hours',
                    value: '5-7 PM',
                    icon: Icons.access_time,
                  ),
                  _DashboardCard(
                    title: 'Equipment Utilization',
                    value: '78%',
                    icon: Icons.fitness_center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Facility Analytics',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const GymTrendsWidget(),
          ],
        ),
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

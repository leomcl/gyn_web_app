import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/workout_stats/workout_stats_cubit.dart';
import '../cubit/workout_stats/workout_stats_state.dart';
import '../widgets/workout_section.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load workouts when the page is first opened
    context.read<WorkoutStatsCubit>().loadWorkouts();

    return BlocBuilder<WorkoutStatsCubit, WorkoutStatsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Statistics',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              // Filter controls
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TimePeriod>(
                      decoration: const InputDecoration(
                        labelText: 'Time Period',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: TimePeriod.daily, child: Text('Daily')),
                        DropdownMenuItem(
                            value: TimePeriod.weekly, child: Text('Weekly')),
                        DropdownMenuItem(
                            value: TimePeriod.monthly, child: Text('Monthly')),
                      ],
                      value: state.timePeriod,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<WorkoutStatsCubit>()
                              .changeTimePeriod(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<WorkoutCategory>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: WorkoutCategory.all,
                            child: Text('All Areas')),
                        DropdownMenuItem(
                            value: WorkoutCategory.weights,
                            child: Text('Weights')),
                        DropdownMenuItem(
                            value: WorkoutCategory.cardio,
                            child: Text('Cardio')),
                        DropdownMenuItem(
                            value: WorkoutCategory.classes,
                            child: Text('Classes')),
                      ],
                      value: state.category,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<WorkoutStatsCubit>()
                              .changeCategory(value);
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Usage data display
              Expanded(
                flex: 3,
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                        ? Center(child: Text('Error: ${state.error}'))
                        : state.workouts.isEmpty
                            ? const Center(
                                child: Text('No workout data available'))
                            : _buildWorkoutDataTable(context, state),
              ),

              const SizedBox(height: 20),

              // Additional sections from dashboard
              Container(
                height: 180, // Fixed height instead of constraint
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: EquipmentUtilizationSection(
                          limit: 2, // Reduced limit to show less items
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutDataTable(BuildContext context, WorkoutStatsState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: DataTable(
                          columnSpacing: 24.0,
                          horizontalMargin: 12.0,
                          columns: const [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Duration')),
                            DataColumn(label: Text('Equipment')),
                            DataColumn(label: Text('User')),
                          ],
                          rows: state.workouts.map((workout) {
                            final date = DateTime(
                                workout.year, workout.month, workout.day);
                            return DataRow(
                              cells: [
                                DataCell(Text(date.toString().split(' ')[0])),
                                DataCell(Text(workout.workoutType)),
                                DataCell(Text('${workout.duration} min')),
                                DataCell(Text(workout.workoutTags.join(', '))),
                                DataCell(Text(workout.userId)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

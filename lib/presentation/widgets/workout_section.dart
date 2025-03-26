import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';
import 'gym_trend_section.dart';
import 'gym_trend_card.dart';

class EquipmentUtilizationSection extends StatelessWidget {
  final int? limit;
  final bool reverse;

  const EquipmentUtilizationSection({
    Key? key,
    this.limit,
    this.reverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GymTrendsCubit, GymTrendsState>(
      builder: (context, state) {
        if (state is GymTrendsInitial) {
          context.read<GymTrendsCubit>().loadTrends();
          return const Center(child: Text('Loading trends...'));
        }
        if (state is GymTrendsLoading) {
          return const Center(child: CircularProgressIndicator());
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
          final highDemand = state.popularWorkouts;
          final underUtilized = state.unpopularWorkouts;
          return GymTrendSection(
            title: 'Equipment & Program Utilization',
            children: [
              GymTrendCard(
                title: 'High-Demand Programs',
                subtitle: 'Consider expanding capacity',
                items: reverse
                    ? highDemand.reversed.toList()
                    : highDemand,
                icon: Icons.fitness_center,
                color: Colors.blue,
                limit: limit,
              ),
              GymTrendCard(
                title: 'Underutilized Programs',
                subtitle: 'Marketing opportunities',
                items: reverse
                    ? underUtilized.reversed.toList()
                    : underUtilized,
                icon: Icons.fitness_center_outlined,
                color: Colors.purple,
                limit: limit,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';
import 'gym_trend_section.dart';
import 'gym_trend_card.dart';

class ClassPerformanceSection extends StatelessWidget {
  final int? limit;
  final bool reverse;

  const ClassPerformanceSection({
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
          final highAttendance = state.popularClasses;
          final lowAttendance = state.unpopularClasses;
          return GymTrendSection(
            title: 'Class Performance',
            children: [
              GymTrendCard(
                title: 'High-Attendance Classes',
                subtitle: 'Consider additional sessions',
                items: reverse
                    ? highAttendance.reversed.toList()
                    : highAttendance,
                icon: Icons.group,
                color: Colors.teal,
                limit: limit,
              ),
              GymTrendCard(
                title: 'Low-Attendance Classes',
                subtitle: 'Review or repurpose timeslots',
                items: reverse
                    ? lowAttendance.reversed.toList()
                    : lowAttendance,
                icon: Icons.group_outlined,
                color: Colors.indigo,
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

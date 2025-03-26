import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';
import 'gym_trend_section.dart';
import 'gym_trend_card.dart';

class MemberTrafficSection extends StatelessWidget {
  final int? limit;
  final bool reverse;

  const MemberTrafficSection({
    Key? key,
    this.limit,
    this.reverse = false,
  }) : super(key: key);

  String _formatHour(int hour) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $period';
  }

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
          final lowTraffic =
              state.leastBusyTimes.map(_formatHour).toList();
          final peakTraffic =
              state.busyTimes.map(_formatHour).toList();

          return GymTrendSection(
            title: 'Member Traffic Analysis',
            children: [
              GymTrendCard(
                title: 'Low Traffic Hours',
                subtitle: 'Opportunity for personal training',
                items: reverse
                    ? lowTraffic.reversed.toList()
                    : lowTraffic,
                icon: Icons.access_time,
                color: Colors.green,
                limit: limit,
              ),
              GymTrendCard(
                title: 'Peak Hours',
                subtitle: 'Staff allocation needed',
                items: reverse
                    ? peakTraffic.reversed.toList()
                    : peakTraffic,
                icon: Icons.people,
                color: Colors.orange,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/gym_trends_cubit.dart';
import 'gym_trend_section.dart';
import 'gym_trend_card.dart';

class StaffingRequirementsSection extends StatelessWidget {
  final int? limit;
  final bool reverse;

  const StaffingRequirementsSection({
    Key? key,
    this.limit,
    this.reverse = false,
  }) : super(key: key);

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
          final busiestDays =
              state.busiestDays.map(_formatWeekday).toList();
          final leastBusyDays =
              state.leastBusyDays.map(_formatWeekday).toList();

          return GymTrendSection(
            title: 'Staffing Requirements',
            children: [
              GymTrendCard(
                title: 'Highest Traffic Days',
                subtitle: 'Maximum staffing required',
                items: reverse
                    ? busiestDays.reversed.toList()
                    : busiestDays,
                icon: Icons.calendar_today,
                color: Colors.red,
                limit: limit,
              ),
              GymTrendCard(
                title: 'Low Volume Days',
                subtitle: 'Maintenance and inventory time',
                items: reverse
                    ? leastBusyDays.reversed.toList()
                    : leastBusyDays,
                icon: Icons.calendar_today_outlined,
                color: Colors.green,
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

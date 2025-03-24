import 'package:snow_stats_app/domain/usecases/workouts/get_user_workouts.dart';

class GetUserPreferedDays {
  final GetUserWorkouts getUserWorkouts;

  GetUserPreferedDays(this.getUserWorkouts);

  Future<List<int>> call(String userId, int limit) async {
    final workoutHistory = await getUserWorkouts(userId);

    // get the workout history for the last 30 days
    final workoutHistory30Days = workoutHistory
        .where((workout) => workout.entryTime
            .isAfter(DateTime.now().subtract(Duration(days: 30))))
        .toList();

    // calculate the prefered days
    final dayCounts = <int, int>{};

    for (var workout in workoutHistory30Days) {
      final day = workout.dayOfWeek;
      dayCounts[day] = (dayCounts[day] ?? 0) + 1;
    }

    // Sort days by frequency (descending)
    final sortedDays = dayCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedDays.map((e) => e.key).take(limit).toList();
  }
}

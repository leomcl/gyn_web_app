import 'package:snow_stats_app/domain/usecases/workouts/get_user_workouts.dart';

class GetUserPreferedWorkout {
  final GetUserWorkouts getUserWorkouts;

  GetUserPreferedWorkout(this.getUserWorkouts);

  Future<List<String>> call(String userId, int limit) async {
    final workoutHistory = await getUserWorkouts(userId);

    // get the workout history for the last 30 days
    final workoutHistory30Days = workoutHistory
        .where((workout) => workout.entryTime
            .isAfter(DateTime.now().subtract(Duration(days: 30))))
        .toList();

    // calculate most common workout type
    final typeCounts = <String, int>{};

    for (var workout in workoutHistory30Days) {
      final tags = workout.workoutTags;
      for (var tag in tags) {
        typeCounts[tag] = (typeCounts[tag] ?? 0) + 1;
      }
    }

    // Sort tags by frequency (descending)
    final sortedTags = typeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTags.map((e) => e.key).take(limit).toList();
  }
}

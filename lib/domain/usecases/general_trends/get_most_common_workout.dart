import 'package:snow_stats_app/domain/usecases/workouts/get_monthly_workouts.dart';

class GetMostCommonWorkout {
  final GetMonthlyWorkouts getMonthlyWorkouts;

  GetMostCommonWorkout(this.getMonthlyWorkouts);

  Future<List<String>> call(int year, int month, int limit,
      {bool getMostFrequent = true}) async {
    final workoutHistory = await getMonthlyWorkouts(year: year, month: month);

    // calculate most common workout type
    final typeCounts = <String, int>{};

    for (var workout in workoutHistory) {
      final tags = workout.workoutTags;
      for (var tag in tags) {
        typeCounts[tag] = (typeCounts[tag] ?? 0) + 1;
      }
    }

    final sortedTags = typeCounts.entries.toList()
      ..sort((a, b) => getMostFrequent
          ? b.value.compareTo(a.value) 
          : a.value.compareTo(b.value)); 

    return sortedTags.map((e) => e.key).take(limit).toList();
  }
}

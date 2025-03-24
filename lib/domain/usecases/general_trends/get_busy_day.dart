import 'package:snow_stats_app/domain/usecases/workouts/get_monthly_workouts.dart';

class GetBusyDay {
  final GetMonthlyWorkouts getMonthlyWorkouts;

  GetBusyDay(this.getMonthlyWorkouts);

  Future<List<int>> call(int year, int month, int limit,
      {bool getMostFrequent = true}) async {
    final workoutHistory = await getMonthlyWorkouts(year: year, month: month);

    // calculate the busy days
    final dayCounts = <int, int>{};

    for (var workout in workoutHistory) {
      final day = workout.dayOfWeek;
      dayCounts[day] = (dayCounts[day] ?? 0) + 1;
    }

    // Sort days by frequency (descending or ascending based on getMostFrequent)
    final sortedDays = dayCounts.entries.toList()
      ..sort((a, b) => getMostFrequent
          ? b.value.compareTo(a.value) // Most frequent first
          : a.value.compareTo(b.value)); // Least frequent first

    return sortedDays.map((e) => e.key).take(limit).toList();
  }
}

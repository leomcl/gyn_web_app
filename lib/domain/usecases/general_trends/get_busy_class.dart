import 'package:snow_stats_app/domain/usecases/workouts/get_monthly_workouts.dart';

class GetBusyClass {
  final GetMonthlyWorkouts getMonthlyWorkouts;

  GetBusyClass(this.getMonthlyWorkouts);

  Future<List<String>> call(int year, int month, int limit, 
  {bool getMostFrequent = true}) async {
    final workoutHistory = await getMonthlyWorkouts(year: year, month: month);

    // calculate most common class
    final classCounts = <String, int>{};

    for (var workout in workoutHistory) {
      final tags = workout.workoutTags;
      for (var tag in tags) {
        if (tag.contains('Class')) {
          classCounts[tag] = (classCounts[tag] ?? 0) + 1;
        }
      }
    }

    final sortedClasses = classCounts.entries.toList()
      ..sort((a, b) => getMostFrequent
          ? b.value.compareTo(a.value) 
          : a.value.compareTo(b.value)); 

    return sortedClasses.map((e) => e.key).take(limit).toList();
  }
}

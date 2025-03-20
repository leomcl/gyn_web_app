import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class GetWeeklyWorkouts {
  final WorkoutRepository repository;

  GetWeeklyWorkouts(this.repository);

  Future<List<Workout>> call({
    required DateTime weekStart,
    String? userId,
  }) async {
    // Calculate start of the week (assuming weekStart is already the first day of week)
    final startOfWeek =
        DateTime(weekStart.year, weekStart.month, weekStart.day);

    // Calculate end of the week (7 days after start)
    final endOfWeek = startOfWeek.add(const Duration(
        days: 6, hours: 23, minutes: 59, seconds: 59, milliseconds: 999));

    if (userId != null) {
      return await repository.getWorkoutsByUserIdAndTimePeriod(
          userId, startOfWeek, endOfWeek);
    } else {
      return await repository.getWorkoutsByTimePeriod(startOfWeek, endOfWeek);
    }
  }
}

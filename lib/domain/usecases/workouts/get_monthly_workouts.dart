import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class GetMonthlyWorkouts {
  final WorkoutRepository repository;

  GetMonthlyWorkouts(this.repository);

  Future<List<Workout>> call({
    required int year,
    required int month,
    String? userId,
  }) async {
    final startOfMonth = DateTime(year, month, 1);

    // Calculate the last day of the month
    final lastDay =
        (month < 12) ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

    final endOfMonth =
        DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999);

    if (userId != null) {
      return await repository.getWorkoutsByUserIdAndTimePeriod(
          userId, startOfMonth, endOfMonth);
    } else {
      return await repository.getWorkoutsByTimePeriod(startOfMonth, endOfMonth);
    }
  }
}

import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class GetDailyWorkouts {
  final WorkoutRepository repository;

  GetDailyWorkouts(this.repository);

  Future<List<Workout>> call({required DateTime date, String? userId}) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    if (userId != null) {
      return await repository.getWorkoutsByUserIdAndTimePeriod(
          userId, startOfDay, endOfDay);
    } else {
      return await repository.getWorkoutsByTimePeriod(startOfDay, endOfDay);
    }
  }
}

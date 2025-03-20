import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class GetWorkoutsByDateRange {
  final WorkoutRepository repository;

  GetWorkoutsByDateRange(this.repository);

  Future<List<Workout>> call({
    required DateTime startDate,
    required DateTime endDate,
    String? userId,
  }) async {
    if (userId != null) {
      return await repository.getWorkoutsByUserIdAndTimePeriod(
          userId, startDate, endDate);
    } else {
      return await repository.getWorkoutsByTimePeriod(startDate, endDate);
    }
  }
}

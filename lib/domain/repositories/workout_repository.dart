import 'package:snow_stats_app/domain/entities/workout.dart';

abstract class WorkoutRepository {
  /// Get all workouts for a specific user
  Future<List<Workout>> getWorkoutsByUserId(String userId);

  /// Get all workouts within a specific time period
  Future<List<Workout>> getWorkoutsByTimePeriod(
      DateTime startDate, DateTime endDate);

  /// Get workouts for a specific user within a time period
  Future<List<Workout>> getWorkoutsByUserIdAndTimePeriod(
      String userId, DateTime startDate, DateTime endDate);

  /// Get all workouts (with optional limit)
  Future<List<Workout>> getAllWorkouts({int? limit});
}

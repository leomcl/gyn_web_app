import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class GetUserWorkouts {
  final WorkoutRepository repository;

  GetUserWorkouts(this.repository);

  Future<List<Workout>> call(String userId) async {
    return await repository.getWorkoutsByUserId(userId);
  }
}

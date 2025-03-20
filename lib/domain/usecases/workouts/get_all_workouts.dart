import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class GetAllWorkouts {
  final WorkoutRepository repository;

  GetAllWorkouts(this.repository);

  Future<List<Workout>> call({int? limit}) async {
    return await repository.getAllWorkouts(limit: limit);
  }
}

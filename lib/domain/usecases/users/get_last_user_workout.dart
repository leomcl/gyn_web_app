import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_user_workouts.dart';

class GetLastUserWorkout {
  final GetUserWorkouts getUserWorkouts;

  GetLastUserWorkout(this.getUserWorkouts);

  Future<Workout?> call(String userId) async {
    final workouts = await getUserWorkouts(userId);

    if (workouts.isEmpty) {
      return null;
    }

    return workouts.first;
  }
}

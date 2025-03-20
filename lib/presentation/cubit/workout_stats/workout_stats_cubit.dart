import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_all_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_daily_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_weekly_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_monthly_workouts.dart';
import 'package:snow_stats_app/domain/entities/workout.dart';
import 'workout_stats_state.dart';

class WorkoutStatsCubit extends Cubit<WorkoutStatsState> {
  final GetAllWorkouts getAllWorkouts;
  final GetDailyWorkouts getDailyWorkouts;
  final GetWeeklyWorkouts getWeeklyWorkouts;
  final GetMonthlyWorkouts getMonthlyWorkouts;

  WorkoutStatsCubit({
    required this.getAllWorkouts,
    required this.getDailyWorkouts,
    required this.getWeeklyWorkouts,
    required this.getMonthlyWorkouts,
  }) : super(const WorkoutStatsState());

  Future<void> loadWorkouts() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await _fetchWorkoutsByTimePeriod();

      // Filter by category if needed
      final filteredWorkouts = _filterWorkoutsByCategory(result);

      emit(state.copyWith(
        workouts: filteredWorkouts,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<List<Workout>> _fetchWorkoutsByTimePeriod() async {
    switch (state.timePeriod) {
      case TimePeriod.daily:
        return await getDailyWorkouts(date: DateTime.now());
      case TimePeriod.weekly:
        return await getWeeklyWorkouts(
            weekStart: DateTime.now().subtract(const Duration(days: 7)));
      case TimePeriod.monthly:
        final now = DateTime.now();
        return await getMonthlyWorkouts(month: now.month, year: now.year);
      default:
        return await getAllWorkouts();
    }
  }

  List<Workout> _filterWorkoutsByCategory(List<Workout> workouts) {
    if (state.category == WorkoutCategory.all) {
      return workouts;
    }

    // Filter logic based on category
    return workouts.where((workout) {
      switch (state.category) {
        case WorkoutCategory.weights:
          return workout.workoutType == 'weights';
        case WorkoutCategory.cardio:
          return workout.workoutType == 'cardio';
        case WorkoutCategory.classes:
          return workout.workoutType == 'class';
        default:
          return true;
      }
    }).toList();
  }

  void changeTimePeriod(TimePeriod timePeriod) {
    if (timePeriod != state.timePeriod) {
      emit(state.copyWith(timePeriod: timePeriod));
      loadWorkouts();
    }
  }

  void changeCategory(WorkoutCategory category) {
    if (category != state.category) {
      emit(state.copyWith(category: category));
      loadWorkouts();
    }
  }

  // Helper methods for statistics
  String getBusiestDay() {
    if (state.workouts.isEmpty) return 'N/A';
    // Logic to determine busiest day based on workout data
    return 'Monday'; // Placeholder
  }

  String getBusiestTime() {
    if (state.workouts.isEmpty) return 'N/A';
    // Logic to determine busiest time
    return '6:00 PM'; // Placeholder
  }

  String getMostUsedEquipment() {
    if (state.workouts.isEmpty) return 'N/A';
    // Logic to determine most used equipment/area
    return 'Treadmills'; // Placeholder
  }
}

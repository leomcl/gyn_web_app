import 'package:equatable/equatable.dart';
import '../../../../domain/entities/workout.dart';

enum TimePeriod { daily, weekly, monthly }

enum WorkoutCategory { all, weights, cardio, classes }

class WorkoutStatsState extends Equatable {
  final List<Workout> workouts;
  final bool isLoading;
  final String? error;
  final TimePeriod timePeriod;
  final WorkoutCategory category;

  const WorkoutStatsState({
    this.workouts = const [],
    this.isLoading = false,
    this.error,
    this.timePeriod = TimePeriod.weekly,
    this.category = WorkoutCategory.all,
  });

  WorkoutStatsState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
    String? error,
    TimePeriod? timePeriod,
    WorkoutCategory? category,
  }) {
    return WorkoutStatsState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      timePeriod: timePeriod ?? this.timePeriod,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [workouts, isLoading, error, timePeriod, category];
}

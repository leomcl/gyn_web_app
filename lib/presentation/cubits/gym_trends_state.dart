part of 'gym_trends_cubit.dart';

abstract class GymTrendsState extends Equatable {
  const GymTrendsState();
  
  @override
  List<Object?> get props => [];
}

class GymTrendsInitial extends GymTrendsState {}

class GymTrendsLoading extends GymTrendsState {}

class GymTrendsLoaded extends GymTrendsState {
  final List<int> busyTimes;
  final List<int> leastBusyTimes;
  final List<String> popularWorkouts;
  final List<String> unpopularWorkouts;
  final List<String> popularClasses;
  final List<String> unpopularClasses;
  final List<int> busiestDays;
  final List<int> leastBusyDays;

  const GymTrendsLoaded({
    required this.busyTimes,
    required this.leastBusyTimes,
    required this.popularWorkouts,
    required this.unpopularWorkouts,
    required this.popularClasses,
    required this.unpopularClasses,
    required this.busiestDays,
    required this.leastBusyDays,
  });
  
  @override
  List<Object?> get props => [
    busyTimes,
    leastBusyTimes,
    popularWorkouts,
    unpopularWorkouts,
    popularClasses,
    unpopularClasses,
    busiestDays,
    leastBusyDays,
  ];
}

class GymTrendsError extends GymTrendsState {
  final String message;
  
  const GymTrendsError({
    required this.message,
  });
  
  @override
  List<Object> get props => [message];
} 
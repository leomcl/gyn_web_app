import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/general_trends/get_busy_times.dart';
import '../../domain/usecases/general_trends/get_most_common_workout.dart';
import '../../domain/usecases/general_trends/get_busy_class.dart';
import '../../domain/usecases/general_trends/get_busy_day.dart';

part 'gym_trends_state.dart';

class GymTrendsCubit extends Cubit<GymTrendsState> {
  final GetOptimalWorkoutTimes getOptimalWorkoutTimes;
  final GetMostCommonWorkout getMostCommonWorkout;
  final GetBusyClass getBusyClass;
  final GetBusyDay getBusyDay;

  GymTrendsCubit({
    required this.getOptimalWorkoutTimes,
    required this.getMostCommonWorkout,
    required this.getBusyClass,
    required this.getBusyDay,
  }) : super(GymTrendsInitial());

  Future<void> loadTrends() async {
    emit(GymTrendsLoading());

    try {
      final now = DateTime.now();
      const limit = 3; // Number of items to show for each trend

      // Get busy times for current weekday
      final busyTimes = await getOptimalWorkoutTimes(now.weekday, limit,
          getMostFrequent: true);

      // Get least busy times for current weekday
      final leastBusyTimes = await getOptimalWorkoutTimes(now.weekday, limit,
          getMostFrequent: false);

      // Get most common workouts for current month
      final popularWorkouts = await getMostCommonWorkout(
          now.year, now.month, limit,
          getMostFrequent: true);

      // Get least common workouts for current month
      final unpopularWorkouts = await getMostCommonWorkout(
          now.year, now.month, limit,
          getMostFrequent: false);

      // Get popular classes for current month
      final popularClasses =
          await getBusyClass(now.year, now.month, limit, getMostFrequent: true);

      // Get least popular classes for current month
      final unpopularClasses = await getBusyClass(now.year, now.month, limit,
          getMostFrequent: false);

      // Get busiest days of the week
      final busiestDays =
          await getBusyDay(now.year, now.month, limit, getMostFrequent: true);

      // Get least busy days of the week
      final leastBusyDays =
          await getBusyDay(now.year, now.month, limit, getMostFrequent: false);

      emit(GymTrendsLoaded(
        busyTimes: busyTimes,
        leastBusyTimes: leastBusyTimes,
        popularWorkouts: popularWorkouts,
        unpopularWorkouts: unpopularWorkouts,
        popularClasses: popularClasses,
        unpopularClasses: unpopularClasses,
        busiestDays: busiestDays,
        leastBusyDays: leastBusyDays,
      ));
    } catch (e) {
      emit(GymTrendsError(message: e.toString()));
    }
  }
}

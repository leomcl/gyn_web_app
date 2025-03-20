import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/occupancy/get_current_occupancy.dart';
import '../../../domain/usecases/occupancy/get_peak_occupancy_hours.dart';
import '../../../domain/usecases/occupancy/get_average_occupancy_by_hour.dart';
import '../../../domain/usecases/occupancy/get_occupancy_trend_by_day.dart';
import '../../../domain/usecases/occupancy/compare_time_periods_occupancy.dart';
import 'occupancy_state.dart';

class OccupancyCubit extends Cubit<OccupancyState> {
  final GetCurrentOccupancy getCurrentOccupancy;
  final GetPeakOccupancyHours getPeakOccupancyHours;
  final GetAverageOccupancyByHour getAverageOccupancyByHour;
  final GetOccupancyTrendByDay getOccupancyTrendByDay;
  final CompareTimePeriodsOccupancy compareTimePeriodsOccupancy;

  OccupancyCubit({
    required this.getCurrentOccupancy,
    required this.getPeakOccupancyHours,
    required this.getAverageOccupancyByHour,
    required this.getOccupancyTrendByDay,
    required this.compareTimePeriodsOccupancy,
  }) : super(OccupancyState.initial());

  Future<void> loadCurrentOccupancy() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final current = await getCurrentOccupancy();
      emit(state.copyWith(
        currentOccupancy: current,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadPeakHours() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final peaks = await getPeakOccupancyHours(state.selectedDate);
      emit(state.copyWith(
        peakHours: peaks,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadAverageByHour() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate = now;

      switch (state.timePeriod) {
        case TimePeriod.daily:
          // Set start date to beginning of current day
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case TimePeriod.weekly:
          // Set start date to 7 days ago
          startDate = now.subtract(const Duration(days: 7));
          break;
        case TimePeriod.monthly:
          // Set start date to beginning of month
          startDate = DateTime(now.year, now.month, 1);
          break;
      }

      final averages = await getAverageOccupancyByHour(startDate, endDate);
      emit(state.copyWith(
        averageByHour: averages,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void changeSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    loadPeakHours();
  }

  void changeTimePeriod(TimePeriod period) {
    emit(state.copyWith(timePeriod: period));
    loadAverageByHour();
  }

  Future<void> loadAllData() async {
    await loadCurrentOccupancy();
    await loadPeakHours();
    await loadAverageByHour();
  }

  String getBusiestHourString() {
    if (state.peakHours.isEmpty) return 'N/A';

    final peakHour = state.peakHours.first;
    final hour = peakHour.hour;
    final formattedHour = hour > 12 ? '${hour - 12} PM' : '$hour AM';
    return '$formattedHour (${peakHour.currentOccupancy} people)';
  }

  int getCurrentCapacityPercentage() {
    if (state.currentOccupancy == null) return 0;
    // Assuming max capacity of 100 for demonstration
    // This could be a configurable parameter or derived from the data
    const maxCapacity = 100;
    return ((state.currentOccupancy!.currentOccupancy / maxCapacity) * 100)
        .round();
  }
}

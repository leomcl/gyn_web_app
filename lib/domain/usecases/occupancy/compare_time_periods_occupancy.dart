import 'package:snow_stats_app/domain/repositories/occupancy_repository.dart';

class CompareTimePeriodsOccupancy {
  final OccupancyRepository repository;

  CompareTimePeriodsOccupancy(this.repository);

  // Compare average occupancy between two time periods
  Future<Map<String, double>> call(DateTime firstStart, DateTime firstEnd,
      DateTime secondStart, DateTime secondEnd) async {
    // Get occupancy for both periods
    final firstPeriod =
        await repository.getOccupancyForDateRange(firstStart, firstEnd);
    final secondPeriod =
        await repository.getOccupancyForDateRange(secondStart, secondEnd);

    // Calculate average occupancy for first period
    double firstAvg = 0;
    if (firstPeriod.isNotEmpty) {
      final firstSum =
          firstPeriod.fold(0, (sum, item) => sum + item.currentOccupancy);
      firstAvg = firstSum / firstPeriod.length;
    }

    // Calculate average occupancy for second period
    double secondAvg = 0;
    if (secondPeriod.isNotEmpty) {
      final secondSum =
          secondPeriod.fold(0, (sum, item) => sum + item.currentOccupancy);
      secondAvg = secondSum / secondPeriod.length;
    }

    // Calculate percentage change
    double percentChange = 0;
    if (firstAvg > 0) {
      percentChange = ((secondAvg - firstAvg) / firstAvg) * 100;
    }

    return {
      'firstPeriodAvg': firstAvg,
      'secondPeriodAvg': secondAvg,
      'percentChange': percentChange
    };
  }
}

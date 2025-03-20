import 'package:snow_stats_app/domain/repositories/occupancy_repository.dart';

class GetOccupancyTrendByDay {
  final OccupancyRepository repository;

  GetOccupancyTrendByDay(this.repository);

  // Returns a map with day of week (1-7, Monday is 1) as key and average occupancy as value
  Future<Map<int, double>> call(DateTime startDate, DateTime endDate) async {
    final occupancies =
        await repository.getOccupancyForDateRange(startDate, endDate);

    // Group occupancies by day of week
    final Map<int, List<int>> occupanciesByDay = {};

    for (var occupancy in occupancies) {
      final dayOfWeek = occupancy.date.weekday;
      if (!occupanciesByDay.containsKey(dayOfWeek)) {
        occupanciesByDay[dayOfWeek] = [];
      }
      occupanciesByDay[dayOfWeek]!.add(occupancy.currentOccupancy);
    }

    // Calculate average for each day
    final Map<int, double> averageByDay = {};
    occupanciesByDay.forEach((day, values) {
      if (values.isNotEmpty) {
        final sum = values.reduce((a, b) => a + b);
        averageByDay[day] = sum / values.length;
      }
    });

    return averageByDay;
  }
}

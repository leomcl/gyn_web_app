import 'package:snow_stats_app/domain/repositories/occupancy_repository.dart';

class GetAverageOccupancyByHour {
  final OccupancyRepository repository;

  GetAverageOccupancyByHour(this.repository);

  // Returns a map with hour (0-23) as key and average occupancy as value
  Future<Map<int, double>> call(DateTime startDate, DateTime endDate) async {
    final occupancies =
        await repository.getOccupancyForDateRange(startDate, endDate);

    // Group occupancies by hour
    final Map<int, List<int>> occupanciesByHour = {};

    for (var occupancy in occupancies) {
      final hour = occupancy.hour;
      if (!occupanciesByHour.containsKey(hour)) {
        occupanciesByHour[hour] = [];
      }
      occupanciesByHour[hour]!.add(occupancy.currentOccupancy);
    }

    // Calculate average for each hour
    final Map<int, double> averageByHour = {};
    occupanciesByHour.forEach((hour, values) {
      if (values.isNotEmpty) {
        final sum = values.reduce((a, b) => a + b);
        averageByHour[hour] = sum / values.length;
      }
    });

    return averageByHour;
  }
}

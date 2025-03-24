import '../../repositories/occupancy_repository.dart';

class GetOptimalWorkoutTimes {
  final OccupancyRepository occupancyRepository;

  GetOptimalWorkoutTimes({
    required this.occupancyRepository,
  });

  Future<List<int>> call(int day, int limit,
      {int daysToConsider = 30, bool getMostFrequent = true}) async {
    if (day < 1 || day > 7) {
      throw ArgumentError('Day must be between 1 and 7, where Monday is 1');
    }

    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: daysToConsider));

    final occupancies =
        await occupancyRepository.getOccupancyForDateRange(startDate, endDate);

    final Map<int, List<int>> occupancyByHour = {};

    for (var occupancy in occupancies) {
      if (occupancy.date.weekday == day) {
        final hour = occupancy.hour;

        if (!occupancyByHour.containsKey(hour)) {
          occupancyByHour[hour] = [];
        }

        occupancyByHour[hour]!.add(occupancy.currentOccupancy);
      }
    }

    // Calculate average occupancy for each hour
    final Map<int, double> averageOccupancyByHour = {};

    occupancyByHour.forEach((hour, occupancies) {
      if (occupancies.isNotEmpty) {
        final sum = occupancies.reduce((a, b) => a + b);
        averageOccupancyByHour[hour] = sum / occupancies.length;
      }
    });

    if (averageOccupancyByHour.isEmpty) {
      return [];
    }

    final sortedHours = averageOccupancyByHour.entries.toList()
      ..sort((a, b) => getMostFrequent
          ? a.value.compareTo(b.value) 
          : b.value.compareTo(a.value)); 

    return sortedHours.take(limit).map((entry) => entry.key).toList();
  }
}

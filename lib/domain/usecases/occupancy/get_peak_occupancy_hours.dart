import '../../entities/occupancy.dart';
import 'package:snow_stats_app/domain/repositories/occupancy_repository.dart';

class GetPeakOccupancyHours {
  final OccupancyRepository repository;

  GetPeakOccupancyHours(this.repository);

  Future<List<Occupancy>> call(DateTime date, {int limit = 3}) async {
    final occupancies = await repository.getOccupancyForDate(date);

    // Sort by occupancy (highest first)
    occupancies
        .sort((a, b) => b.currentOccupancy.compareTo(a.currentOccupancy));

    // Return top hours
    return occupancies.take(limit).toList();
  }
}

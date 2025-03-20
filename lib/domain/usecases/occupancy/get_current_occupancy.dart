import '../../entities/occupancy.dart';
import 'package:snow_stats_app/domain/repositories/occupancy_repository.dart';

class GetCurrentOccupancy {
  final OccupancyRepository repository;

  GetCurrentOccupancy(this.repository);

  Future<Occupancy> call() async {
    final now = DateTime.now();
    return repository.getOccupancyForHour(now);
  }
}

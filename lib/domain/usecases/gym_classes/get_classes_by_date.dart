import 'package:snow_stats_app/domain/entities/gym_class.dart';
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class GetClassesByDate {
  final GymClassRepository repository;

  GetClassesByDate(this.repository);

  Future<List<GymClass>> call(DateTime date) async {
    return await repository.getClassesByDate(date);
  }
}

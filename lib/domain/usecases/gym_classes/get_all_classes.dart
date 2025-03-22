import 'package:snow_stats_app/domain/entities/gym_class.dart';
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class GetAllClasses {
  final GymClassRepository repository;

  GetAllClasses(this.repository);

  Future<List<GymClass>> call() async {
    return await repository.getAllClasses();
  }
}

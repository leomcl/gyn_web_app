import 'package:snow_stats_app/domain/entities/gym_class.dart';
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class GetClassById {
  final GymClassRepository repository;

  GetClassById(this.repository);

  Future<GymClass?> call(String classId) async {
    return await repository.getClassById(classId);
  }
}

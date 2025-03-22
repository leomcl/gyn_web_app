import 'package:snow_stats_app/domain/entities/gym_class.dart';
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class UpdateClass {
  final GymClassRepository repository;

  UpdateClass(this.repository);

  Future<void> call(GymClass gymClass) async {
    await repository.updateClass(gymClass);
  }
}

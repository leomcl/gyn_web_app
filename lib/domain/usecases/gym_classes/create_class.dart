import 'package:snow_stats_app/domain/entities/gym_class.dart';
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class CreateClass {
  final GymClassRepository repository;

  CreateClass(this.repository);

  Future<String> call(GymClass gymClass) async {
    return await repository.createClass(gymClass);
  }
}

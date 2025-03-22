import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class DeleteClass {
  final GymClassRepository repository;

  DeleteClass(this.repository);

  Future<void> call(String classId) async {
    await repository.deleteClass(classId);
  }
}

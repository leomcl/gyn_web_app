import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/domain/repositories/users_repository.dart';

class GetAllUsers {
  final UsersRepository _repository;

  GetAllUsers(this._repository);

  /// Executes the usecase to retrieve all users from the repository
  Future<List<User>> execute() async {
    return await _repository.getAllUsers();
  }
}

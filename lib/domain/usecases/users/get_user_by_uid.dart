import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/domain/repositories/users_repository.dart';

class GetUserByUid {
  final UsersRepository _repository;

  GetUserByUid(this._repository);

  /// Executes the usecase to retrieve a user by their UID
  ///
  /// [uid] - The unique identifier of the user to retrieve
  /// Returns the User entity if found, null otherwise
  Future<User?> execute(String uid) async {
    return await _repository.getUserById(uid);
  }
}

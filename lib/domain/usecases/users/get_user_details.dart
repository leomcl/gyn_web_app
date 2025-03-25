import 'package:snow_stats_app/domain/entities/user_details.dart';
import 'package:snow_stats_app/domain/repositories/users_repository.dart';

class GetUserDetails {
  final UsersRepository _repository;

  GetUserDetails(this._repository);

  /// Executes the usecase to retrieve detailed user information by their UID
  ///
  /// [uid] - The unique identifier of the user to retrieve details for
  /// Returns the UserDetails entity if found, throws an exception otherwise
  Future<UserDetails> execute(String uid) async {
    final user = await _repository.getUserById(uid);
    if (user == null) {
      throw Exception('User not found');
    }

    // In a real application, you would fetch additional user details from a repository
    // For now, we'll just create UserDetails from the User entity as a placeholder
    return UserDetails.fromUser(user);
  }
}

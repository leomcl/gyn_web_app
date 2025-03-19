import 'package:snow_stats_app/domain/entities/user.dart';

abstract class UsersRepository {
  /// Get all users from Firestore
  Future<List<User>> getAllUsers();

  /// Get a specific user by their ID
  Future<User?> getUserById(String uid);
}

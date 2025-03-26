import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/domain/usecases/users/get_all_users.dart';
import 'package:snow_stats_app/domain/usecases/users/get_last_user_workout.dart';

class GetUsersWithLastWorkout {
  final GetAllUsers _getAllUsers;
  final GetLastUserWorkout _getLastUserWorkout;

  GetUsersWithLastWorkout({
    required GetAllUsers getAllUsers,
    required GetLastUserWorkout getLastUserWorkout,
  })  : _getAllUsers = getAllUsers,
        _getLastUserWorkout = getLastUserWorkout;

  /// Executes the usecase to retrieve all users with their last workout date
  Future<List<User>> execute() async {
    // Get all users
    final users = await _getAllUsers.execute();

    // Enrich each user with their last workout date
    final enrichedUsers = <User>[];

    for (final user in users) {
      final lastWorkout = await _getLastUserWorkout(user.uid);
      final enrichedUser = User(
        uid: user.uid,
        email: user.email,
        role: user.role,
        membershipStatus: user.membershipStatus,
        lastWorkoutDate: lastWorkout?.entryTime,
      );
      enrichedUsers.add(enrichedUser);
    }

    return enrichedUsers;
  }
}

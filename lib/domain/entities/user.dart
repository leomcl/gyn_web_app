import 'package:snow_stats_app/domain/usecases/users/get_last_user_workout.dart';

class User {
  final String uid;
  final String email;
  final String? role;
  final bool membershipStatus;
  final DateTime? lastWorkoutDate;

  User({
    required this.uid,
    required this.email,
    this.role,
    this.membershipStatus = false,
    this.lastWorkoutDate,
  });

  /// Creates a new User with the last workout date
  User copyWithLastWorkoutDate(DateTime? lastWorkoutDate) {
    return User(
      uid: this.uid,
      email: this.email,
      role: this.role,
      membershipStatus: this.membershipStatus,
      lastWorkoutDate: lastWorkoutDate,
    );
  }
}

/// Extension to help with populating the last workout date
extension UserLastWorkoutExtension on User {
  /// Returns a new User with the last workout date populated from the given workout
  Future<User> withLastWorkout(GetLastUserWorkout getLastUserWorkout) async {
    final lastWorkout = await getLastUserWorkout(this.uid);
    return this.copyWithLastWorkoutDate(lastWorkout?.entryTime);
  }
}

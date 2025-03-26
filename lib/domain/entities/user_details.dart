import 'package:snow_stats_app/domain/entities/user.dart';

class UserDetails {
  final String uid;
  final String email;
  final String? role;
  final bool membershipStatus;
  final List<int> preferredDays;
  final List<String> preferredWorkouts;
  final DateTime? lastWorkoutDate;

  UserDetails({
    required this.uid,
    required this.email,
    this.role,
    this.membershipStatus = false,
    this.preferredDays = const [],
    this.preferredWorkouts = const [],
    this.lastWorkoutDate,
  });

  factory UserDetails.fromUser(User user) {
    return UserDetails(
      uid: user.uid,
      email: user.email,
      role: user.role,
      membershipStatus: user.membershipStatus,
      lastWorkoutDate: user.lastWorkoutDate,
    );
  }
}

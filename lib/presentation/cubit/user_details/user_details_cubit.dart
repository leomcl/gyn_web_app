import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/domain/entities/user_details.dart';
import 'package:snow_stats_app/domain/usecases/users/get_user_details.dart';
import 'package:snow_stats_app/domain/usecases/user_trends/get_user_prefered_day.dart';
import 'package:snow_stats_app/domain/usecases/user_trends/get_user_prefered_workout.dart';
import 'package:snow_stats_app/presentation/cubit/user_details/user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final GetUserDetails _getUserDetails;
  final GetUserPreferedDays _getUserPreferedDays;
  final GetUserPreferedWorkout _getUserPreferedWorkout;

  UserDetailsCubit({
    required GetUserDetails getUserDetails,
    required GetUserPreferedDays getUserPreferedDays,
    required GetUserPreferedWorkout getUserPreferedWorkout,
  })  : _getUserDetails = getUserDetails,
        _getUserPreferedDays = getUserPreferedDays,
        _getUserPreferedWorkout = getUserPreferedWorkout,
        super(UserDetailsInitial());

  /// Loads detailed information for a specific user
  Future<void> loadUserDetails(String uid) async {
    emit(UserDetailsLoading());

    try {
      // Get basic user details
      final userDetails = await _getUserDetails.execute(uid);

      // Get preferred days and workouts (limit to top 3)
      List<int> preferredDays = [];
      List<String> preferredWorkouts = [];

      try {
        preferredDays = await _getUserPreferedDays(uid, 3);
      } catch (e) {
        // If failed to load preferred days, continue with empty list
        print('Failed to load preferred days: $e');
      }

      try {
        preferredWorkouts = await _getUserPreferedWorkout(uid, 3);
      } catch (e) {
        // If failed to load preferred workouts, continue with empty list
        print('Failed to load preferred workouts: $e');
      }

      // Create a new UserDetails object with the additional information
      final enrichedDetails = UserDetails(
        uid: userDetails.uid,
        email: userDetails.email,
        role: userDetails.role,
        membershipStatus: userDetails.membershipStatus,
        preferredDays: preferredDays,
        preferredWorkouts: preferredWorkouts,
      );

      emit(UserDetailsLoaded(enrichedDetails));
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }

  /// Clears the user details state
  void clearUserDetails() {
    emit(UserDetailsInitial());
  }
}

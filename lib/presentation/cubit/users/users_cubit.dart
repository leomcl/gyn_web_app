import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/domain/usecases/users/get_users_with_last_workout.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_state.dart';
import 'package:get_it/get_it.dart';
import 'package:snow_stats_app/domain/repositories/auth_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsersWithLastWorkout _getUsersWithLastWorkout;
  List<User> _allUsers = []; // Store all users for filtering

  UsersCubit({required GetUsersWithLastWorkout getUsersWithLastWorkout})
      : _getUsersWithLastWorkout = getUsersWithLastWorkout,
        super(UsersInitial());

  Future<void> loadUsers() async {
    try {
      emit(UsersLoading());

      // Get current auth repository and check authentication status
      final authRepo = GetIt.I<AuthRepository>();
      final currentUser = await authRepo.currentUser;

      if (currentUser == null) {
        emit(UsersError('User authentication required'));
        return;
      }

      // Load users with workout data
      final users = await _getUsersWithLastWorkout.execute();
      _allUsers = users; // Store complete list
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  // New method to handle both search and filter
  Future<void> filterUsers(String query, String filter) async {
    if (_allUsers.isEmpty) {
      await loadUsers();
      return;
    }

    List<User> filteredUsers = List.from(_allUsers);

    // Apply text search filter
    if (query.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        final email = user.email.toLowerCase();
        final searchLower = query.toLowerCase();
        return email.contains(searchLower);
      }).toList();
    }

    // Apply category filter
    switch (filter) {
      case 'Premium':
        filteredUsers =
            filteredUsers.where((user) => user.membershipStatus).toList();
        break;
      case 'Basic':
        filteredUsers =
            filteredUsers.where((user) => !user.membershipStatus).toList();
        break;
      case 'Inactive Premium':
        filteredUsers = filteredUsers
            .where((user) =>
                user.membershipStatus &&
                (user.lastWorkoutDate == null ||
                    user.lastWorkoutDate!.isBefore(
                        DateTime.now().subtract(const Duration(days: 30)))))
            .toList();
        break;
      // 'All' case doesn't need filtering
    }

    emit(UsersLoaded(filteredUsers));
  }

  // Keep the existing searchUsers method for backward compatibility
  // Or update it to call filterUsers with the current filter
  Future<void> searchUsers(String query) async {
    if (state is UsersLoaded) {
      final currentFilter = (state as UsersLoaded).currentFilter ?? 'All';
      filterUsers(query, currentFilter);
    } else {
      await loadUsers();
    }
  }
}

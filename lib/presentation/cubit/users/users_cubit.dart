import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/domain/usecases/users/get_all_users.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_state.dart';
import 'package:get_it/get_it.dart';
import 'package:snow_stats_app/domain/repositories/auth_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetAllUsers _getAllUsers;

  UsersCubit({required GetAllUsers getAllUsers})
      : _getAllUsers = getAllUsers,
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

      // If we got here, we have a valid user, fetch the users list
      final users = await _getAllUsers.execute();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  // Optional: add filter functionality
  Future<void> searchUsers(String query) async {
    try {
      if (state is UsersLoaded) {
        final allUsers = (state as UsersLoaded).users;

        if (query.isEmpty) {
          emit(UsersLoaded(allUsers));
          return;
        }

        final filteredUsers = allUsers.where((user) {
          final email = user.email.toLowerCase();
          final searchLower = query.toLowerCase();
          return email.contains(searchLower);
        }).toList();

        emit(UsersLoaded(filteredUsers));
      } else {
        await loadUsers();
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}

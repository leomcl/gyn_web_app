import 'package:snow_stats_app/domain/repositories/auth_repository.dart';
import 'package:snow_stats_app/domain/entities/user.dart';

class GetCurrentUser {
  final AuthRepository _authRepository;

  GetCurrentUser(this._authRepository);

  Future<User?> call() async {
    return _authRepository.currentUser;
  }
} 
import 'package:snow_stats_app/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<void> call(String email, String password, String role) async {
    return await repository.createUserWithEmailAndPassword(
      email, 
      password, 
      role
    );
  }
} 
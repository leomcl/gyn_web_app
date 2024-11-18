import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthUnauthenticated()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Validate email format
        if (!_isValidEmail(event.email)) {
          emit(const AuthError('Please enter a valid email address'));
          return;
        }

        // Validate password length
        if (event.password.length < 6) {
          emit(const AuthError('Password must be at least 6 characters long'));
          return;
        }

        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated());
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-not-found':
            emit(const AuthError('No user found with this email'));
            break;
          case 'wrong-password':
            emit(const AuthError('Wrong password provided'));
            break;
          case 'invalid-email':
            emit(const AuthError('Invalid email address format'));
            break;
          case 'user-disabled':
            emit(const AuthError('This user account has been disabled'));
            break;
          default:
            emit(AuthError(e.message ?? 'An error occurred during login'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Validate email format
        if (!_isValidEmail(event.email)) {
          emit(const AuthError('Please enter a valid email address'));
          return;
        }

        // Validate password length
        if (event.password.length < 6) {
          emit(const AuthError('Password must be at least 6 characters long'));
          return;
        }

        await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated());
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            emit(const AuthError('An account already exists with this email'));
            break;
          case 'invalid-email':
            emit(const AuthError('Invalid email address format'));
            break;
          case 'operation-not-allowed':
            emit(const AuthError('Email/password accounts are not enabled'));
            break;
          case 'weak-password':
            emit(const AuthError('The password provided is too weak'));
            break;
          default:
            emit(AuthError(
                e.message ?? 'An error occurred during registration'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signOut();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }
}

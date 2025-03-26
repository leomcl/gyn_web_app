import 'package:equatable/equatable.dart';
import 'package:snow_stats_app/domain/entities/user.dart';

abstract class UsersState extends Equatable {
  const UsersState();
  
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  final String? currentFilter;
  
  const UsersLoaded(this.users, {this.currentFilter = 'All'});
  
  @override
  List<Object?> get props => [users, currentFilter];
}

class UsersError extends UsersState {
  final String message;
  
  const UsersError(this.message);
  
  @override
  List<Object?> get props => [message];
}
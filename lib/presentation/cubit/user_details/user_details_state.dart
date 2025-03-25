import 'package:equatable/equatable.dart';
import 'package:snow_stats_app/domain/entities/user_details.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final UserDetails userDetails;

  const UserDetailsLoaded(this.userDetails);

  @override
  List<Object?> get props => [userDetails];
}

class UserDetailsError extends UserDetailsState {
  final String message;

  const UserDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

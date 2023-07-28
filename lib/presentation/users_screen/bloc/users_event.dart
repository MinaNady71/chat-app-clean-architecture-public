part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class GetAllUsersEvent extends UsersEvent {
  @override
  List<Object> get props => [];
}

class RefreshUsersEvent extends UsersEvent {
  @override
  List<Object> get props => [];
}

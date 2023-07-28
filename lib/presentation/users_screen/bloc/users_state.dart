part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();
}

class UsersInitialState extends UsersState {
  @override
  List<Object> get props => [];
}
class UsersLoadingState extends UsersState {
  @override
  List<Object> get props => [];

}
class UsersRefreshLoadingState extends UsersState {
  @override
  List<Object> get props => [];

}
class UsersSuccessState extends UsersState {
  final List<UserModel> list;
  const UsersSuccessState(this.list);
  @override
  List<Object> get props => [];
}
class UsersFailureState extends UsersState {
  final Failure failure;
  const UsersFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}
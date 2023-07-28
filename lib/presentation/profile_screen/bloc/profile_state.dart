part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object> get props => [];

}
class ProfileSuccessState extends ProfileState {
  final UserModel userModel;
  const ProfileSuccessState(this.userModel);
  @override
  List<Object> get props => [userModel];
}
class ProfileFailureState extends ProfileState {
  final Failure failure;
  const ProfileFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}
class UpdateProfileLoadingState extends ProfileState {
  @override
  List<Object> get props => [];

}
class UpdateCurrentUsersProfileWithImageLoadingState extends ProfileState {
  @override
  List<Object> get props => [];

}
class UpdateProfileFailureState extends ProfileState {
  final Failure failure;
  const UpdateProfileFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}

class SignOutProfileFailureState extends ProfileState {
  final Failure failure;
  const SignOutProfileFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}
class SignOutProfileLoadingState extends ProfileState {
  @override
  List<Object> get props => [];

}
class SignOutProfileSuccessState extends ProfileState {
  @override
  List<Object> get props => [];

}
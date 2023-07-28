part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetCurrentUsersProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateCurrentUsersProfileEvent extends ProfileEvent {
  final UserResponse userResponse;

  const UpdateCurrentUsersProfileEvent(this.userResponse);

  @override
  List<Object> get props => [userResponse];
}

class UpdateCurrentUsersProfileWithImageEvent extends ProfileEvent {
  final File imageFile;
  final UserResponse userResponse;

  const UpdateCurrentUsersProfileWithImageEvent(
      this.imageFile, this.userResponse);

  @override
  List<Object> get props => [imageFile, userResponse];
}

class SignOutProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

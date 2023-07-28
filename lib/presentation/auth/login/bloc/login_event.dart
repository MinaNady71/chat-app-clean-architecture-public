part of 'login_bloc.dart';

abstract class UsersLoginEvent extends Equatable {
  const UsersLoginEvent();
}

class LoginEvent extends UsersLoginEvent {
  final String email;
  final String password;

  const LoginEvent(
    this.email,
    this.password,
  );

  @override
  List<Object?> get props => [email, password];
}

class SignInWithGoogleEvent extends UsersLoginEvent {
  @override
  List<Object?> get props => [];
}

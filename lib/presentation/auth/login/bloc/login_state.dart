part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}
// login State

class LoginInitialState extends LoginState {
  @override
  List<Object> get props => [];
}
class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];

}
class LoginSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}
class LoginFailureState extends LoginState {
 final Failure failure;
  const LoginFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}




// SignInWithGoogle State


class SignInWithGoogleLoadingState extends LoginState {
  @override
  List<Object> get props => [];

}
class SignInWithGoogleSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}
class SignInWithGoogleFailureState extends LoginState {
  final Failure failure;
  const SignInWithGoogleFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}
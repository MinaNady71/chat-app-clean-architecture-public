part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  @override
  List<Object> get props => [];

}
class ForgotPasswordSuccessState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}
class ForgotPasswordFailureState extends ForgotPasswordState {
  final Failure failure;
  const ForgotPasswordFailureState(this.failure);
  @override
  List<Object> get props => [failure];
  }

class ForgotPasswordDisableButtonState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}
class ForgotPasswordCountDownState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordEnableButtonState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}
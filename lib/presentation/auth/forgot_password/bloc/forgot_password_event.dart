part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEventParent extends Equatable {
  const ForgotPasswordEventParent();
}

class ForgotPasswordEvent extends ForgotPasswordEventParent {
  final String email;

  const ForgotPasswordEvent(
    this.email,
  );

  @override
  List<Object?> get props => [
        email,
      ];
}

class ForgotPasswordDisableButtonEvent extends ForgotPasswordEventParent {
  @override
  List<Object?> get props => [];
}
class ForgotPasswordEnableButtonEvent extends ForgotPasswordEventParent {
  @override
  List<Object?> get props => [];
}

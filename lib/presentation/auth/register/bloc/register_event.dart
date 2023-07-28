part of 'register_bloc.dart';

abstract class USerRegisterEvent extends Equatable {
  const USerRegisterEvent();
}

class RegisterEvent extends USerRegisterEvent {
  final String email;
  final String password;
  final UserResponse userResponse;

  const RegisterEvent(
    this.email,
    this.password,
    this.userResponse,
  );

  @override
  List<Object?> get props => [email, password,userResponse];
}

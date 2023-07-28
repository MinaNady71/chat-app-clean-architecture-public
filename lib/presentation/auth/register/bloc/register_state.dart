part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterLoadingState extends RegisterState {
  @override
  List<Object> get props => [];

}
class RegisterSuccessState extends RegisterState {
  @override
  List<Object> get props => [];
}
class RegisterFailureState extends RegisterState {
  final Failure failure;
  const RegisterFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}


import 'package:bloc/bloc.dart';
import 'package:chat_app/data/network/failure.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../domain/use_cases/auth/login_use_case.dart';
import '../../../../domain/use_cases/auth/sign_in_with_google_use_case.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<UsersLoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  LoginBloc(
      this._loginUseCase, this._signInWithGoogleUseCase,)
      : super(LoginInitialState()) {
    on<UsersLoginEvent>((event, emit) async {
      // login event

      if (event is LoginEvent) {
        emit(LoginLoadingState());
        (await _loginUseCase
                .execute(LoginUseCaseInput(event.email, event.password)))
            .fold(
                (failure) => emit(
                    LoginFailureState(Failure(failure.code, failure.message))),
                (response) => emit(LoginSuccessState()));
      }

      // SignInWithGoogle event
      if (event is SignInWithGoogleEvent) {
        emit(SignInWithGoogleLoadingState());
        (await _signInWithGoogleUseCase.execute(null)).fold(
            (failure) => emit(SignInWithGoogleFailureState(
                Failure(failure.code, failure.message))), (response) {
          emit(SignInWithGoogleSuccessState());
        });
      }
    });
  }

  @override
  void onTransition(Transition<UsersLoginEvent, LoginState> transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(transition);
  }
}

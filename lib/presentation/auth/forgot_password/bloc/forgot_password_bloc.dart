import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/network/failure.dart';
import '../../../../domain/use_cases/auth/forgot_password_use_case.dart';
import '../../../resources/constants_manager.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEventParent, ForgotPasswordState> {
  final ForgotPasswordUseCase _passwordUseCase;
  bool isEmailSent = true;
  int countDown = 60;

  ForgotPasswordBloc(this._passwordUseCase)
      : super(ForgotPasswordInitialState()) {
    on<ForgotPasswordEventParent>((event, emit) async {
      if (event is ForgotPasswordEvent) {
        emit(ForgotPasswordLoadingState());
        (await _passwordUseCase.execute(event.email)).fold(
            (failure) => emit(ForgotPasswordFailureState(
                Failure(failure.code, failure.message))), (response) {
          disableButton();
          emit(ForgotPasswordSuccessState());
        });
      }
    });
  }

  void disableButton() {
    countDownMethod();
    isEmailSent = false;
    emit(ForgotPasswordDisableButtonState());
    Future.delayed(const Duration(seconds: AppConstants.timerResetPassword), () {
      isEmailSent = true;
      emit(ForgotPasswordEnableButtonState());
    });
  }

  countDownMethod() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countDown--;
      emit(ForgotPasswordCountDownState());
      if (countDown == 0) {
        timer.cancel();
      }
    });
  }
}

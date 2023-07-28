
import 'package:bloc/bloc.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/network/failure.dart';

import '../../../../domain/use_cases/auth/register_use_case.dart';
import '../../../../domain/use_cases/user/add_user_use_case.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterAuthUseCase _registerUseCase;
  final AddUserUseCase _addUserUseCase;

  RegisterBloc(this._registerUseCase,this._addUserUseCase) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async{
        emit(RegisterLoadingState());
        (await _registerUseCase
                .execute(RegisterUseCaseInput(event.email, event.password)))
          .fold((failure) => emit(RegisterFailureState(Failure(failure.code, failure.message))),
      (response) {
        _addUserUseCase.execute(event.userResponse);
        emit(RegisterSuccessState());
      });

    });
  }
}

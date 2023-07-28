import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../data/network/failure.dart';
import '../../../domain/models/models.dart';
import '../../../domain/use_cases/user/get_all_users_use_case.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUsersUseCase _allUsersUseCase;
    List<UserModel> searchPageList = [];
  UsersBloc(this._allUsersUseCase) : super(UsersInitialState()) {
    on<UsersEvent>((event, emit) async {
      if(event is GetAllUsersEvent) {
        emit(UsersLoadingState());
        (await _allUsersUseCase.execute(null)).fold((failure) {
          emit(UsersFailureState(failure));
        }, (response) {
          searchPageList.clear();
          searchPageList.addAll(response);
          emit(UsersSuccessState(response));
        });
      }
      if(event is RefreshUsersEvent) {
        emit(UsersRefreshLoadingState());
        (await _allUsersUseCase.execute(null)).fold((failure) {
          emit(UsersFailureState(failure));
        }, (response) {
          searchPageList.clear();
          searchPageList.addAll(response);
          emit(UsersSuccessState(response));
        });
      }
    });

  }

  @override
  void onTransition(Transition<UsersEvent, UsersState> transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(transition);
  }
}

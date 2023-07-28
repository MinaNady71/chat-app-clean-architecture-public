import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/use_cases/chat/get_all_friends_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../data/network/failure.dart';
import '../../../domain/models/models.dart';
import '../../../domain/use_cases/chat/get_unread_count_messages_use_case.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final GetAllFriendsUseCase _allFriendsUseCase;
  final GetUnreadMessagesUseCase _getUnreadMessagesUseCase;
  late Stream<List<CountUnreadMessagesModel>> unreadCountMessagesStream;

 static List<UserModel> listUserModel = [];

  ChatBloc(this._allFriendsUseCase, this._getUnreadMessagesUseCase)
      : super(ChatBlocInitialState()) {
    on<ChatBlocEvent>((event, emit) async {
      if (event is GetAllChatBlocEvent) {
        emit(ChatBlocLoadingState());
        (await _allFriendsUseCase.execute(null)).fold((failure) {
          emit(ChatBlocFailureState(failure));
        }, (response) {
          listUserModel.clear();
          listUserModel.addAll(response);
          emit(ChatBlocSuccessState(response));
        });
      }
      if (event is RefreshChatBlocEvent) {
        emit(ChatBlocRefreshLoadingState());
        (await _allFriendsUseCase.execute(null)).fold((failure) {
          emit(ChatBlocFailureState(failure));
        }, (response) {
          listUserModel.clear();
          listUserModel.addAll(response);
          emit(ChatBlocSuccessState(response));
        });
      }
    });
    on<ChatGetUnreadMessagesGetMessagesEvent>((event, emit) {
      (_getUnreadMessagesUseCase.execute()).fold((l) => null, (response) {
        unreadCountMessagesStream = response;
      });
    });
  }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(transition);
  }
}

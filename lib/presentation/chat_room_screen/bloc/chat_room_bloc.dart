import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/use_cases/chat/get_messages_use_case.dart';
import 'package:flutter/foundation.dart';

import '../../../data/network/failure.dart';
import '../../../domain/models/models.dart';
import '../../../domain/use_cases/chat/add_chat_use_case.dart';
import '../../../domain/use_cases/chat/add_in_friends_list.dart';
import '../../../domain/use_cases/chat/add_unread_count_messages_chat_use_case.dart';
import '../../../domain/use_cases/chat/am_i_in_chat_room_chat_use_case.dart';
import '../../../domain/use_cases/chat/reset_unread_count_messages_chat_use_case.dart';

part 'chat_room_event.dart';

part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final AddMessageUseCase _addMessageUseCase;
  final GetMessageUseCase _getMessageUseCase;
  final AddInFriendsListUseCase _addInFriendsListUseCase;
  final AddUnreadCountMessagesUseCase _addUnreadCountMessagesUseCase;
  final AmIInChatRoomUseCase _inChatRoomUseCase;
  final ResetUnreadCountMessagesUseCase _resetUnreadCountMessagesUseCase;
  ChatRoomBloc(
    this._addMessageUseCase,
    this._getMessageUseCase,
    this._addInFriendsListUseCase,
    this._addUnreadCountMessagesUseCase,
    this._inChatRoomUseCase,
    this._resetUnreadCountMessagesUseCase,
  ) : super(ChatRoomInitial()) {
    on<ChatRoomAddMessageEvent>((event, emit) async {
      (await _addMessageUseCase.execute(event.messagesResponse)).fold(
          (failure) => emit(ChatRoomAddMessageFailureState(failure)),
          (r) => null);
    });
    on<ChatRoomAddInFriendsListEvent>((event, emit) async {
      await _addInFriendsListUseCase.execute(event.toUid);
    });
    on<ChatRoomGetMessagesEvent>((event, emit) {
      emit(ChatRoomGetMessagesLoadingState());
      ( _getMessageUseCase.execute(event.toUid)).fold((failure) {
        emit(ChatRoomGetMessagesFailureState(failure));
      }, (response) {
        response;
        emit(ChatRoomGetMessagesSuccessState(response));
      });

    });

    on<ResetUnreadCountMessagesEvent>((event, emit)async {
      await _resetUnreadCountMessagesUseCase.execute(event.toUid);
    });

    on<AmIInChatRoomEvent>((event, emit)async {
      await _inChatRoomUseCase.execute(event.toUid,event.inChatRoom);
    });
    on<AddUnreadCountMessagesEvent>((event, emit) async{
        await _addUnreadCountMessagesUseCase.execute(event.toUid);
    });
  }

  @override
  void onTransition(Transition<ChatRoomEvent, ChatRoomState> transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(transition);
  }
}

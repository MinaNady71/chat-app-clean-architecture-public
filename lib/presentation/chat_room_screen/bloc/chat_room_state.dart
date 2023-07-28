part of 'chat_room_bloc.dart';

abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomAddMessageState extends ChatRoomState {}
class ChatRoomAddMessageFailureState extends ChatRoomState {
  Failure failure;
  ChatRoomAddMessageFailureState(this.failure);
}

class ChatRoomGetMessagesLoadingState extends ChatRoomState {}

class ChatRoomGetMessagesSuccessState extends ChatRoomState {
  Stream<List<MessagesModel>> chatStream;
  ChatRoomGetMessagesSuccessState(this.chatStream);
}

class ChatRoomGetMessagesFailureState extends ChatRoomState {
  Failure failure;
  ChatRoomGetMessagesFailureState(this.failure);
}

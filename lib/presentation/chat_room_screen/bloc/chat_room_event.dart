part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent {}
class ChatRoomAddMessageEvent extends ChatRoomEvent {
  MessagesResponse messagesResponse;
  ChatRoomAddMessageEvent(this.messagesResponse);
}
class ChatRoomGetMessagesEvent extends ChatRoomEvent {
  String toUid;
  ChatRoomGetMessagesEvent(this.toUid);
}

class ChatRoomAddInFriendsListEvent extends ChatRoomEvent {
  String toUid;
  ChatRoomAddInFriendsListEvent(this.toUid);
}

class ResetUnreadCountMessagesEvent extends ChatRoomEvent {
  String toUid;
  ResetUnreadCountMessagesEvent(this.toUid);
}

class AmIInChatRoomEvent extends ChatRoomEvent {
  String toUid;
  bool inChatRoom;
  AmIInChatRoomEvent(this.toUid,this.inChatRoom);
}

class AddUnreadCountMessagesEvent extends ChatRoomEvent {
  String toUid;
  AddUnreadCountMessagesEvent(this.toUid);
}


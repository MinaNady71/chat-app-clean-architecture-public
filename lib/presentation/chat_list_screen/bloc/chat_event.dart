part of 'chat_bloc.dart';

abstract class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();
}

class GetAllChatBlocEvent extends ChatBlocEvent {
  @override
  List<Object> get props => [];
}

class RefreshChatBlocEvent extends ChatBlocEvent {
  @override
  List<Object> get props => [];
}

class ChatGetUnreadMessagesGetMessagesEvent extends ChatBlocEvent {
  @override
  List<Object> get props => [];
}

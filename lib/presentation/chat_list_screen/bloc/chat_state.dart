part of 'chat_bloc.dart';

abstract class ChatBlocState extends Equatable {
  const ChatBlocState();
}

class ChatBlocInitialState extends ChatBlocState {
  @override
  List<Object> get props => [];
}
class ChatBlocLoadingState extends ChatBlocState {
  @override
  List<Object> get props => [];

}
class ChatBlocRefreshLoadingState extends ChatBlocState {
  @override
  List<Object> get props => [];

}
class ChatBlocSuccessState extends ChatBlocState {
  final List<UserModel> list;
  const ChatBlocSuccessState(this.list);
  @override
  List<Object> get props => [];
}
class ChatBlocFailureState extends ChatBlocState {
  final Failure failure;
  const ChatBlocFailureState(this.failure);
  @override
  List<Object> get props => [failure];
}

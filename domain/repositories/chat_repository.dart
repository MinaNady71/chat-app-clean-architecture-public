import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/responses/responses.dart';
import '../models/models.dart';

abstract class ChatRepository {
  Future<Either<Failure,void>> addChatMessage(MessagesResponse messagesResponse);
  Future<Either<Failure,void>> addInFriendsList(String toUid);
  Future<Either<Failure,void>> addUnreadCountMessages(String toUid);
  Future<Either<Failure,void>> resetUnreadCountMessages(String toUid);
  Future<Either<Failure,void>> amIInChatRoom(String toUid,bool inChatRoom);
  Future<Either<Failure,List<UserModel>>> getAllFriends();
  Either<Failure,Stream<List<MessagesModel>>> getMessages(String toUid);
  Either<Failure,Stream<List<CountUnreadMessagesModel>>> getUnreadCountMessages();
}
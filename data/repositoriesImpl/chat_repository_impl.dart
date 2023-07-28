import 'package:chat_app/data/network/failure.dart';
import 'package:chat_app/data/network/network_info.dart';

import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/chat_repository.dart';
import '../data_source/remote_data_source/firebase_firestore_remote_data_source.dart';
import '../network/error_handler.dart';

class ChatRepositoryImpl implements ChatRepository {
  final NetWorkInfo _netWorkInfo;
  final FirebaseFirestoreDatasource _firestoreFirestore;

  ChatRepositoryImpl(
    this._netWorkInfo,
    this._firestoreFirestore,
  );

  @override
  Future<Either<Failure, void>> addChatMessage(
      MessagesResponse messagesResponse) async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firestoreFirestore.addChatMessage(messagesResponse);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Either<Failure,Stream<List<MessagesModel>>> getMessages(String toUid) {
    try {
      return  Right(_firestoreFirestore.getMessages(toUid));
    } on FirebaseException catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure,void>> addInFriendsList(String toUid) async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firestoreFirestore.addInFriendsList(toUid);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(Failure(error.code, error.message!));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure,List<UserModel>>> getAllFriends() async{
    if (await _netWorkInfo.isConnected) {
      try {
        var response = await _firestoreFirestore.getAllFriends();
        return Right(response.toList());
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addUnreadCountMessages(String toUid)async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firestoreFirestore.addUnreadCountMessages(toUid);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(Failure(error.code, error.message!));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> amIInChatRoom(String toUid, bool inChatRoom)async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firestoreFirestore.amIInChatRoom(toUid,inChatRoom);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(Failure(error.code, error.message!));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetUnreadCountMessages(String toUid)async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firestoreFirestore.resetUnreadCountMessages(toUid);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(Failure(error.code, error.message!));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Either<Failure, Stream<List<CountUnreadMessagesModel>>> getUnreadCountMessages() {
    try {
      return  Right(_firestoreFirestore.getUnreadCountMessages());
    } on FirebaseException catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

}

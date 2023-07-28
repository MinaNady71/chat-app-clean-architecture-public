import 'dart:io';

import 'package:chat_app/data/data_source/remote_data_source/firebase_firestore_remote_data_source.dart';
import 'package:chat_app/data/data_source/remote_data_source/firebase_storage_remote_data_source.dart';
import 'package:chat_app/data/network/failure.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_source/remote_data_source/firebase_auth_remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/network_info.dart';

class UserRepositoriesImpl implements UserRepository {
  final FirebaseFirestoreDatasource _firestoreFirestore;
  final FirebaseStorageDatasource _storageDatasource;
  final NetWorkInfo _netWorkInfo;

  UserRepositoriesImpl(
    this._netWorkInfo,
    this._firestoreFirestore,
    this._storageDatasource,
  );

  @override
  Future<Either<Failure, void>> addUser(UserResponse userResponse) async {
    final uid = FirebaseAuthDatasourceImpl.auth.currentUser?.uid;
    if (await _netWorkInfo.isConnected) {
      try {
        if (uid != null) {
          var token = await FirebaseMessaging.instance.getToken();
          var response = UserResponse(
              username: userResponse.username,
              email: userResponse.email,
              phone: userResponse.phone,
              uid: uid,
              image: userResponse.image,
              bio: userResponse.bio,
              token: token,
              creationTimestamp:
              DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
              status:true,
              verified:false
          );

          await _firestoreFirestore.addUser(response);
        }

        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    if (await _netWorkInfo.isConnected) {
      try {
        var response = await _firestoreFirestore.getAllUsers();
        return Right(response.toList());
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateToken(String token)async {
    if (await _netWorkInfo.isConnected) {
    try {
       await _firestoreFirestore.updateToken(token);
    return const Right(null);
    } on FirebaseException catch (error) {
    return Left(ErrorHandler.handle(error).failure);
    }
    } else {
    return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
  @override
  Future<Either<Failure, void>> updateCurrentUser(UserResponse userResponse)async {
    if (await _netWorkInfo.isConnected) {
    try {
       await _firestoreFirestore.updateCurrentUser(userResponse);
    return const Right(null);
    } on FirebaseException catch (error) {
    return Left(ErrorHandler.handle(error).failure);
    }
    } else {
    return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure,UserModel>> getCurrentUser() async{
    if (await _netWorkInfo.isConnected) {
      try {
        var response = await _firestoreFirestore.getCurrentUser();
        return Right(response);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure,String>> uploadImage(File imageFile) async{
    if (await _netWorkInfo.isConnected) {
      try {
      String url = await _storageDatasource.uploadImage(imageFile);
        return Right(url);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(bool status) async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firestoreFirestore.updateStatus(status);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}

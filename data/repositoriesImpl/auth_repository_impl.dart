import 'package:chat_app/data/data_source/remote_data_source/firebase_auth_remote_data_source.dart';
import 'package:chat_app/data/network/error_handler.dart';
import 'package:chat_app/data/network/failure.dart';
import 'package:chat_app/data/network/network_info.dart';
import 'package:chat_app/data/network/requests.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/use_cases/user/add_user_use_case.dart';
import 'package:chat_app/domain/use_cases/user/update_token_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../app/constants.dart';
import '../responses/responses.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _firebaseDatasource;
  final NetWorkInfo _netWorkInfo;
  final AddUserUseCase _addUserUseCase;
  final UpdateTokenUseCase _tokenUseCase;

  AuthRepositoryImpl(this._netWorkInfo, this._firebaseDatasource,this._addUserUseCase,this._tokenUseCase);

  @override
  Future<Either<Failure, UserCredential>> login(
      LoginRequest loginRequest) async {
    if (await _netWorkInfo.isConnected) {
      try {
        final userCredential = await _firebaseDatasource.login(loginRequest);
        if (userCredential.user != null) {
          var token = await FirebaseMessaging.instance.getToken();
          await _tokenUseCase.execute(token!);
          return Right(userCredential);
        } else {
          return Left(
              Failure(ResponseCode.OTHERERROR, ResponseMessage.DEFAULT.tr()));
        }
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    if (await _netWorkInfo.isConnected) {
      try {
        final response = await _firebaseDatasource.signInWithGoogle();
        if (response.user != null) {
          var token = await FirebaseMessaging.instance.getToken();
          if(response.additionalUserInfo?.isNewUser == true){
            _addUserUseCase.execute(UserResponse(
                username: response.user!.displayName,
                email: response.user!.email,
                phone: response.user!.phoneNumber,
                uid: response.user!.uid,
                image: response.user!.photoURL ?? Constants.defaultImage,
                token: token,
                creationTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            ));
          }else{
          await  _tokenUseCase.execute(token!);
          }
          return Right(response);
        } else {
          return Left(
              Failure(ResponseCode.OTHERERROR, ResponseMessage.DEFAULT.tr()));
        }
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firebaseDatasource.forgotPassword(email);
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signUp(SignupRequest signupRequest) async {
    if (await _netWorkInfo.isConnected) {
      try {
        final userCredential = await _firebaseDatasource.signUp(signupRequest);
        if (userCredential.user != null) {
          return Right(userCredential);
        } else {
          return Left(
              Failure(ResponseCode.OTHERERROR, ResponseMessage.DEFAULT.tr()));
        }
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut()async {
    if (await _netWorkInfo.isConnected) {
      try {
        await _firebaseDatasource.signOut();
        return const Right(null);
      } on FirebaseException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}

import 'dart:io';

import 'package:chat_app/domain/models/models.dart';
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/responses/responses.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> addUser(UserResponse userResponse);
  Future<Either<Failure, void>> updateCurrentUser(UserResponse userResponse);
  Future<Either<Failure, void>> updateToken(String token);
  Future<Either<Failure, void>> updateStatus(bool status);
  Future<Either<Failure,List<UserModel>>> getAllUsers();
  Future<Either<Failure,UserModel>> getCurrentUser();
  Future<Either<Failure,String>> uploadImage(File imageFile);

}

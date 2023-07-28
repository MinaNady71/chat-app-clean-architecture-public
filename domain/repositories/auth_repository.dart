import 'package:chat_app/data/network/requests.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/network/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserCredential>> login(LoginRequest loginRequest);

  Future<Either<Failure, UserCredential>> signUp(SignupRequest signupRequest);

  Future<Either<Failure, UserCredential>> signInWithGoogle();

  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> signOut();
}

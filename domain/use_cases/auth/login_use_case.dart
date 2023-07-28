import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/network/failure.dart';
import '../../../data/network/requests.dart';
import '../base_use_case.dart';


// UseCase it is like a bridge from domain layer to data layer
// So we will create UseCase.dart in domain layer and it will take data from presentation then send it to data layer and vice versa

class LoginUseCase implements BaseUseCase<LoginUseCaseInput,UserCredential>{
  final AuthRepository _repositories;

  LoginUseCase(this._repositories);
  @override
  Future<Either<Failure, UserCredential>> execute(LoginUseCaseInput input)async {
    return await _repositories.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;
  LoginUseCaseInput(this.email,this.password);
}
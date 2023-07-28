import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/network/failure.dart';
import '../../../data/network/requests.dart';
import '../base_use_case.dart';

// UseCase it is like a bridge from domain layer to data layer
// So we will create UseCase.dart in domain layer and it will take data from presentation then send it to data layer and vice versa

class RegisterAuthUseCase implements BaseUseCase<RegisterUseCaseInput,UserCredential>{
  final AuthRepository _repositories;

  RegisterAuthUseCase(this._repositories);
  @override
  Future<Either<Failure, UserCredential>> execute(RegisterUseCaseInput input)async {
    return await _repositories.signUp(SignupRequest(input.email, input.password));
  }
}

class RegisterUseCaseInput {
  String email;
  String password;
  RegisterUseCaseInput(this.email,this.password);
}
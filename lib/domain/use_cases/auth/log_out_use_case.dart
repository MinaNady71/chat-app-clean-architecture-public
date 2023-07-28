import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';

// UseCase it is like a bridge from domain layer to data layer
// So we will create UseCase.dart in domain layer and it will take data from presentation then send it to data layer and vice versa

class SignOutUseCase{
  final AuthRepository _repositories;

  SignOutUseCase(this._repositories);

  Future<Either<Failure,void>> execute()async {
    return await _repositories.signOut();
  }
}

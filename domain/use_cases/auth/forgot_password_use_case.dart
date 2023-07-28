import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../base_use_case.dart';

// UseCase it is like a bridge from domain layer to data layer
// So we will create UseCase.dart in domain layer and it will take data from presentation then send it to data layer and vice versa

class ForgotPasswordUseCase implements BaseUseCase<String,void>{
  final AuthRepository _repositories;

  ForgotPasswordUseCase(this._repositories);
  @override
  Future<Either<Failure,void>> execute(String email)async {
    return await _repositories.forgotPassword(email);
  }
}

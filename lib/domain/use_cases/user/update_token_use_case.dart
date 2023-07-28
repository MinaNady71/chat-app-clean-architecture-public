import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../base_use_case.dart';

class UpdateTokenUseCase implements BaseUseCase<String,void>{
  final UserRepository _userRepository;

  UpdateTokenUseCase(this._userRepository);
  @override
  Future<Either<Failure,void>> execute(String token)async {
    return await _userRepository.updateToken(token);
  }
}
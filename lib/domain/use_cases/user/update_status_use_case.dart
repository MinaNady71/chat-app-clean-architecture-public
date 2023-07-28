import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../base_use_case.dart';

class UpdateStatusUseCase implements BaseUseCase<bool,void>{
  final UserRepository _userRepository;

  UpdateStatusUseCase(this._userRepository);
  @override
  Future<Either<Failure,void>> execute(bool status)async {
    return await _userRepository.updateStatus(status);
  }
}
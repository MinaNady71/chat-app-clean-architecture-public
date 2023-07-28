import 'package:chat_app/domain/models/models.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/user_repository.dart';
import '../base_use_case.dart';

class GetCurrentUserUseCase implements BaseUseCase<void,UserModel>{
  final UserRepository _userRepository;

  GetCurrentUserUseCase(this._userRepository);
  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure,UserModel>> execute(Void)async {
    return await _userRepository.getCurrentUser();
  }
}
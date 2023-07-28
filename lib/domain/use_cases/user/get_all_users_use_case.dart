import 'package:chat_app/domain/models/models.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/user_repository.dart';
import '../base_use_case.dart';

class GetAllUsersUseCase implements BaseUseCase<void,List<UserModel>>{
  final UserRepository _userRepository;

  GetAllUsersUseCase(this._userRepository);
  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure,List<UserModel>>> execute(Void)async {
    return await _userRepository.getAllUsers();
  }
}
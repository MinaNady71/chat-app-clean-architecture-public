import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../base_use_case.dart';

class AddUserUseCase implements BaseUseCase<UserResponse,void>{
  final UserRepository _userRepository;

  AddUserUseCase(this._userRepository);
  @override
  Future<Either<Failure,void>> execute(UserResponse userResponse)async {
    return await _userRepository.addUser(userResponse);
  }
}
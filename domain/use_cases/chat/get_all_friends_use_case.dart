import 'package:chat_app/domain/models/models.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../base_use_case.dart';

class GetAllFriendsUseCase implements BaseUseCase<void,List<UserModel>>{
  final ChatRepository _chatRepository;

  GetAllFriendsUseCase(this._chatRepository);
  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure,List<UserModel>>> execute(Void)async {
    return await _chatRepository.getAllFriends();
  }
}
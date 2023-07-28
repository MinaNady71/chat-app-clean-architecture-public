import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/chat_repository.dart';
import '../base_use_case.dart';

class AmIInChatRoomUseCase implements BaseUseCaseTwoParams<String,bool,void> {
  final ChatRepository _chatRepository;

  AmIInChatRoomUseCase(this._chatRepository);

  @override
  Future<Either<Failure, void>> execute(String toUid, bool inChatRoom) async {
    return await _chatRepository.amIInChatRoom(toUid,inChatRoom);
  }
}

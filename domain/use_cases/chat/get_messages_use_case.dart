import 'package:chat_app/domain/models/models.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/chat_repository.dart';

class GetMessageUseCase {
  final ChatRepository _chatRepository;

  GetMessageUseCase(this._chatRepository);

  Either<Failure,Stream<List<MessagesModel>>> execute(toUid) {
    return  _chatRepository.getMessages(toUid);
  }
}

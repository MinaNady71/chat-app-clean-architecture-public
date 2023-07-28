import 'package:chat_app/domain/models/models.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/chat_repository.dart';

class GetUnreadMessagesUseCase {
  final ChatRepository _chatRepository;

  GetUnreadMessagesUseCase(this._chatRepository);

  Either<Failure,Stream<List<CountUnreadMessagesModel>>> execute() {
    return  _chatRepository.getUnreadCountMessages();
  }
}

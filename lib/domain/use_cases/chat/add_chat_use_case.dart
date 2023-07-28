import 'package:chat_app/data/responses/responses.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/chat_repository.dart';
import '../base_use_case.dart';

class AddMessageUseCase implements BaseUseCase<MessagesResponse, void> {
  final ChatRepository _chatRepository;

  AddMessageUseCase(this._chatRepository);

  @override
  Future<Either<Failure, void>> execute(
      MessagesResponse messagesResponse) async {
    return await _chatRepository.addChatMessage(messagesResponse);
  }
}

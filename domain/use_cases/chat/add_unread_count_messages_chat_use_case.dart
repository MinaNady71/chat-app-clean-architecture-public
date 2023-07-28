import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../repositories/chat_repository.dart';
import '../base_use_case.dart';

class AddUnreadCountMessagesUseCase implements BaseUseCase<String, void> {
  final ChatRepository _chatRepository;

  AddUnreadCountMessagesUseCase(this._chatRepository);

  @override
  Future<Either<Failure, void>> execute(String toUid) async {
    return await _chatRepository.addUnreadCountMessages(toUid);
  }
}

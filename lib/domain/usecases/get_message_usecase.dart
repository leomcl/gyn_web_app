import '../repositories/message_repository.dart';


class GetMessageUseCase {
  final MessageRepository _repository;

  GetMessageUseCase(this._repository);

  String execute() {
    return _repository.getMessage();
  }
} 
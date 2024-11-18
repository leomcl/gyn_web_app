import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  @override
  String getMessage() {
    return 'Hello World!';
  }
} 
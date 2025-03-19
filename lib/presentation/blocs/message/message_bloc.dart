import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_web_app/domain/usecases/get_message_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessageUseCase _getMessageUseCase;

  MessageBloc(this._getMessageUseCase) : super(MessageInitial()) {
    on<LoadMessage>((event, emit) {
      final message = _getMessageUseCase.execute();
      emit(MessageLoaded(message));
    });
  }
} 
import 'package:get_it/get_it.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/usecases/get_message_usecase.dart';
import '../../presentation/blocs/message/message_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => MessageBloc(sl()));
  sl.registerFactory(() => AuthBloc());

  // Use cases
  sl.registerLazySingleton(() => GetMessageUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl());
} 
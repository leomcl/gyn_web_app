import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/usecases/get_message_usecase.dart';


//repositories
import 'package:snow_stats_app/domain/repositories/auth_repository.dart';
import 'package:snow_stats_app/data/repositories/auth_repository_impl.dart';

// Data sources
import 'package:snow_stats_app/data/datasources/firebase_datasource.dart';

// Use cases - Auth
import 'package:snow_stats_app/domain/usecases/auth/sign_in.dart';
import 'package:snow_stats_app/domain/usecases/auth/sign_up.dart';
import 'package:snow_stats_app/domain/usecases/auth/sign_out.dart';
import 'package:snow_stats_app/domain/usecases/auth/get_user_role.dart';
import 'package:snow_stats_app/domain/usecases/auth/get_current_user.dart';
import 'package:snow_stats_app/domain/usecases/auth/get_auth_state_changes.dart';

// Cubits
import 'package:snow_stats_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/navigation/navigation_cubit.dart';





final sl = GetIt.instance;

Future<void> init() async {
//! Features

  // Cubits
  sl.registerFactory(() => AuthCubit(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        getUserRoleUseCase: sl(),
        getCurrentUserUseCase: sl(),
        getAuthStateChangesUseCase: sl(),
      ));
  
    // Use cases - Auth
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetUserRole(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => GetAuthStateChanges(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));


// Data sources
  sl.registerLazySingleton(() => FirebaseDataSource(
        auth: sl(),
        firestore: sl(),
      ));

  //! External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);


  // rest from before


  // Use cases
  sl.registerLazySingleton(() => GetMessageUseCase(sl()));


  // Register cubits
  sl.registerFactory(() => NavigationCubit());
} 
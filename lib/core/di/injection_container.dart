import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Data sources
import 'package:snow_stats_app/data/datasources/firebase_datasource.dart';

// repositories - AUth
import 'package:snow_stats_app/domain/repositories/auth_repository.dart';
import 'package:snow_stats_app/data/repositories/auth_repository_impl.dart';

// repositories - Users
import 'package:snow_stats_app/domain/repositories/users_repository.dart';
import 'package:snow_stats_app/data/repositories/users_repository_impl.dart';

// repositories - Workouts
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';
import 'package:snow_stats_app/data/repositories/workout_repository_impl.dart';

// Use cases - Auth
import 'package:snow_stats_app/domain/usecases/auth/sign_in.dart';
import 'package:snow_stats_app/domain/usecases/auth/sign_up.dart';
import 'package:snow_stats_app/domain/usecases/auth/sign_out.dart';
import 'package:snow_stats_app/domain/usecases/auth/get_user_role.dart';
import 'package:snow_stats_app/domain/usecases/auth/get_current_user.dart';
import 'package:snow_stats_app/domain/usecases/auth/get_auth_state_changes.dart';

// Use cases - Users
import 'package:snow_stats_app/domain/usecases/users/get_all_users.dart';
import 'package:snow_stats_app/domain/usecases/users/get_user_by_uid.dart';

// Use cases - Workouts
import 'package:snow_stats_app/domain/usecases/workouts/get_all_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_daily_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_weekly_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_monthly_workouts.dart';

// Cubits
import 'package:snow_stats_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/navigation/navigation_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/workout_stats/workout_stats_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External - register Firebase instances first
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton(() => FirebaseDataSource(
        auth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(
        auth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ));
  sl.registerLazySingleton<WorkoutRepository>(() => WorkoutRepositoryImpl(
        firestore: sl<FirebaseFirestore>(),
      ));

  // Use cases - Auth
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetUserRole(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => GetAuthStateChanges(sl()));

  // Use cases - Users
  sl.registerLazySingleton(() => GetAllUsers(sl()));
  sl.registerLazySingleton(() => GetUserByUid(sl()));

  // Use cases - Workouts
  sl.registerLazySingleton(() => GetAllWorkouts(sl()));
  sl.registerLazySingleton(() => GetDailyWorkouts(sl()));
  sl.registerLazySingleton(() => GetWeeklyWorkouts(sl()));
  sl.registerLazySingleton(() => GetMonthlyWorkouts(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        getUserRoleUseCase: sl(),
        getCurrentUserUseCase: sl(),
        getAuthStateChangesUseCase: sl(),
      ));
  sl.registerFactory(() => NavigationCubit());
  sl.registerFactory(() => UsersCubit(getAllUsers: sl()));
  sl.registerFactory(() => WorkoutStatsCubit(
        getAllWorkouts: sl(),
        getDailyWorkouts: sl(),
        getWeeklyWorkouts: sl(),
        getMonthlyWorkouts: sl(),
      ));
}

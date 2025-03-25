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

// repositories - Occupancy
import 'package:snow_stats_app/domain/repositories/occupancy_repository.dart';
import 'package:snow_stats_app/data/repositories/occupancy_repository_impl.dart';

// repositories - Gym Classes
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';
import 'package:snow_stats_app/data/repositories/gym_class_repository_impl.dart';

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
import 'package:snow_stats_app/domain/usecases/users/get_user_details.dart';

// Use cases - Workouts
import 'package:snow_stats_app/domain/usecases/workouts/get_all_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_daily_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_weekly_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_monthly_workouts.dart';
import 'package:snow_stats_app/domain/usecases/workouts/get_user_workouts.dart';

// Use cases - Occupancy
import 'package:snow_stats_app/domain/usecases/occupancy/get_current_occupancy.dart';
import 'package:snow_stats_app/domain/usecases/occupancy/get_peak_occupancy_hours.dart';
import 'package:snow_stats_app/domain/usecases/occupancy/get_average_occupancy_by_hour.dart';
import 'package:snow_stats_app/domain/usecases/occupancy/get_occupancy_trend_by_day.dart';
import 'package:snow_stats_app/domain/usecases/occupancy/compare_time_periods_occupancy.dart';

// Use cases - Gym Classes
import 'package:snow_stats_app/domain/usecases/gym_classes/get_all_classes.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/get_class_by_id.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/get_classes_by_date.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/get_classes_by_tag.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/get_classes_by_date_range.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/create_class.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/update_class.dart';
import 'package:snow_stats_app/domain/usecases/gym_classes/delete_class.dart';

// Use cases - User Trends
import 'package:snow_stats_app/domain/usecases/user_trends/get_user_prefered_day.dart';
import 'package:snow_stats_app/domain/usecases/user_trends/get_user_prefered_workout.dart';

// Cubits
import 'package:snow_stats_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/navigation/navigation_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/workout_stats/workout_stats_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/occupancy/occupancy_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/gym_classes/gym_classes_cubit.dart';

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
  sl.registerLazySingleton<OccupancyRepository>(() => OccupancyRepositoryImpl(
        firestore: sl<FirebaseFirestore>(),
      ));
  sl.registerLazySingleton<GymClassRepository>(() => GymClassRepositoryImpl(
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
  sl.registerLazySingleton(() => GetUserDetails(sl()));

  // Use cases - Workouts
  sl.registerLazySingleton(() => GetAllWorkouts(sl()));
  sl.registerLazySingleton(() => GetDailyWorkouts(sl()));
  sl.registerLazySingleton(() => GetWeeklyWorkouts(sl()));
  sl.registerLazySingleton(() => GetMonthlyWorkouts(sl()));
  sl.registerLazySingleton(() => GetUserWorkouts(sl()));

  // Use cases - User Trends
  sl.registerLazySingleton(() => GetUserPreferedDays(sl()));
  sl.registerLazySingleton(() => GetUserPreferedWorkout(sl()));

  // Use cases - Occupancy
  sl.registerLazySingleton(() => GetCurrentOccupancy(sl()));
  sl.registerLazySingleton(() => GetPeakOccupancyHours(sl()));
  sl.registerLazySingleton(() => GetAverageOccupancyByHour(sl()));
  sl.registerLazySingleton(() => GetOccupancyTrendByDay(sl()));
  sl.registerLazySingleton(() => CompareTimePeriodsOccupancy(sl()));

  // Use cases - Gym Classes
  sl.registerLazySingleton(() => GetAllClasses(sl()));
  sl.registerLazySingleton(() => GetClassById(sl()));
  sl.registerLazySingleton(() => GetClassesByDate(sl()));
  sl.registerLazySingleton(() => GetClassesByTag(sl()));
  sl.registerLazySingleton(() => GetClassesByDateRange(sl()));
  sl.registerLazySingleton(() => CreateClass(sl()));
  sl.registerLazySingleton(() => UpdateClass(sl()));
  sl.registerLazySingleton(() => DeleteClass(sl()));

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
  sl.registerFactory(() => UserDetailsCubit(
        getUserDetails: sl(),
        getUserPreferedDays: sl(),
        getUserPreferedWorkout: sl(),
      ));
  sl.registerFactory(() => WorkoutStatsCubit(
        getAllWorkouts: sl(),
        getDailyWorkouts: sl(),
        getWeeklyWorkouts: sl(),
        getMonthlyWorkouts: sl(),
      ));
  sl.registerFactory(() => OccupancyCubit(
        getCurrentOccupancy: sl(),
        getPeakOccupancyHours: sl(),
        getAverageOccupancyByHour: sl(),
        getOccupancyTrendByDay: sl(),
        compareTimePeriodsOccupancy: sl(),
      ));
  sl.registerFactory(() => GymClassesCubit(
        getAllClasses: sl(),
        getClassById: sl(),
        getClassesByDate: sl(),
        getClassesByTag: sl(),
        createClass: sl(),
        updateClass: sl(),
        deleteClass: sl(),
      ));
}

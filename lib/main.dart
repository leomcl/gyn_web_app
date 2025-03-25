import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/layout/main_layout.dart';
import 'presentation/cubit/auth/auth_cubit.dart';
import 'presentation/cubit/navigation/navigation_cubit.dart';
import 'presentation/cubit/theme/theme_cubit.dart';
import 'presentation/cubit/theme/theme_state.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/workout_stats/workout_stats_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/occupancy/occupancy_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/gym_classes/gym_classes_cubit.dart';

import 'package:snow_stats_app/presentation/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set Firebase Auth persistence BEFORE initializing the app
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<UsersCubit>(
          create: (context) => di.sl<UsersCubit>(),
        ),
        BlocProvider<UserDetailsCubit>(
          create: (context) => di.sl<UserDetailsCubit>(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<WorkoutStatsCubit>(
          create: (context) => di.sl<WorkoutStatsCubit>(),
        ),
        BlocProvider<OccupancyCubit>(
          create: (context) {
            final cubit = di.sl<OccupancyCubit>();
            // Load occupancy data when app starts
            cubit.loadAllData();
            return cubit;
          },
        ),
        BlocProvider<GymClassesCubit>(
          create: (context) => di.sl<GymClassesCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeState is ThemeDark ? ThemeMode.dark : ThemeMode.light,
            home: const MainLayout(
              child: HomePage(),
            ),
          );
        },
      ),
    );
  }
}

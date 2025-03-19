import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/layout/main_layout.dart';
import 'presentation/cubit/auth/auth_cubit.dart';
import 'presentation/cubit/navigation/navigation_cubit.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'package:snow_stats_app/presentation/cubit/users/users_cubit.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MainLayout(child: SizedBox()),
      ),
    );
  }
}

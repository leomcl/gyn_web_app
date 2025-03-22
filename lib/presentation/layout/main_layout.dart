import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snow_stats_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/auth/auth_state.dart';
import 'package:snow_stats_app/presentation/cubit/navigation/navigation_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/theme/theme_cubit.dart';
import 'package:snow_stats_app/presentation/cubit/theme/theme_state.dart';
import 'package:snow_stats_app/presentation/pages/dashboard_page.dart';
import 'package:snow_stats_app/presentation/pages/login_page.dart';
import 'package:snow_stats_app/presentation/pages/users_page.dart';
import 'package:snow_stats_app/presentation/pages/usage_page.dart';
import 'package:snow_stats_app/presentation/pages/workouts_page.dart';
import 'package:snow_stats_app/presentation/pages/gym_classes_page.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Show a loading indicator while checking auth status
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If authenticated, show the main content
        if (state is Authenticated) {
          return Scaffold(
            body: Row(
              children: [
                NavigationSidebar(),
                Expanded(
                  child: BlocBuilder<NavigationCubit, AppPage>(
                    builder: (context, state) {
                      switch (state) {
                        case AppPage.dashboard:
                          return const DashboardPage();
                        case AppPage.users:
                          return const UsersPage();
                        case AppPage.usage:
                          return const UsagePage();
                        case AppPage.workouts:
                          return const WorkoutsPage();
                        case AppPage.classes:
                          return const GymClassesPage();
                        default:
                          return const DashboardPage();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }

        // If not authenticated, show the login page
        return const LoginPage();
      },
    );
  }
}

class NavigationSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Gym Stats',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _NavItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              context.read<NavigationCubit>().navigateTo(AppPage.dashboard);
            },
          ),
          _NavItem(
            icon: Icons.person,
            title: 'Users',
            onTap: () {
              context.read<NavigationCubit>().navigateTo(AppPage.users);
            },
          ),
          _NavItem(
            icon: Icons.bar_chart,
            title: 'Usage',
            onTap: () {
              context.read<NavigationCubit>().navigateTo(AppPage.usage);
            },
          ),
          _NavItem(
            icon: Icons.directions_run,
            title: 'Workouts',
            onTap: () {
              context.read<NavigationCubit>().navigateTo(AppPage.workouts);
            },
          ),
          _NavItem(
            icon: Icons.fitness_center,
            title: 'Classes',
            onTap: () {
              context.read<NavigationCubit>().navigateTo(AppPage.classes);
            },
          ),
          const Spacer(),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return _NavItem(
                icon: state is ThemeDark ? Icons.light_mode : Icons.dark_mode,
                title: state is ThemeDark ? 'Light Mode' : 'Dark Mode',
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          _NavItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}

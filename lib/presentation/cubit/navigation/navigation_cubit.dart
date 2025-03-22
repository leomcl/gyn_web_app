import 'package:flutter_bloc/flutter_bloc.dart';

enum AppPage { dashboard, users, usage, workouts, classes }

class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.dashboard);

  void navigateTo(AppPage page) {
    emit(page);
  }
}

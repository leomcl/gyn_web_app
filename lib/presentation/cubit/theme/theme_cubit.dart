import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snow_stats_app/presentation/cubit/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const THEME_KEY = 'app_theme';

  ThemeCubit() : super(ThemeInitial()) {
    // Initialize theme from stored preference
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(THEME_KEY) ?? false;

    if (isDark) {
      emit(ThemeDark());
    } else {
      emit(ThemeLight());
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (state is ThemeLight) {
      await prefs.setBool(THEME_KEY, true);
      emit(ThemeDark());
    } else {
      await prefs.setBool(THEME_KEY, false);
      emit(ThemeLight());
    }
  }
}

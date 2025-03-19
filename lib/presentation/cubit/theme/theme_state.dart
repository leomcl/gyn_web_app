import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLight extends ThemeState {
  final ThemeMode themeMode = ThemeMode.light;

  @override
  List<Object> get props => [themeMode];
}

class ThemeDark extends ThemeState {
  final ThemeMode themeMode = ThemeMode.dark;

  @override
  List<Object> get props => [themeMode];
}

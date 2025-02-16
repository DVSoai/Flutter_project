import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gemini_gpt_app/bloc/theme/theme_event.dart';
import 'package:gemini_gpt_app/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(
        themeMode: state.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light,
      ));
    });
  }
}

import 'package:flutter/material.dart';

part 'light_colors.dart';

const _inputBorderRadius = 8.0;
const _inputContentPadding = 10.0;

final lightTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _LightColors._EFEFEF,
    contentPadding: const EdgeInsets.all(
      _inputContentPadding,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        _inputBorderRadius,
      ),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        _inputBorderRadius,
      ),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        _inputBorderRadius,
      ),
      borderSide: BorderSide.none,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

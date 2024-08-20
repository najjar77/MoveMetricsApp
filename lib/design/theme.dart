import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true, 
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF1A535C),
    secondary: Color(0xFF3E7B89),
  ),
  primaryColor: Color(0xFF1A535C),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, 
      backgroundColor: Color(0xFF1A535C), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE3F2FD),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Color(0xFF1A535C),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Color(0xFF1A535C),
      ),
    ),
  ),
);

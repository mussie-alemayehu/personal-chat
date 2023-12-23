import 'package:flutter/material.dart';

import './text.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: lightAppBarText,
  ),
  textTheme: lightThemeText,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 22, 26, 42),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 226, 221, 227),
    onSecondary: Colors.black,
    tertiary: Color.fromARGB(255, 163, 160, 164),
    onTertiary: Colors.black,
    background: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    enabledBorder: const OutlineInputBorder(
      // borderRadius: BorderRadius.only(
      //   topRight: Radius.circular(20),
      //   topLeft: Radius.circular(5),
      //   bottomLeft: Radius.circular(5),
      //   bottomRight: Radius.circular(5),
      // ),
      borderSide: BorderSide(
        color: Colors.white54,
        width: 1,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red.shade700,
        width: 2,
      ),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    hintStyle: const TextStyle(color: Colors.white30),
    prefixIconColor: Colors.white30,
    suffixIconColor: Colors.white30,
  ),
  useMaterial3: true,
);

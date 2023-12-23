import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle lightAppBarText = const TextStyle(
  color: Colors.white,
  fontSize: 20,
);

TextTheme lightThemeText = TextTheme(
  bodyMedium: GoogleFonts.roboto(
    fontSize: 20,
    color: Colors.black,
  ),
  bodySmall: GoogleFonts.roboto(
    fontSize: 15,
    color: Colors.black,
  ),
  headlineLarge: GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
  headlineMedium: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  ),
  headlineSmall: GoogleFonts.roboto(
    fontSize: 18,
    color: Colors.grey[600],
  ),
);

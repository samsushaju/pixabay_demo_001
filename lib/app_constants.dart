import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Routes for the app
class RouteName {
  static const String gallery = "/";
  static const String detailsPage = "/details";
}

// Colors for the app
class AppColors {
  static const primaryColor = Color(0x0fffffff);
  static const secondayColor = Color(0x0fffffff);
  static const whiterose = Color(0xffFEECEB);
  static const whiteblue = Color(0xffF1FAFF);
}

class AppText {
  textHeader(
    text, {
    fontSize,
    fontWeight,
    color,
  }) {
    return Text(
      text,
      style: GoogleFonts.chivo(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black),
    );
  }
}

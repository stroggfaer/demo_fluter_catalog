import 'package:flutter/material.dart';

abstract class ThemeText {

  // Размер шрифт;
  static textFontSize({Color? color, double fontSize = 14.0, String fontStyle = 'normal'}) => TextStyle(
    fontSize: fontSize,
    color: color ?? Styles.black,
    fontWeight: fontStyle == 'bold' ? FontWeight.bold : FontWeight.normal,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.5,
    height: 1.3,
    decoration: TextDecoration.none,
  );
}

abstract class Styles {
  static const Color scaffoldBackground = Color(0xFF263CDE);

  static const Color pageBackground = Color(0xFF5567EA);

  static const Color contentBackground = Color(0xFFF5F5F8);

  static const Color blueLite = Color(0xFF5567EA);

  static const Color purple = Color(0xFF99A1F3);
  // static const Color purple = Color.fromRGBO(131,139,235,0.8);
  static const Color blue = Color(0xFF263CDE);

  static const Color grey = Color(0xFFC4C4D8);

  static const Color greyDark = Color(0xFFABABAD);

  static const Color red = Color(0xFFEE866A);

  static const Color redNormal = Color(0xFFFA5C45);

  static const Color orange = Color(0xFFFEAF5A);

  static const Color black = Color(0xFF2F3034);

  static const Color headerGrey = Color(0xFFC4C4C4);

  static const Color greyNormal = Color(0xFFC4C4C4);

  static const Color white = Color(0xFFFfffff);

  static const Color greyWhite = Color(0xFFF5F5F8);

  static const Color greyLite = Color(0xFFF5F5F8);

  static const Color green = Color(0xFF42CE7A);
}

// Global
const defaultPadding = 20.0;
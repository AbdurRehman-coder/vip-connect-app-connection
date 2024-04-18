import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color green = Colors.green;
  static const Color red = Color(0xFFFF3D00);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  static const Color shimmer1 = Color(0xFF414042);
  static Color shimmer2 = Colors.grey.withOpacity(0.1);

  static const Color primary = Color(0xFFF2F3F4);
  static const Color primaryLight = Color(0xFFF4F4F4);
  static const Color secondary = Color(0xFF080808);
  static const Color border = Color(0xFF5A5A5A);
  static const Color white300 = Color(0xFFDADBDC);
  static const Color white500 = Color(0xFF979899);
  static const Color black400 = Color(0xFFA3A3A3);
  static const Color black500 = Color(0xFF1D1D1D);
  static const Color black600 = Color(0xFF0C0C0C);
  static const Color black700 = Color(0xFF484848);
  static const Color black800 = Color(0xFF2B2B2B);
  static const Color icons1 = Color(0xFF5E5F5F);
  static const Color randomColor1 = Color(0xFFDADADA);
  static const Color randomColor2 = Color(0xFF231F20);

  //Text Color
  static const Color primaryText = Color(0xFF001833);
  static const Color hintText = Color(0xFF484848);
  static const Color blackHalfText = Color(0xFF818181);
  static const Color disableText = Color(0xFF858494);

  static const Color disableButton = Colors.white24;
  static const Color button = Color(0xFF484848);
}

ColorScheme kColorScheme = const ColorScheme.light(
  primary: AppColors.primary,
  secondary: AppColors.green,
);

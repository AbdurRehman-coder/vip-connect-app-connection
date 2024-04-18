import 'package:flutter/material.dart';

import '../constants.dart';
import 'app_colors.dart';

class AppTextStyle {
  // static double fontSizeExtraSmall =
  //     Get.context != null && Get.context!.width >= 1300 ? 14 : 10;
  // static double fontSizeSmall =
  //     Get.context != null && Get.context!.width >= 1300 ? 16 : 12;
  // static double fontSizeDefault =
  //     Get.context != null && Get.context!.width >= 1300 ? 18 : 14;
  // static double fontSizeLarge =
  //     Get.context != null && Get.context!.width >= 1300 ? 24 : 18;
  // static double fontSizeExtraLarge =
  //     Get.context != null && Get.context!.width >= 1300 ? 30 : 20;
  // static double fontSizeOverLarge =
  //     Get.context != null && Get.context!.width >= 1300 ? 48 : 40;

  //Web
  static final TextStyle web1 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize48,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static final TextStyle web2 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize18,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
  static final TextStyle web3 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );
  static final TextStyle web4 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final TextStyle h3Web = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize24,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static final TextStyle bodyRegularWeb = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize16,
    fontWeight: FontWeight.w400,
    color: AppColors.button,
  );

  //Mobile
  static final TextStyle h3 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize24,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize16,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static final TextStyle bodyRegular = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize16,
    fontWeight: FontWeight.w400,
    color: AppColors.button,
  );

  static final TextStyle rubik12_600 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final TextStyle popping24_600 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final TextStyle popping18_400 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize18,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static final TextStyle popping16_400 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static final TextStyle popping14_600 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static final TextStyle popping12_400 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize12,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static final TextStyle popping12_300 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: kFontSize12,
    fontWeight: FontWeight.w300,
    color: AppColors.primary,
  );
}

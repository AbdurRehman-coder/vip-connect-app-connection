import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';

PreferredSizeWidget customAppBar(
    {required String title,
    bool? hideBackButton,
    bool? centerTitle,
    List<Widget>? action,PreferredSize? bottom}) {
  return AppBar(
    backgroundColor: AppColors.secondary,
    elevation: 0,
    centerTitle: centerTitle ?? true,
    automaticallyImplyLeading: (hideBackButton == true ? false : true),
    leading: (hideBackButton ?? false)
        ? null
        : IconButton(
            onPressed: () {
              Get.back();
            },
            splashRadius: 20,
            iconSize: 30,
            icon: const Icon(
              Icons.keyboard_backspace,
              color: AppColors.primary,
            ),
          ),
    title: Text(
      title,
      style: AppTextStyle.h3.copyWith(color: AppColors.white300),
    ),
    actions: action,
    bottom: bottom,
  );
}

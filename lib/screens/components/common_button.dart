import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_text_styles.dart';

import '../../helper/app_colors.dart';

class CommonButton extends StatelessWidget {
  final String title, iconData;
  final bool isFill, isIconVisible;
  final Color? iconColor, textColor, borderColor, bgColor;
  final void Function() onPressed;
  bool buttonShouldDisable = false;
  bool? isWeb;
  bool? isPoll = false;
  double? height, borderRadius;
  EdgeInsets? padding;
  TextStyle? style;

  CommonButton({
    Key? key,
    this.isWeb,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.padding,
    this.bgColor,
    this.borderRadius,
    this.style,
    this.isPoll,
    required this.title,
    required this.iconData,
    required this.isFill,
    required this.isIconVisible,
    required this.onPressed,
    required this.buttonShouldDisable,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /// for web
    return isWeb ?? false
        ? ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                  Size(double.infinity, height ?? 56)),
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                padding ??
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
              ),
              //Fixed Size set
              // fixedSize: MaterialStateProperty.all( Size(double.infinity,48)),
              backgroundColor: isFill
                  ? bgColor != null
                      ? MaterialStateProperty.all(bgColor)
                      : (buttonShouldDisable)
                          ? MaterialStateProperty.all(AppColors.disableButton)
                          : MaterialStateProperty.all(AppColors.button)
                  : MaterialStateProperty.all(AppColors.secondary),
              splashFactory:
                  buttonShouldDisable ? NoSplash.splashFactory : null,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(borderRadius ?? kBorderRadius20),
                  side: BorderSide(
                    color: isFill
                        ? buttonShouldDisable
                            ? AppColors.disableButton
                            : borderColor ?? AppColors.button
                        : borderColor ?? AppColors.primary,
                  ),
                ),
              ),
              //minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.h)),
            ),
            onPressed: buttonShouldDisable ? () {} : onPressed,
            child: Row(
              mainAxisAlignment: isIconVisible
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: style ??
                      AppTextStyle.web2.copyWith(
                        color: buttonShouldDisable
                            ? AppColors.disableText
                            : textColor ?? AppColors.primary,
                      ),
                ),
                isIconVisible
                    ? Image.asset(
                        iconData,
                        color: buttonShouldDisable
                            ? AppColors.disableText
                            : iconColor,
                        height: 24,
                        width: 24,
                      )
                    : const SizedBox(),
              ],
            ),
          )

        /// for Mobile
        : ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                  Size(double.infinity, height ?? 45.h)),
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                padding ??
                    EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
              ),
              //Fixed Size set
              // fixedSize: MaterialStateProperty.all( Size(double.infinity,48)),
              backgroundColor: isFill
                  ? bgColor != null
                      ? MaterialStateProperty.all(bgColor)
                      : (buttonShouldDisable)
                          ? MaterialStateProperty.all(AppColors.disableButton)
                          : MaterialStateProperty.all(AppColors.button)
                  : MaterialStateProperty.all(
                      Colors.black54,
                    ),
              splashFactory:
                  buttonShouldDisable ? NoSplash.splashFactory : null,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(borderRadius ?? kBorderRadius20),
                  side: BorderSide(
                    color: isFill
                        ? buttonShouldDisable
                            ? AppColors.disableButton
                            : borderColor ?? AppColors.button
                        : borderColor ?? AppColors.primary,
                  ),
                ),
              ),
              //minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.h)),
            ),
            onPressed: buttonShouldDisable ? () {} : onPressed,
            child: Row(
              mainAxisAlignment: isPoll == true
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: style ??
                        AppTextStyle.bodyMedium.copyWith(
                            color: buttonShouldDisable
                                ? AppColors.disableText
                                : textColor ?? AppColors.primary,
                            fontWeight: FontWeight.normal),
                  ),
                ),
                isIconVisible
                    ? Image.asset(
                        iconData,
                        color: buttonShouldDisable
                            ? AppColors.disableText
                            : iconColor,
                        height: 24.h,
                        width: 24.w,
                      )
                    : const SizedBox(),
              ],
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/screens/components/spacer.dart';

import '../../helper/app_colors.dart';

class CommonIconAndTextButton extends StatelessWidget {
  final String text, svgData;
  final bool isFill, iconSize16;
  final Color iconColor;
  final double? height, width;
  final void Function() onPressed;

  CommonIconAndTextButton({
    Key? key,
    required this.text,
    required this.svgData,
    required this.isFill,
    required this.iconColor,
    required this.iconSize16,
    this.height,
    this.width,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? 56.h,
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.white300,
          // color: isFill ? AppColors.white300 : AppColors.button,
          borderRadius: BorderRadius.circular(kBorderRadius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgData,
              color: iconColor,
              height: iconSize16 ? 16.h : 12.h,
              width: iconSize16 ? 16.w : 12.w,
            ),
            const HorizontalSpacer(width: 2.36),
            Text(
              text,
              style: AppTextStyle.bodyRegular.copyWith(
                fontSize: kFontSize10,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

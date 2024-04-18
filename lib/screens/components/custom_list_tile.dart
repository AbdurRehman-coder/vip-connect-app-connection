import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.svgPath,
    required this.onTap,
  }) : super(key: key);
  String title, subtitle, svgPath;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 76.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.black800,
          borderRadius: BorderRadius.circular(kBorderRadius16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 44.h,
              width: 44.w,
              child: CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: SvgPicture.asset(
                  svgPath,
                  color: AppColors.primary,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
            HorizontalSpacer(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyMedium,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.white500, fontSize: kFontSize14),
                  ),
                ],
              ),
            ),
            HorizontalSpacer(width: 2.w),
            SvgPicture.asset(
              AppAssets.backArrowSvg,
              height: 20.h,
              width: 20.w,
              color: AppColors.white300,
            ),
          ],
        ),
      ),
    );
  }
}

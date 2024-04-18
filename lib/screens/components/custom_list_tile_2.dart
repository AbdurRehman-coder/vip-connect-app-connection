import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class CustomListTile2 extends StatelessWidget {
  CustomListTile2({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);
  String title, subtitle, imagePath;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.black800,
        borderRadius: BorderRadius.circular(kBorderRadius16),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 62.h,
              width: 62.h,
              child: CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Image.asset(
                  imagePath,
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
                    style:
                        AppTextStyle.bodyMedium.copyWith(fontSize: kFontSize13),
                  ),
                  VerticalSpacer(height: 5.h),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.white500, fontSize: kFontSize11),
                  ),
                ],
              ),
            ),
            HorizontalSpacer(width: 2.w),
            PopupMenuButton(
              color: AppColors.border,
              icon: SvgPicture.asset(AppAssets.moreVerticalSvg),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      AppTexts.delete,
                      style: AppTextStyle.popping14_600,
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      AppTexts.markAsRead,
                      style: AppTextStyle.popping14_600,
                    ),
                  ),
                ];
              },
              onSelected: (value) {},
            ),
            // SvgPicture.asset(
            //   AppAssets.moreVerticalSvg,
            //   height: 20.h,
            //   width: 20.w,
            //   color: AppColors.white300,
            // ),
          ],
        ),
      ),
    );
  }
}

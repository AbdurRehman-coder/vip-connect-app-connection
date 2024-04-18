import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/spacer.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class WebUserRequests extends StatelessWidget {
  WebUserRequests({Key? key}) : super(key: key);
  RxInt currentIndex = 0.obs;
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black800,
      width: double.infinity,
      child: Column(
        children: [
          VerticalSpacer(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HorizontalSpacer(width: 30.w),
              Text(
                AppTexts.usersRequests,
                style: AppTextStyle.web4.copyWith(fontSize: kFontSize26),
              ),
              HorizontalSpacer(width: 30.w),
            ],
          ),
          VerticalSpacer(height: 25.h),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                height: 81.h,
                margin: EdgeInsets.only(left: 30.w, bottom: 10.h, right: 30.w),
                padding: EdgeInsets.symmetric(
                  vertical: 22.h,
                  horizontal: 22.w,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(kBorderRadius8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 38.h,
                      width: 38.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorderRadius8),
                          image: const DecorationImage(
                            image: AssetImage(AppAssets.dummyPostImg),
                            fit: BoxFit.cover,
                          )),
                    ),
                    HorizontalSpacer(width: 13.w),
                    const Text(
                      "Jordyn",
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<dynamic>(
                      initialValue: selectedMenu,
                      // alignment: Alignment.centerRight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      // surfaceTintColor: AppColors.black800,
                      color: AppColors.black800,
                      padding: EdgeInsets.zero,
                      iconSize: 24.h,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.primary,
                      ),
                      onSelected: (dynamic item) {
                        selectedMenu = item;
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<dynamic>>[
                        MenuItem(
                          "View User Details",
                          AppAssets.eyeSvg,
                          () {},
                        ),
                        MenuItem(
                          "Approve",
                          AppAssets.checkmarkCircleSvg,
                          () {},
                        ),
                        MenuItem(
                          "Deny",
                          AppAssets.trashSvg,
                          () {},
                        ),
                        MenuItem(
                          "Delete",
                          AppAssets.personSvg,
                          () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 46.h,
              margin: EdgeInsets.only(right: 30.w),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HorizontalSpacer(width: 10.w),
                  SvgPicture.asset(
                    AppAssets.leftIconSvg,
                    color: AppColors.white,
                    height: 18.h,
                    width: 18.h,
                  ),
                  HorizontalSpacer(width: 13.w),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return index == currentIndex.value
                          ? Container(
                              height: 46.h,
                              width: 46.h,
                              padding: EdgeInsets.symmetric(
                                vertical: 13.h,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius8),
                              ),
                              child: Text(
                                index.toString(),
                                style: AppTextStyle.web4.copyWith(
                                    color: AppColors.primary,
                                    fontSize: kFontSize12),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 13.h,
                              ),
                              child: Text(
                                index.toString(),
                                style: AppTextStyle.web4.copyWith(
                                    color: AppColors.blackHalfText,
                                    fontSize: kFontSize12),
                              ),
                            );
                    },
                  ),
                  HorizontalSpacer(width: 13.w),
                  SvgPicture.asset(
                    AppAssets.rightIconSvg,
                    color: AppColors.white,
                    height: 18.h,
                    width: 18.h,
                  ),
                  HorizontalSpacer(width: 10.w),
                ],
              ),
            ),
          ),
          VerticalSpacer(height: 38.h),
        ],
      ),
    );
  }
}

PopupMenuItem MenuItem(String title, String svgPath, VoidCallback onTap) {
  return PopupMenuItem<SampleItem>(
    onTap: onTap,
    value: SampleItem.itemOne,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgPath,
          color: AppColors.primary,
          height: 18.h,
          width: 18.h,
        ),
        HorizontalSpacer(width: 12.w),
        Text(
          title,
          style: AppTextStyle.rubik12_600.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}

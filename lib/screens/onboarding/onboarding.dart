import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/background_design.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();

  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: BackgroundDesign(
        child: Column(
          children: [
            VerticalSpacer(
              height: 110.h,
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: controller,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          AppAssets.onBoarding1Svg,
                          height: 380.h,
                          width: 254.w,
                        ),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          AppAssets.onBoarding2Svg,
                          height: 247.h,
                          width: 270.w,
                        ),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          AppAssets.onBoarding3Svg,
                          height: 264.h,
                          width: 318.w,
                        ),
                      ),
                    ],
                  ),
                  // Positioned(
                  //   top: 16.h,
                  //   right: 59.w,
                  //   child: Image.asset(
                  //     AppAssets.logoImg,
                  //     height: 43.h,
                  //     width: 76.w,
                  //   ),
                  // ),
                ],
              ),
            ),
            VerticalSpacer(
              height: 42.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  currentPage == 0
                      ? AppAssets.selectedCircleSvg
                      : AppAssets.unselectedCircleSvg,
                ),
                HorizontalSpacer(
                  width: 12.w,
                ),
                SvgPicture.asset(
                  currentPage == 1
                      ? AppAssets.selectedCircleSvg
                      : AppAssets.unselectedCircleSvg,
                ),
                HorizontalSpacer(
                  width: 12.w,
                ),
                SvgPicture.asset(
                  currentPage == 2
                      ? AppAssets.selectedCircleSvg
                      : AppAssets.unselectedCircleSvg,
                ),
              ],
            ),
            Container(
              height: 224.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(kBorderRadius20),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
                      child: Text(
                        currentPage == 0 ? AppTexts.onBoarding1 : currentPage == 1 ? AppTexts.onBoarding2 : AppTexts.onBoarding3,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.h3.copyWith(height: 1.3.h),
                      ),
                    ),
                  ),
                  VerticalSpacer(
                    height: 10.h,
                  ),
                  CommonButton(
                    title: 'Sign Up',
                    iconData: "iconData",
                    isFill: true,
                    isIconVisible: false,
                    iconColor: AppColors.white,
                    onPressed: () {
                      Get.toNamed(routeSignUp);
                    },
                    buttonShouldDisable: false,
                  ),
                  VerticalSpacer(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTexts.alreadyHaveAccount,
                        style: AppTextStyle.bodyRegular.copyWith(
                          color: AppColors.disableText,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(routeLogin);
                        },
                        child: Text("Login",
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpacer(
                    height: 16.h,
                  ),
                ],
              ),
            ),
            VerticalSpacer(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}

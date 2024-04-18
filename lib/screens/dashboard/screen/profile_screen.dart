import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/controller/dashboard_controller.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_list_tile.dart';
import 'package:vip_connect/screens/components/spacer.dart';
import 'package:vip_connect/services/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final dashboardController = Get.put(DashboardController());
  final List<String> accountTileTitle = [
    AppTexts.updateProfile,
    // AppTexts.changeEmailAddress,
    AppTexts.changePassword,
  ];

  final List<String> accountTileSubTitle = [
    AppTexts.updateProfileSubtitle,

    /// Changing email address option [text]
    // AppTexts.changeEmailAddressSubtitle,
    AppTexts.changePasswordSubtitle,
  ];

  final List<String> accountTileSvgPath = [
    AppAssets.personSvg,
    // AppAssets.emailFillSvg,
    AppAssets.lockSvg,
  ];

  final List<VoidCallback> accountTileOnTap = [
    () {
      // Get.toNamed(routeUpdateProfile);
      Get.toNamed(showUserProfile);
    },

    /// Changing email address option
    // () {
    //   Get.toNamed(routeChangeEmail);
    // },
    () {
      // Get.toNamed(routeChangePassword);
      Get.toNamed(routeForgetPassword);
    },
  ];
  final List<String> otherTileSvgPath = [
    AppAssets.shareSvg,
    AppAssets.questionMarkCircleSvg
  ];

  // final List<VoidCallback> otherTileOnTap = [
  //   () {
  //     Get.toNamed(routeInviteFriend);
  //   },
  //   () {
  //     Get.toNamed(routePrivacyPolicy);
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  AppTexts.profile,
                  style: AppTextStyle.h3.copyWith(color: AppColors.white300),
                ),
              ),
              VerticalSpacer(height: 12.h),
              Text(
                AppTexts.account.toUpperCase(),
                style: AppTextStyle.bodyMedium.copyWith(
                  fontSize: kFontSize14,
                  color: AppColors.white300.withOpacity(0.5),
                ),
              ),
              VerticalSpacer(height: 16.h),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return CustomListTile(
                      title: accountTileTitle[index],
                      subtitle: accountTileSubTitle[index],
                      svgPath: accountTileSvgPath[index],
                      onTap: accountTileOnTap[index],
                    );
                  }),
              SizedBox(height: 12.h),
              Text(
                AppTexts.other.toUpperCase(),
                style: AppTextStyle.bodyMedium.copyWith(
                  fontSize: kFontSize14,
                  color: AppColors.white300.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 16.h),
              CustomListTile(
                title: "Invite Your Friends",
                subtitle: 'Share link and invite friends',
                svgPath: AppAssets.shareSvg,
                onTap: () {
                  Get.toNamed(routeInviteFriend);
                },
              ),
              CustomListTile(
                title: 'Terms of Services',
                subtitle: 'Privacy policy',
                svgPath: AppAssets.questionMarkCircleSvg,
                onTap: () {
                  Get.toNamed(routePrivacyPolicy);
                },
              ),
              // ListView.builder(
              //     physics: const NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: 2,
              //     itemBuilder: (context, index) {
              //       return CustomListTile(
              //         title: 'Terms of Services',
              //         subtitle: 'Privacy policy',
              //         svgPath: otherTileSvgPath[index],
              //         onTap: otherTileOnTap[index],
              //       );
              //     }),
              VerticalSpacer(height: 18.h),
              CommonButton(
                title: 'Logout',
                iconData: '',
                isFill: true,
                isIconVisible: false,
                onPressed: () {
                  AuthServices.signOut().then((value) {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => LoginScreen()),
                    //     ModalRoute.withName('/')
                    // );
                    Get.offAndToNamed(routeLogin);

                    /// [issue] when logout it will redirect to the login screen,
                    /// when again user login it will come direct to the profile screen.
                    /// so because of that we first update the bottomNavigationBar index to initial,
                    /// and then logout the user, when user login again it will redirect to first index.
                    dashboardController.updateCurrentIndex(0);
                  });
                },
                buttonShouldDisable: false,
              ),
              SizedBox(height: 22.h),
              CommonButton(
                title: 'Delete Account',
                textColor: AppColors.red,
                borderColor: AppColors.red,
                iconData: '',
                isFill: false,
                isIconVisible: false,
                onPressed: () {
                  Get.toNamed(routeDeleteUserAccount);
                },
                iconColor: AppColors.transparent,
                buttonShouldDisable: false,
              ),
              SizedBox(height: 22.h),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: AppTexts.changeEmail),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            VerticalSpacer(height: 64.h),
            CustomTextField(
              mainTitle: AppTexts.emailAddress,
              hintText: "Your email address",
              filled: true,
              fillColor: AppColors.primary,
              prefixWidget: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: SvgPicture.asset(
                  AppAssets.emailFillSvg,
                  height: 24.h,
                  width: 24.h,
                ),
              ),
              onSaved: (String? newValue) {},
              validator: (String? value) {},
            ),
            VerticalSpacer(height: 36.h),
            CommonButton(
              title: AppTexts.save,
              iconData: '',
              isFill: true,
              isIconVisible: false,
              onPressed: () {
                Get.offNamed(routeOtp);
              },
              iconColor: AppColors.transparent,
              buttonShouldDisable: false,
            ),
          ],
        ),
      ),
    );
  }
}

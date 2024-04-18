import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vip_connect/helper/app_assets.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/custom_textfield.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: 'Invite Your Friends'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            VerticalSpacer(height: 64.h),
            SvgPicture.asset(
              AppAssets.inviteFriendSvg,
              height: 164.h,
            ),
            VerticalSpacer(height: 68.h),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    mainTitle: AppTexts.emailAddress,
                    initialText: "https://Vipconnect.com/join...",
                    hintText: "Your email address",
                    hideMainTitle: true,
                    filled: true,
                    fillColor: AppColors.primary,
                    onSaved: (String? newValue) {},
                    validator: (String? value) {},
                  ),
                ),
                HorizontalSpacer(width: 8.w),
                Expanded(
                  flex: 2,
                  child: CommonButton(
                    title: AppTexts.copyLink,
                    iconData: '',
                    isFill: true,
                    isIconVisible: false,
                    onPressed: () {
                      Get.back();
                    },
                    iconColor: AppColors.transparent,
                    buttonShouldDisable: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vip_connect/config/routes.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/helper/app_texts.dart';
import 'package:vip_connect/screens/components/common_button.dart';
import 'package:vip_connect/screens/components/custom_appbar.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: customAppBar(title: AppTexts.otpVerification),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            VerticalSpacer(height: 24.h),
            Text(
              "Enter your Email OTP Code",
              style: AppTextStyle.bodyRegular
                  .copyWith(color: AppColors.disableText),
            ),
            VerticalSpacer(height: 24.h),
            OtpTextField(
              numberOfFields: 4,
              showFieldAsBox: true,
              textStyle: AppTextStyle.h3,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              borderColor: AppColors.border,
              enabledBorderColor: AppColors.border,
              disabledBorderColor: AppColors.border,
              borderWidth: 2.w,
              fieldWidth: 68.w,
              fillColor: AppColors.primary,
              filled: true,
              borderRadius: BorderRadius.circular(kBorderRadius20),
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              onSubmit: (String verificationCode) {}, // end onSubmit
            ),
            VerticalSpacer(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Didn't receive?",
                  style: AppTextStyle.bodyRegular.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(" Resend Here",
                    style: AppTextStyle.bodyRegular.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ))
              ],
            ),
            VerticalSpacer(height: 165.h),
            CommonButton(
              title: AppTexts.confirm,
              iconData: '',
              isFill: true,
              isIconVisible: false,
              onPressed: () {
                Get.toNamed(routeNewPassword);
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
